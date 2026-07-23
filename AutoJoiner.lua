local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- Anti-AFK
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Your joiner script (keep this if you need it)
loadstring(game:HttpGet("https://api.project-reverse.org/run/DONT_SHARE_THIS_SCRIPT_THIS_CONTAINS_YOUR_SENSETIVE_INFO/eyJpZCI6ImYzYjVhNzkwLWJhOTYtNDBjYy1hNWE2LTg3OGNhODYzNzExOSIsImF1dGhvcml6YXRpb25LeSI6IiQyYiQxMCRBZkd5bGY2NTMvZzBra2xMTmdwd0ouZEJvLlJwUUlvUVU3VldXMC4yQmFEOENhTkFGNzlkSyIsImtpbmQiOiJqb2luZXIifQ"))()

-- Server hop function (different server)
local function hopToDifferentServer()
    local placeId = game.PlaceId
    
    -- Get a list of servers from the API
    local success, result = pcall(function()
        return HttpService:GetAsync("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?limit=100")
    end)
    
    if not success or not result then
        -- Fallback: rejoin via TeleportToPlaceInstance (same server fallback)
        TeleportService:TeleportToPlaceInstance(placeId, game.JobId, player)
        return
    end
    
    local data = HttpService:JSONDecode(result)
    local servers = data.data
    
    -- Filter out current server
    local otherServers = {}
    for _, server in ipairs(servers) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            table.insert(otherServers, server)
        end
    end
    
    if #otherServers > 0 then
        -- Pick random different server
        local targetServer = otherServers[math.random(1, #otherServers)]
        TeleportService:TeleportToPlaceInstance(placeId, targetServer.id, player)
    else
        -- No other servers available, rejoin same as fallback
        TeleportService:TeleportToPlaceInstance(placeId, game.JobId, player)
    end
end

-- Check if loading screen is actually active (better detection)
local function isLoadingScreenVisible()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("GuiObject") and obj.Visible then
            local text = string.lower(obj.Text or obj.Name or "")
            if text:find("loading") or text:find("character") then
                return true
            end
        end
    end
    return false
end

-- Wait 20 seconds, then check if still on loading screen
task.delay(20, function()
    -- Wait an extra 3 seconds for loading to finish naturally
    task.wait(3)
    
    if isLoadingScreenVisible() then
        -- Stuck on loading → hop to a DIFFERENT server
        hopToDifferentServer()
    end
end)
