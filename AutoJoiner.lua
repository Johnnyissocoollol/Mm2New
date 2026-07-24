local VirtualUser = game:GetService("VirtualUser")

game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Execute Project Reverse script once
loadstring(game:HttpGet("https://api.project-reverse.org/run/DONT_SHARE_THIS_SCRIPT_THIS_CONTAINS_YOUR_SENSETIVE_INFO/eyJpZCI6ImYzYjVhNzkwLWJhOTYtNDBjYy1hNWE2LTg3OGNhODYzNzExOSIsImF1dGhvcml6YXRpb25LZXkiOiIkMmIkMTAkQWZHeWxmNjUzL2cwa2tsTE5ncHdKLmRCby5ScVBJb1FVN1ZXVzAuMkJhRDhDYU5BRjc5ZEsiLCJraW5kIjoiam9pbmVyIn0"))()

-- Server hop every 14 minutes (840 seconds)
local serverHopModule = loadstring(game:HttpGet"https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua")()

while true do
    wait(840) -- 14 minutes in seconds
    serverHopModule:Teleport(game.PlaceId)
end
