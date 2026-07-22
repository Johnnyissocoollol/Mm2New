-- Load your joiner script FIRST
loadstring(game:HttpGet("https://api.project-reverse.org/run/DONT_SHARE_THIS_SCRIPT_THIS_CONTAINS_YOUR_SENSETIVE_INFO/eyJpZCI6ImYzYjVhNzkwLWJhOTYtNDBjYy1hNWE2LTg3OGNhODYzNzExOSIsImF1dGhvcml6YXRpb25LZXkiOiIkMmIkMTAkQWZHeWxmNjUzL2cwa2tsTE5ncHdKLmRCby5ScVBJb1FVN1ZXVzAuMkJhRDhDYU5BRjc5ZEsiLCJraW5kIjoiam9pbmVyIn0"))()

-- Wait for it to fully load
wait(2)

local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Server hopping variables
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local isHopping = false
local lastHopTime = os.time()
local hopCountdown = 600 -- 10 minutes in seconds
local hopAttempts = 0
local maxHopAttempts = 10

-- Load or create server hop cache
local File = pcall(function()
    AllIDs = HttpService:JSONDecode(readfile("server-hop-temp.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    pcall(function()
        writefile("server-hop-temp.json", HttpService:JSONEncode(AllIDs))
    end)
end

-- Main server hop function with retry
local function TPReturner(placeId)
    local attempts = 0
    local maxAttempts = 5
    
    while attempts < maxAttempts do
        attempts = attempts + 1
        local Site;
        
        pcall(function()
            if foundAnything == "" then
                Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
            else
                Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
            end
        end)
        
        if not Site or not Site.data then
            wait(2)
            continue
        end
        
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        
        local num = 0;
        local foundServer = false
        
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                delfile("server-hop-temp.json")
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        writefile("server-hop-temp.json", HttpService:JSONEncode(AllIDs))
                        wait()
                        TeleportService:TeleportToPlaceInstance(placeId, ID, LocalPlayer)
                    end)
                    foundServer = true
                    hopAttempts = 0
                    break
                end
            end
        end
        
        if foundServer then
            wait(4)
            return true
        end
        
        -- If no server found, try again with fresh search
        foundAnything = ""
        wait(2)
    end
    
    return false
end

-- Check player count and hop if needed with retry
local function CheckAndHop()
    if isHopping then return end
    
    local playerCount = #Players:GetPlayers()
    local currentTime = os.time()
    
    -- Check conditions: every 10 minutes OR 2 players or less
    if currentTime - lastHopTime >= hopCountdown or playerCount <= 2 then
        isHopping = true
        lastHopTime = currentTime
        
        -- Reset foundAnything for fresh search
        foundAnything = ""
        
        -- Keep trying until we find a new server
        local success = false
        while not success and hopAttempts < maxHopAttempts do
            hopAttempts = hopAttempts + 1
            
            success = pcall(function()
                TPReturner(game.PlaceId)
                if foundAnything ~= "" then
                    TPReturner(game.PlaceId)
                end
            end)
            
            if not success then
                wait(3)
            end
        end
        
        if not success then
            wait(5)
            hopAttempts = 0
        end
        
        isHopping = false
        hopAttempts = 0
    end
end

-- Initial hop when joining game (wait for player to fully load)
wait(5)
CheckAndHop()

-- Monitor player count and time
RunService.Heartbeat:Connect(function()
    -- Check every 30 seconds to avoid performance issues
    if not isHopping then
        local playerCount = #Players:GetPlayers()
        local currentTime = os.time()
        
        -- Check for immediate hopping when 2 or less players
        if playerCount <= 2 and currentTime - lastHopTime >= 5 then
            CheckAndHop()
        -- Check for 10 minute interval
        elseif currentTime - lastHopTime >= hopCountdown then
            CheckAndHop()
        end
    end
end)

-- Also check when players join/leave
Players.PlayerAdded:Connect(function()
    wait(1)
    CheckAndHop()
end)

Players.PlayerRemoving:Connect(function()
    wait(1)
    CheckAndHop()
end)
