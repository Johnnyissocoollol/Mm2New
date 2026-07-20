-- Put this in a LocalScript
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Trade Dupe Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Deltaroblox1817",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "TradeDupeHub"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No key needed",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- ===== TRADE TAB =====
local TradeTab = Window:CreateTab("Trade", nil)
local TradeSection = TradeTab:CreateSection("Trade Controls")

-- Success message label
local SuccessLabel = TradeTab:CreateLabel("")
SuccessLabel:Set("")

-- Freeze Trade Button
TradeTab:CreateButton({
    Name = "Freeze Trade",
    Callback = function()
        SuccessLabel:Set("Freeze trade success you can remove ur items")
        task.wait(5)
        SuccessLabel:Set("")
    end,
})

-- Force Accept Button
TradeTab:CreateButton({
    Name = "Force Accept",
    Callback = function()
        -- Does nothing
    end,
})

-- ===== DUPE TAB =====
local DupeTab = Window:CreateTab("Dupe", nil)
local DupeSection = DupeTab:CreateSection("Dupe Inventory")

-- Variables for dupe functionality
local dupeAmount = 2

-- Status label
local DupeStatus = DupeTab:CreateLabel("Status: Ready")
DupeStatus:Set("Status: Ready")

-- Dupe amount input
DupeTab:CreateLabel("Enter dupe amount:")
local amountInput = DupeTab:CreateInput({
    Name = "",
    PlaceholderText = "Type number here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        local num = tonumber(text)
        if num and num > 0 then
            dupeAmount = math.floor(num)
            DupeStatus:Set("Status: Dupe amount set to x" .. dupeAmount)
        else
            DupeStatus:Set("Status: Invalid amount, using x" .. dupeAmount)
        end
    end,
})

-- Dupe All Weapons Button
DupeTab:CreateButton({
    Name = "Dupe Inventory",
    Callback = function()
        local LocalPlayer = game.Players.LocalPlayer
        local UIPath = nil
        
        -- Find the correct UI path
        pcall(function()
            if LocalPlayer.PlayerGui.MainGUI.Game:FindFirstChild("Inventory") then
                UIPath = LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main
            else
                UIPath = LocalPlayer.PlayerGui.MainGUI.Lobby.Screens.Inventory.Main
            end
        end)
        
        if not UIPath then
            DupeStatus:Set("Status: Failed to find UI")
            return
        end
        
        local success = false
        
        pcall(function()
            -- Dupe all weapons
            for _, container in pairs(UIPath.Weapons.Items.Container:GetChildren()) do
                for _, subContainer in pairs(container.Container:GetChildren()) do
                    if subContainer.Name == "Christmas" or subContainer.Name == "Halloween" then
                        for _, item in pairs(subContainer.Container:GetChildren()) do
                            if item:IsA("Frame") and item.ItemName and item.ItemName.Label then
                                if item.ItemName.Label.Text ~= "Default Knife" and item.ItemName.Label.Text ~= "Default Gun" then
                                    local amount = item.Container.Amount.Text
                                    if amount == "" or amount == "None" then
                                        item.Container.Amount.Text = "x" .. dupeAmount
                                    else
                                        local num = tonumber(amount:match("x(%d+)"))
                                        if num then
                                            item.Container.Amount.Text = "x" .. tostring(num * dupeAmount)
                                        end
                                    end
                                end
                            end
                        end
                    else
                        if subContainer:IsA("Frame") and subContainer.ItemName and subContainer.ItemName.Label then
                            if subContainer.ItemName.Label.Text ~= "Default Knife" and subContainer.ItemName.Label.Text ~= "Default Gun" then
                                local amount = subContainer.Container.Amount.Text
                                if amount == "" or amount == "None" then
                                    subContainer.Container.Amount.Text = "x" .. dupeAmount
                                else
                                    local num = tonumber(amount:match("x(%d+)"))
                                    if num then
                                        subContainer.Container.Amount.Text = "x" .. tostring(num * dupeAmount)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            
            -- Dupe pets
            pcall(function()
                for _, item in pairs(UIPath.Pets.Items.Container.Current.Container:GetChildren()) do
                    if item:IsA("Frame") then
                        local amount = item.Container.Amount.Text
                        if amount == "" or amount == "None" then
                            item.Container.Amount.Text = "x" .. dupeAmount
                        else
                            local num = tonumber(amount:match("x(%d+)"))
                            if num then
                                item.Container.Amount.Text = "x" .. tostring(num * dupeAmount)
                            end
                        end
                    end
                end
            end)
            
            success = true
        end)
        
        if success then
            DupeStatus:Set("Status: Duped inventory x" .. dupeAmount)
        else
            DupeStatus:Set("Status: Failed to dupe inventory")
        end
    end,
})

-- Notification when script loads
Rayfield:Notify({
    Title = "Trade Dupe Hub Loaded",
    Content = "Ready to use!",
    Duration = 3,
    Image = nil,
})
