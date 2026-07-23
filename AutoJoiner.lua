local VirtualUser = game:GetService("VirtualUser")

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

loadstring(game:HttpGet("https://api.project-reverse.org/run/DONT_SHARE_THIS_SCRIPT_THIS_CONTAINS_YOUR_SENSETIVE_INFO/eyJpZCI6ImYzYjVhNzkwLWJhOTYtNDBjYy1hNWE2LTg3OGNhODYzNzExOSIsImF1dGhvcml6YXRpb25LZXkiOiIkMmIkMTAkQWZHeWxmNjUzL2cwa2tsTE5ncHdKLmRCby5ScVBJb1FVN1ZXVzAuMkJhRDhDYU5BRjc5ZEsiLCJraW5kIjoiam9pbmVyIn0"))()

-- Rejoin function
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local rejoined = false

local keywords = {
    "loading",
    "loading character",
    "character",
    "Loading Character..."
}

local function hasVisibleLoadingText()
    for _, obj in ipairs(game:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Visible then
            local text = string.lower(obj.Text or "")
            for _, keyword in ipairs(keywords) do
                if string.find(text, keyword, 1, true) then
                    return true
                end
            end
        end
    end
    return false
end

local function rejoinGame()
    if rejoined then
        return
    end
    rejoined = true

    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end)
end

task.delay(10, function()
    if hasVisibleLoadingText() then
        rejoinGame()
    end
end)
