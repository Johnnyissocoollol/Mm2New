
if getgenv().Piggy100PlayersLoaded then return end
getgenv().Piggy100PlayersLoaded = true

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

local SelectedNPC         = nil
local SavedCharacter      = nil
local NPCWalkSpeed        = 16
local NPCJumpPower        = 50
local FollowLoop          = nil
local ControlLoop         = nil
local SpeedLoop           = nil
local GrabLoop            = nil
local NPCNoclipLoop       = nil
local FreezeLoop          = nil
local NearbyJumpLoop      = nil
local ChaseLoop           = nil
local AllNPCSpeedLoop     = nil
local NPCChaseLoop        = nil
local LoopGotoLoop        = nil
local LoopSpeedNPCLoop    = nil
local LoopSpeedAllLoop    = nil
local PlayerNoclipLoop    = nil
local InfJumpConn         = nil
local TeleportToolEnabled = false
local FlingSelectMode     = false
local FlingSelectConn     = nil
local DoorSpamLoop        = nil
local CycleItemsLoop      = nil

local function IsNPC(model)
    if not model then return false end
    local h = model:FindFirstChildOfClass("Humanoid")
    return h ~= nil and Players:GetPlayerFromCharacter(model) == nil
end

local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end

local C = {
    bg      = Color3.fromRGB(15, 15, 15),
    panel   = Color3.fromRGB(20, 20, 20),
    card    = Color3.fromRGB(26, 26, 26),
    border  = Color3.fromRGB(38, 38, 38),
    accent  = Color3.fromRGB(180, 180, 180),
    accentD = Color3.fromRGB(50, 50, 50),
    green   = Color3.fromRGB(80, 170, 90),
    red     = Color3.fromRGB(180, 55, 55),
    text    = Color3.fromRGB(195, 195, 195),
    sub     = Color3.fromRGB(85, 85, 85),
    white   = Color3.fromRGB(210, 210, 210),
    tabOn   = Color3.fromRGB(32, 32, 32),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "Piggy100PlayersGui"
ScreenGui.ResetOnSpawn   = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = LocalPlayer:WaitForChild("PlayerGui")

local MiniBar = Instance.new("Frame")
MiniBar.Name             = "MiniBar"
MiniBar.Size             = UDim2.new(0, 150, 0, 24)
MiniBar.Position         = UDim2.new(0.5, -75, 0, 6)
MiniBar.BackgroundColor3 = C.panel
MiniBar.BorderSizePixel  = 0
MiniBar.Visible          = false
MiniBar.Active           = true
MiniBar.Draggable        = true
MiniBar.Parent           = ScreenGui
Instance.new("UICorner", MiniBar).CornerRadius = UDim.new(0, 4)
do local s = Instance.new("UIStroke", MiniBar); s.Color = C.border; s.Thickness = 1 end

local MiniLbl = Instance.new("TextLabel")
MiniLbl.Size = UDim2.new(1, -62, 1, 0); MiniLbl.Position = UDim2.new(0, 8, 0, 0)
MiniLbl.BackgroundTransparency = 1; MiniLbl.Font = Enum.Font.GothamBold
MiniLbl.TextSize = 10; MiniLbl.TextColor3 = C.sub
MiniLbl.TextXAlignment = Enum.TextXAlignment.Left; MiniLbl.Text = "Piggy 100"
MiniLbl.Parent = MiniBar

local MiniOpen = Instance.new("TextButton")
MiniOpen.Size = UDim2.new(0, 46, 0, 16); MiniOpen.Position = UDim2.new(1, -50, 0.5, -8)
MiniOpen.BackgroundColor3 = C.accentD; MiniOpen.Font = Enum.Font.GothamBold
MiniOpen.TextSize = 9; MiniOpen.TextColor3 = C.white
MiniOpen.Text = "open"; MiniOpen.BorderSizePixel = 0; MiniOpen.Parent = MiniBar
Instance.new("UICorner", MiniOpen).CornerRadius = UDim.new(0, 3)
do local s = Instance.new("UIStroke", MiniOpen); s.Color = C.border; s.Thickness = 1 end

local Main = Instance.new("Frame")
Main.Name = "Main"; Main.Size = UDim2.new(0, 260, 0, 360)
Main.Position = UDim2.new(0.5, -130, 0.5, -180)
Main.BackgroundColor3 = C.bg; Main.BorderSizePixel = 0
Main.Active = true; Main.Draggable = true; Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)
do local s = Instance.new("UIStroke", Main); s.Color = C.border; s.Thickness = 1 end

local TBar = Instance.new("Frame")
TBar.Size = UDim2.new(1, 0, 0, 32); TBar.BackgroundColor3 = C.panel
TBar.BorderSizePixel = 0; TBar.Parent = Main
Instance.new("UICorner", TBar).CornerRadius = UDim.new(0, 6)
do
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0.5, 0); f.Position = UDim2.new(0, 0, 0.5, 0)
    f.BackgroundColor3 = C.panel; f.BorderSizePixel = 0; f.Parent = TBar
end

local TAccent = Instance.new("Frame")
TAccent.Size = UDim2.new(0, 2, 0, 14); TAccent.Position = UDim2.new(0, 10, 0.5, -7)
TAccent.BackgroundColor3 = C.accent; TAccent.BorderSizePixel = 0; TAccent.Parent = TBar
Instance.new("UICorner", TAccent).CornerRadius = UDim.new(1, 0)

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, -54, 1, 0); TitleLbl.Position = UDim2.new(0, 18, 0, 0)
TitleLbl.BackgroundTransparency = 1; TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 11; TitleLbl.TextColor3 = C.text
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Text = "Piggy 100 Players"; TitleLbl.Parent = TBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 22, 0, 22); MinBtn.Position = UDim2.new(1, -28, 0.5, -11)
MinBtn.BackgroundColor3 = C.card; MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 13; MinBtn.TextColor3 = C.sub
MinBtn.Text = "–"; MinBtn.BorderSizePixel = 0; MinBtn.Parent = TBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

local function ShowMain() Main.Visible = true; MiniBar.Visible = false end
local function HideMain() Main.Visible = false; MiniBar.Visible = true end
MinBtn.MouseButton1Click:Connect(HideMain)
MiniOpen.MouseButton1Click:Connect(ShowMain)

local SBar = Instance.new("Frame")
SBar.Size = UDim2.new(1, -14, 0, 22); SBar.Position = UDim2.new(0, 7, 0, 38)
SBar.BackgroundColor3 = C.card; SBar.BorderSizePixel = 0; SBar.Parent = Main
Instance.new("UICorner", SBar).CornerRadius = UDim.new(0, 4)
do local s = Instance.new("UIStroke", SBar); s.Color = C.border; s.Thickness = 1 end

local SDot = Instance.new("Frame")
SDot.Size = UDim2.new(0, 5, 0, 5); SDot.Position = UDim2.new(0, 8, 0.5, -2)
SDot.BackgroundColor3 = C.sub; SDot.BorderSizePixel = 0; SDot.Parent = SBar
Instance.new("UICorner", SDot).CornerRadius = UDim.new(1, 0)

local SLbl = Instance.new("TextLabel")
SLbl.Size = UDim2.new(1, -22, 1, 0); SLbl.Position = UDim2.new(0, 18, 0, 0)
SLbl.BackgroundTransparency = 1; SLbl.Font = Enum.Font.Gotham
SLbl.TextSize = 10; SLbl.TextColor3 = C.sub
SLbl.TextXAlignment = Enum.TextXAlignment.Left
SLbl.Text = "No NPC selected"; SLbl.Parent = SBar

local function SetStatus(text, color)
    SLbl.Text = text; SDot.BackgroundColor3 = color or C.sub; SLbl.TextColor3 = color or C.sub
end

local TabRow = Instance.new("Frame")
TabRow.Size = UDim2.new(1, -14, 0, 24); TabRow.Position = UDim2.new(0, 7, 0, 66)
TabRow.BackgroundTransparency = 1; TabRow.Parent = Main
local TRL = Instance.new("UIListLayout", TabRow)
TRL.FillDirection = Enum.FillDirection.Horizontal
TRL.Padding = UDim.new(0, 2); TRL.SortOrder = Enum.SortOrder.LayoutOrder

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -14, 1, -100); Content.Position = UDim2.new(0, 7, 0, 96)
Content.BackgroundTransparency = 1; Content.ClipsDescendants = true; Content.Parent = Main

local Tabs = {}
local function MakeTab(name, order)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 1, 0); Btn.BackgroundColor3 = C.card
    Btn.Font = Enum.Font.GothamSemibold; Btn.TextSize = 9
    Btn.TextColor3 = C.sub; Btn.Text = name
    Btn.BorderSizePixel = 0; Btn.LayoutOrder = order; Btn.Parent = TabRow
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0; Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = C.border; Page.Visible = false; Page.Parent = Content

    local PL = Instance.new("UIListLayout", Page)
    PL.Padding = UDim.new(0, 4); PL.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", Page).PaddingBottom = UDim.new(0, 8)
    PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PL.AbsoluteContentSize.Y + 10)
    end)

    local tab = {Btn = Btn, Page = Page}
    table.insert(Tabs, tab)
    Btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do
            t.Page.Visible = false
            t.Btn.BackgroundColor3 = C.card
            t.Btn.TextColor3 = C.sub
        end
        Page.Visible = true
        Btn.BackgroundColor3 = C.tabOn
        Btn.TextColor3 = C.accent
    end)
    return tab
end

local TabHome     = MakeTab("Home",     1)
local TabMisc     = MakeTab("Misc",     2)
local TabTP       = MakeTab("TP",       3)
local TabSurvivor = MakeTab("Survivor", 4)
local TabNPC      = MakeTab("NPC",      5)

TabHome.Page.Visible = true
TabHome.Btn.BackgroundColor3 = C.tabOn
TabHome.Btn.TextColor3 = C.accent

local function MakeCard(parent, order, h)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, h or 30); F.BackgroundColor3 = C.card
    F.BorderSizePixel = 0; F.LayoutOrder = order or 0; F.Parent = parent
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
    do local s = Instance.new("UIStroke", F); s.Color = C.border; s.Thickness = 1 end
    return F
end

local function AddButton(parent, label, order, cb)
    local Card = MakeCard(parent, order)
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -72, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.BackgroundTransparency = 1; Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 11; Lbl.TextColor3 = C.text
    Lbl.TextXAlignment = Enum.TextXAlignment.Left; Lbl.Text = label; Lbl.Parent = Card

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 50, 0, 18); Btn.Position = UDim2.new(1, -58, 0.5, -9)
    Btn.BackgroundColor3 = C.accentD; Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 10; Btn.TextColor3 = C.white; Btn.Text = "run"
    Btn.BorderSizePixel = 0; Btn.Parent = Card
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 3)
    do local s = Instance.new("UIStroke", Btn); s.Color = C.border; s.Thickness = 1 end

    Btn.MouseEnter:Connect(function() Tween(Btn, {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}) end)
    Btn.MouseLeave:Connect(function() Tween(Btn, {BackgroundColor3 = C.accentD}) end)
    Btn.MouseButton1Click:Connect(function()
        Tween(Btn, {BackgroundColor3 = C.green})
        task.delay(0.2, function() Tween(Btn, {BackgroundColor3 = C.accentD}) end)
        cb()
    end)
    return Card
end

local function AddToggle(parent, label, order, cb)
    local Card = MakeCard(parent, order)
    local On = false

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -55, 1, 0); Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.BackgroundTransparency = 1; Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 11; Lbl.TextColor3 = C.text
    Lbl.TextXAlignment = Enum.TextXAlignment.Left; Lbl.Text = label; Lbl.Parent = Card

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0, 34, 0, 18); Track.Position = UDim2.new(1, -42, 0.5, -9)
    Track.BackgroundColor3 = C.border; Track.BorderSizePixel = 0; Track.Parent = Card
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12); Knob.Position = UDim2.new(0, 3, 0.5, -6)
    Knob.BackgroundColor3 = C.sub; Knob.BorderSizePixel = 0; Knob.Parent = Track
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local Hitbox = Instance.new("TextButton")
    Hitbox.Size = UDim2.new(1, 0, 1, 0); Hitbox.BackgroundTransparency = 1
    Hitbox.Text = ""; Hitbox.Parent = Card

    local function Set(val)
        On = val
        if On then
            Tween(Track, {BackgroundColor3 = Color3.fromRGB(75, 160, 85)})
            Tween(Knob, {Position = UDim2.new(0, 19, 0.5, -6), BackgroundColor3 = C.white})
        else
            Tween(Track, {BackgroundColor3 = C.border})
            Tween(Knob, {Position = UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = C.sub})
        end
        cb(On)
    end
    Hitbox.MouseButton1Click:Connect(function() Set(not On) end)
    return Card, Set
end

local function AddSlider(parent, label, min, max, default, suffix, order, cb)
    local Card = MakeCard(parent, order, 46)

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, -54, 0, 18); Lbl.Position = UDim2.new(0, 10, 0, 4)
    Lbl.BackgroundTransparency = 1; Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 11; Lbl.TextColor3 = C.text
    Lbl.TextXAlignment = Enum.TextXAlignment.Left; Lbl.Text = label; Lbl.Parent = Card

    local ValLbl = Instance.new("TextLabel")
    ValLbl.Size = UDim2.new(0, 46, 0, 18); ValLbl.Position = UDim2.new(1, -54, 0, 4)
    ValLbl.BackgroundTransparency = 1; ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 10; ValLbl.TextColor3 = C.accent
    ValLbl.TextXAlignment = Enum.TextXAlignment.Right
    ValLbl.Text = tostring(default) .. (suffix and (" " .. suffix) or ""); ValLbl.Parent = Card

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -20, 0, 3); Track.Position = UDim2.new(0, 10, 0, 34)
    Track.BackgroundColor3 = C.border; Track.BorderSizePixel = 0; Track.Parent = Card
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = C.accent; Fill.BorderSizePixel = 0; Fill.Parent = Track
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Thumb = Instance.new("Frame")
    Thumb.Size = UDim2.new(0, 10, 0, 10)
    Thumb.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    Thumb.BackgroundColor3 = Color3.fromRGB(190, 190, 190); Thumb.BorderSizePixel = 0; Thumb.Parent = Track
    Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)

    local Value = default
    local Drag = false
    local function Update(x)
        local a = Track.AbsolutePosition.X; local s = Track.AbsoluteSize.X
        local t = math.clamp((x - a) / s, 0, 1)
        Value = math.round(min + t * (max - min))
        Fill.Size = UDim2.new(t, 0, 1, 0); Thumb.Position = UDim2.new(t, -5, 0.5, -5)
        ValLbl.Text = tostring(Value) .. (suffix and (" " .. suffix) or ""); cb(Value)
    end

    local HB = Instance.new("TextButton")
    HB.Size = UDim2.new(1, 0, 4, 0); HB.Position = UDim2.new(0, 0, 0.5, -8)
    HB.BackgroundTransparency = 1; HB.Text = ""; HB.Parent = Track

    HB.MouseButton1Down:Connect(function() Drag = true; Update(UserInputService:GetMouseLocation().X) end)
    UserInputService.InputChanged:Connect(function(i)
        if Drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            Update(UserInputService:GetMouseLocation().X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then Drag = false end
    end)
    return Card
end

local function AddSep(parent, order, text)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 16); F.BackgroundTransparency = 1
    F.LayoutOrder = order or 0; F.Parent = parent

    local L = Instance.new("Frame")
    L.Size = UDim2.new(1, 0, 0, 1); L.Position = UDim2.new(0, 0, 0.5, 0)
    L.BackgroundColor3 = C.border; L.BorderSizePixel = 0; L.Parent = F

    if text then
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0, #text * 5.2 + 12, 1, 0); bg.Position = UDim2.new(0, 4, 0, 0)
        bg.BackgroundColor3 = C.bg; bg.BorderSizePixel = 0; bg.Parent = F

        local Lbl = Instance.new("TextLabel")
        Lbl.Size = UDim2.new(1, 0, 1, 0); Lbl.BackgroundTransparency = 1
        Lbl.Font = Enum.Font.Gotham; Lbl.TextSize = 9
        Lbl.TextColor3 = C.sub; Lbl.Text = text; Lbl.Parent = bg
    end
end

local TH = Instance.new("Frame")
TH.Size = UDim2.new(0, 240, 0, 180); TH.Position = UDim2.new(1, -248, 1, -186)
TH.BackgroundTransparency = 1; TH.Parent = ScreenGui
local THL = Instance.new("UIListLayout", TH)
THL.VerticalAlignment = Enum.VerticalAlignment.Bottom; THL.Padding = UDim.new(0, 4)

local function Toast(title, body, color)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 44); card.BackgroundColor3 = C.panel
    card.BackgroundTransparency = 1; card.BorderSizePixel = 0; card.Parent = TH
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 4)
    do local s = Instance.new("UIStroke", card); s.Color = color or C.accent; s.Thickness = 1 end

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 5, 0, 5); dot.Position = UDim2.new(0, 9, 0, 9)
    dot.BackgroundColor3 = color or C.accent; dot.BorderSizePixel = 0; dot.Parent = card
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local t1 = Instance.new("TextLabel")
    t1.Size = UDim2.new(1, -22, 0, 16); t1.Position = UDim2.new(0, 20, 0, 5)
    t1.BackgroundTransparency = 1; t1.Font = Enum.Font.GothamBold
    t1.TextSize = 11; t1.TextColor3 = C.text; t1.TextXAlignment = Enum.TextXAlignment.Left
    t1.Text = title; t1.Parent = card

    local t2 = Instance.new("TextLabel")
    t2.Size = UDim2.new(1, -22, 0, 14); t2.Position = UDim2.new(0, 20, 0, 22)
    t2.BackgroundTransparency = 1; t2.Font = Enum.Font.Gotham
    t2.TextSize = 10; t2.TextColor3 = C.sub; t2.TextXAlignment = Enum.TextXAlignment.Left
    t2.Text = body; t2.Parent = card

    Tween(card, {BackgroundTransparency = 0}, 0.16)
    task.delay(3, function()
        Tween(card, {BackgroundTransparency = 1}, 0.22)
        task.wait(0.28); card:Destroy()
    end)
end

local function DeselectNPC()
    if SelectedNPC then SetStatus("No NPC selected", C.sub); SelectedNPC = nil end
end

local SelectConn = nil
local function StartSelectMode()
    SelectConn = Mouse.Button1Down:Connect(function()
        local target = Mouse.Target; if not target then return end
        local model = target:FindFirstAncestorOfClass("Model")
        if not model or not IsNPC(model) then return end
        if SelectedNPC then return end
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if not hrp or hrp.Anchored then Toast("No Ownership", model.Name .. " is anchored", C.red); return end
        SelectedNPC = model; SetStatus("Selected: " .. model.Name, C.green)
    end)
end
local function StopSelectMode()
    if SelectConn then SelectConn:Disconnect(); SelectConn = nil end
end

local function StartForceControl()
    if ControlLoop then ControlLoop:Disconnect() end
    ControlLoop = RunService.RenderStepped:Connect(function()
        if not SelectedNPC then return end
        if LocalPlayer.Character ~= SelectedNPC then LocalPlayer.Character = SelectedNPC end
        local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
        if h then
            Workspace.CurrentCamera.CameraSubject = h
            h.AutoRotate = true; h.PlatformStand = false
            h.WalkSpeed = NPCWalkSpeed; h.JumpPower = NPCJumpPower
            if h:GetState() == Enum.HumanoidStateType.Seated then h.Sit = false end
            if h:GetState() == Enum.HumanoidStateType.Physics then
                h:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
end
local function StopForceControl()
    if ControlLoop then ControlLoop:Disconnect(); ControlLoop = nil end
    if SavedCharacter then
        LocalPlayer.Character = SavedCharacter
        local h = SavedCharacter:FindFirstChildOfClass("Humanoid")
        if h then Workspace.CurrentCamera.CameraSubject = h end
    end
end

local function GiveTeleportTool()
    local bp = LocalPlayer:WaitForChild("Backpack")
    if bp:FindFirstChild("Teleport Tool") then bp["Teleport Tool"]:Destroy() end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Teleport Tool") then
        LocalPlayer.Character["Teleport Tool"]:Destroy()
    end
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false; tool.CanBeDropped = false; tool.Name = "Teleport Tool"
    tool.Activated:Connect(function()
        local c = LocalPlayer.Character; if not c then return end
        local h = Mouse.Hit
        if h then c:PivotTo(CFrame.new(h.Position + Vector3.new(0, 3, 0))) end
    end)
    tool.Parent = bp
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if TeleportToolEnabled then GiveTeleportTool() end
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        if sethiddenproperty then sethiddenproperty(LocalPlayer, "SimulationRadius", 150) end
    end)
end)

local function FlingNPC(npc)
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not myHrp then return end

    local behindCF = hrp.CFrame * CFrame.new(0, 0, 2.5)
    LocalPlayer.Character:PivotTo(behindCF)
    task.wait(0.05)

    for _, pt in pairs(npc:GetDescendants()) do
        if pt:IsA("BasePart") then pt.CanCollide = false end
    end

    local dir = (hrp.Position - myHrp.Position).Unit
    local flingVel = Vector3.new(dir.X * 500, 600, dir.Z * 500)

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = flingVel
    bv.Parent = hrp
    game:GetService("Debris"):AddItem(bv, 0.15)

    task.delay(3, function()
        for _, pt in pairs(npc:GetDescendants()) do
            if pt:IsA("BasePart") then pt.CanCollide = true end
        end
    end)
end

local hp = TabHome.Page

local logCard = MakeCard(hp, 1, 76)

local logTitle = Instance.new("TextLabel")
logTitle.Size = UDim2.new(1, -14, 0, 20); logTitle.Position = UDim2.new(0, 10, 0, 6)
logTitle.BackgroundTransparency = 1; logTitle.Font = Enum.Font.GothamBold
logTitle.TextSize = 11; logTitle.TextColor3 = C.accent
logTitle.TextXAlignment = Enum.TextXAlignment.Left; logTitle.Text = "Update 2.3"
logTitle.Parent = logCard

local logDiv = Instance.new("Frame")
logDiv.Size = UDim2.new(1, -20, 0, 1); logDiv.Position = UDim2.new(0, 10, 0, 28)
logDiv.BackgroundColor3 = C.border; logDiv.BorderSizePixel = 0; logDiv.Parent = logCard

local logBody = Instance.new("TextLabel")
logBody.Size = UDim2.new(1, -14, 0, 38); logBody.Position = UDim2.new(0, 10, 0, 34)
logBody.BackgroundTransparency = 1; logBody.Font = Enum.Font.Gotham
logBody.TextSize = 10; logBody.TextColor3 = C.text
logBody.TextXAlignment = Enum.TextXAlignment.Left
logBody.TextYAlignment = Enum.TextYAlignment.Top
logBody.TextWrapped = true; logBody.Text = "• Added new things"; logBody.Parent = logCard

local mp = TabMisc.Page
AddSep(mp, 1, "Player")

AddToggle(mp, "Noclip", 2, function(v)
    if v then
        PlayerNoclipLoop = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character; if not c then return end
            for _, pt in pairs(c:GetDescendants()) do
                if pt:IsA("BasePart") then pt.CanCollide = false end
            end
        end)
    else
        if PlayerNoclipLoop then PlayerNoclipLoop:Disconnect(); PlayerNoclipLoop = nil end
        local c = LocalPlayer.Character
        if c then
            for _, pt in pairs(c:GetDescendants()) do
                if pt:IsA("BasePart") then pt.CanCollide = true end
            end
        end
    end
end)

AddToggle(mp, "Infinite Jump", 3, function(v)
    if v then
        InfJumpConn = UserInputService.JumpRequest:Connect(function()
            local c = LocalPlayer.Character; if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid")
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if InfJumpConn then InfJumpConn:Disconnect(); InfJumpConn = nil end
    end
end)

do
    local udEnabled = false
    local udRenderConn, udTpwalkConn, udBv, udGyro
    local UD_SPEED = 16
    local UD_FLIP_OFFSET = 3.2
    local UD_TP_SPEED = 1.3

    local function udStopWalk()
        if udTpwalkConn then udTpwalkConn:Disconnect(); udTpwalkConn = nil end
    end

    local function udStartWalk(char, humanoid)
        udStopWalk()
        udTpwalkConn = RunService.Heartbeat:Connect(function(delta)
            if not char or not humanoid or not humanoid.Parent then udStopWalk() return end
            if humanoid.MoveDirection.Magnitude > 0 then
                char:TranslateBy(humanoid.MoveDirection * UD_TP_SPEED * delta * 10)
            end
        end)
    end

    local function udEnable(char)
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not root or not humanoid then return end
        humanoid.PlatformStand = true

        udBv = Instance.new("BodyVelocity")
        udBv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        udBv.Velocity = Vector3.zero
        udBv.Parent = root

        udGyro = Instance.new("BodyGyro")
        udGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        udGyro.P = 1e6
        udGyro.D = 200
        udGyro.Parent = root

        udStartWalk(char, humanoid)

        udRenderConn = RunService.RenderStepped:Connect(function()
            if not root or not root.Parent then return end
            local cam = Workspace.CurrentCamera
            local camCF = cam.CFrame
            local forward = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z).Unit
            local right   = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z).Unit
            local move = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + forward end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - forward end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - right end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + right end
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {char}
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            local result = Workspace:Raycast(root.Position, Vector3.new(0, -20, 0), rayParams)
            local targetY = result and (result.Position.Y + UD_FLIP_OFFSET) or root.Position.Y
            local yVel = (targetY - root.Position.Y) * 10
            udBv.Velocity = (move.Magnitude > 0 and move.Unit * UD_SPEED or Vector3.zero) + Vector3.new(0, yVel, 0)
            local facingDir = move.Magnitude > 0 and move.Unit or forward
            udGyro.CFrame = CFrame.new(Vector3.zero, facingDir) * CFrame.Angles(math.rad(180), 0, 0)
        end)
    end

    local function udDisable(char)
        if udRenderConn then udRenderConn:Disconnect(); udRenderConn = nil end
        udStopWalk()
        if udBv then udBv:Destroy(); udBv = nil end
        if udGyro then udGyro:Destroy(); udGyro = nil end
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end

    AddToggle(mp, "FE Upside Down", 4, function(v)
        udEnabled = v
        local c = LocalPlayer.Character
        if v then
            if c then udEnable(c) end
        else
            if c then udDisable(c) end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        if udEnabled then task.wait(1); udEnable(char) end
    end)
end

AddSep(mp, 5, "Fly GUI")

AddButton(mp, "Fly Gui", 6, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end)

AddSep(mp, 8, "Speed")

AddSlider(mp, "WalkSpeed", 8, 100, 16, "spd", 9, function(v)
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end
end)

AddButton(mp, "Reset Speed", 10, function()
    local c = LocalPlayer.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
end)

AddSep(mp, 11, "Happymod Fly")

do
    local hmEnabled = false
    local hmStateConn = nil
    local hmHoldConn = nil
    local hmJumping = false

    local function hmStopHold()
        hmJumping = false
        if hmHoldConn then hmHoldConn:Disconnect(); hmHoldConn = nil end
    end

    local function hmStartHold()
        if hmHoldConn then return end
        hmJumping = true
        hmHoldConn = RunService.Heartbeat:Connect(function()
            if not hmJumping then return end
            local c = LocalPlayer.Character; if not c then return end
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Swimming) end
        end)
    end

    local function hmHookChar(char)
        if hmStateConn then hmStateConn:Disconnect(); hmStateConn = nil end
        local hum = char:WaitForChild("Humanoid")
        hmStateConn = hum.StateChanged:Connect(function(_, new)
            if not hmEnabled then return end
            if new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall then
                hmStartHold()
            elseif new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Dead
                or new == Enum.HumanoidStateType.Running or new == Enum.HumanoidStateType.Swimming then
                hmStopHold()
            end
        end)
    end

    AddToggle(mp, "Happymod Fly", 12, function(v)
        hmEnabled = v
        if v then
            local c = LocalPlayer.Character
            if c then hmHookChar(c) end
        else
            hmStopHold()
            if hmStateConn then hmStateConn:Disconnect(); hmStateConn = nil end
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        hmStopHold()
        if hmEnabled then hmHookChar(char) end
    end)
end

AddSep(mp, 13, "Tools")

AddToggle(mp, "Teleport Tool", 14, function(v)
    TeleportToolEnabled = v
    if v then
        GiveTeleportTool()
    else
        local bp = LocalPlayer.Backpack
        if bp:FindFirstChild("Teleport Tool") then bp["Teleport Tool"]:Destroy() end
        local ch = LocalPlayer.Character
        if ch and ch:FindFirstChild("Teleport Tool") then ch["Teleport Tool"]:Destroy() end
    end
end)

AddSep(mp, 15, "Server")

AddButton(mp, "Rejoin Server", 16, function()
    local TeleportService = game:GetService("TeleportService")
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)



local tp = TabTP.Page
AddSep(tp, 1, "Presets")

local tps = {
    {"Piggy Room", Vector3.new(-842.2, -114.6, -474.2)},
    {"Home Menu",  Vector3.new(-458.4,   -9.4,   44.7)},
    {"MTF Area",   Vector3.new(-193.1,    3.5,  -499.9)},
}
for i, info in ipairs(tps) do
    local name, pos = info[1], info[2]
    AddButton(tp, name, i + 1, function()
        local c = LocalPlayer.Character
        if c then c:PivotTo(CFrame.new(pos)) end
    end)
end

AddSep(tp, 10, "Players")

do
    local tpPlrSelected = nil

    local SearchCard = MakeCard(tp, 11, 30)
    SearchCard.LayoutOrder = 11

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -16, 0, 22)
    SearchBox.Position = UDim2.new(0, 8, 0.5, -11)
    SearchBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    SearchBox.BorderSizePixel = 0
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 11
    SearchBox.TextColor3 = C.text
    SearchBox.PlaceholderText = "type player name..."
    SearchBox.PlaceholderColor3 = C.sub
    SearchBox.Text = ""
    SearchBox.ClearTextOnFocus = false
    SearchBox.Parent = SearchCard
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

    local DropFrame = Instance.new("Frame")
    DropFrame.Size = UDim2.new(1, 0, 0, 0)
    DropFrame.BackgroundTransparency = 1
    DropFrame.LayoutOrder = 12
    DropFrame.ClipsDescendants = false
    DropFrame.Parent = tp

    local DropLayout = Instance.new("UIListLayout", DropFrame)
    DropLayout.Padding = UDim.new(0, 2)
    DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DropFrame.Size = UDim2.new(1, 0, 0, DropLayout.AbsoluteContentSize.Y)
    end)

    local function MakeDropEntry(plr)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 26)
        btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextColor3 = C.text
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Text = "  " .. plr.Name
        btn.Parent = DropFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        do local s = Instance.new("UIStroke", btn); s.Color = C.border; s.Thickness = 1 end

        btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = C.tabOn}) end)
        btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Color3.fromRGB(26, 26, 26)}) end)

        btn.MouseButton1Click:Connect(function()
            tpPlrSelected = plr
            SearchBox.Text = plr.Name
            for _, c in pairs(DropFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            Toast("Selected", plr.Name, C.green)
        end)

        btn.TouchTap:Connect(function()
            tpPlrSelected = plr
            SearchBox.Text = plr.Name
            for _, c in pairs(DropFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            Toast("Selected", plr.Name, C.green)
        end)

        return btn
    end

    local function RebuildDrop(query)
        for _, c in pairs(DropFrame:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        if query == "" then return end
        local q = query:lower()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Name:lower():find(q, 1, true) then
                MakeDropEntry(plr)
            end
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        RebuildDrop(SearchBox.Text)
    end)

    SearchBox.FocusLost:Connect(function()
        task.wait(0.15)
        for _, c in pairs(DropFrame:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
    end)

    AddButton(tp, "Teleport To Player", 13, function()
        if not tpPlrSelected or not tpPlrSelected.Character then
            Toast("No Player", "Type and select one first", C.red) return
        end
        local hrp = tpPlrSelected.Character:FindFirstChild("HumanoidRootPart")
        local c = LocalPlayer.Character
        if hrp and c then
            c:PivotTo(hrp.CFrame * CFrame.new(3, 0, 0))
            Toast("Teleported", "To " .. tpPlrSelected.Name, C.green)
        end
    end)
end

AddSep(tp, 14, "NPC")
AddButton(tp, "Go To Selected NPC", 15, function()
    if not SelectedNPC or not LocalPlayer.Character then
        Toast("No NPC", "Select one first", C.red) return
    end
    LocalPlayer.Character:PivotTo(SelectedNPC:GetPivot() * CFrame.new(0, 0, 3))
end)

local sp = TabSurvivor.Page
AddSep(sp, 1, "Fling Bot")

AddToggle(sp, "Fling Select Mode", 2, function(v)
    FlingSelectMode = v
    if v then
        SetStatus("Click an NPC to fling", C.accent)
        FlingSelectConn = Mouse.Button1Down:Connect(function()
            if not FlingSelectMode then return end
            local target = Mouse.Target; if not target then return end
            local model = target:FindFirstAncestorOfClass("Model")
            if not model or not IsNPC(model) then return end
            FlingNPC(model)
            Toast("Flinged", model.Name .. " sent flying", C.green)
        end)
    else
        if FlingSelectConn then FlingSelectConn:Disconnect(); FlingSelectConn = nil end
        SetStatus("No NPC selected", C.sub)
    end
end)

AddSep(sp, 3, "Doors")

AddToggle(sp, "Spam Doors", 4, function(v)
    if v then
        DoorSpamLoop = true
        coroutine.wrap(function()
            while DoorSpamLoop do
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ClickDetector") and obj.Parent then
                        local n = string.lower(obj.Parent.Name or "")
                        if string.find(n, "door") then
                            fireclickdetector(obj)
                        end
                    end
                end
                task.wait(0.1)
            end
        end)()
    else
        DoorSpamLoop = false
    end
end)

AddButton(sp, "Unlock Door", 5, function()
    coroutine.wrap(function()
        for i = 1, 7 do
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ClickDetector") then
                    fireclickdetector(obj)
                end
            end
            task.wait(0.15)
        end
        Toast("Unlock Door", "Fired 7 times", C.green)
    end)()
end)

AddSep(sp, 6, "Items")

AddToggle(sp, "Loop Cycle Items", 7, function(v)
    if v then
        CycleItemsLoop = true
        coroutine.wrap(function()
            while CycleItemsLoop do
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ClickDetector") then
                        fireclickdetector(obj)
                    end
                end
                task.wait(0.15)
            end
        end)()
    else
        CycleItemsLoop = false
    end
end)

local np = TabNPC.Page

AddSep(np, 1, "Selection")

AddToggle(np, "Select Mode", 2, function(v)
    if v then StartSelectMode(); SetStatus("Tap an NPC to select", C.accent)
    else StopSelectMode(); DeselectNPC() end
end)

AddButton(np, "Deselect NPC", 3, function()
    DeselectNPC()
end)

AddSep(np, 4, "Actions")

AddButton(np, "Bring NPC to Me", 5, function()
    if not SelectedNPC or not LocalPlayer.Character then Toast("No NPC", "Select one first", C.red) return end
    local hrp = SelectedNPC:FindFirstChild("HumanoidRootPart")
    local myh = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and myh then SelectedNPC:PivotTo(myh.CFrame * CFrame.new(3, 0, 0)) end
end)

AddButton(np, "Teleport To NPC", 6, function()
    if not SelectedNPC or not LocalPlayer.Character then Toast("No NPC", "Select one first", C.red) return end
    LocalPlayer.Character:PivotTo(SelectedNPC:GetPivot() * CFrame.new(0, 0, 3))
end)

AddButton(np, "Toggle Sit", 7, function()
    if not SelectedNPC then Toast("No NPC", "Select one first", C.red) return end
    local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
    if h then h.Sit = not h.Sit end
end)

AddButton(np, "Force Jump", 8, function()
    if not SelectedNPC then Toast("No NPC", "Select one first", C.red) return end
    local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

AddSep(np, 9, "Speed")

AddSlider(np, "WalkSpeed", 16, 200, 16, "spd", 10, function(v)
    NPCWalkSpeed = v
    if SelectedNPC then
        local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = v end
    end
end)

AddSlider(np, "JumpPower", 50, 300, 50, "jp", 11, function(v)
    NPCJumpPower = v
    if SelectedNPC then
        local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = v end
    end
end)

AddSep(np, 12, "Behaviour")

AddToggle(np, "Speed Hacks", 13, function(v)
    if v then
        SpeedLoop = RunService.RenderStepped:Connect(function()
            if SelectedNPC then
                local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed = NPCWalkSpeed; h.JumpPower = NPCJumpPower end
            end
        end)
    else
        if SpeedLoop then SpeedLoop:Disconnect(); SpeedLoop = nil end
    end
end)

AddToggle(np, "NPC Follow Me", 14, function(v)
    if v then
        FollowLoop = RunService.RenderStepped:Connect(function()
            if SelectedNPC and LocalPlayer.Character then
                local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
                local myh = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if h and myh then h:MoveTo(myh.Position + Vector3.new(-3, 0, 0)) end
            end
        end)
    else
        if FollowLoop then FollowLoop:Disconnect(); FollowLoop = nil end
    end
end)

AddToggle(np, "Control NPC", 15, function(v)
    if v then
        if not SelectedNPC then Toast("No NPC", "Select one first", C.red) return end
        SavedCharacter = LocalPlayer.Character
        LocalPlayer.Character = SelectedNPC
        local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
        if h then
            Workspace.CurrentCamera.CameraSubject = h
            h.WalkSpeed = NPCWalkSpeed; h.JumpPower = NPCJumpPower
        end
        StartForceControl()
    else
        StopForceControl()
    end
end)

AddToggle(np, "NPC Noclip", 16, function(v)
    if v then
        NPCNoclipLoop = RunService.Stepped:Connect(function()
            if SelectedNPC then
                for _, pt in pairs(SelectedNPC:GetDescendants()) do
                    if pt:IsA("BasePart") then pt.CanCollide = false end
                end
            end
        end)
    else
        if NPCNoclipLoop then NPCNoclipLoop:Disconnect(); NPCNoclipLoop = nil end
    end
end)

AddToggle(np, "Grab NPC (mouse)", 17, function(v)
    if v then
        GrabLoop = RunService.RenderStepped:Connect(function()
            if not SelectedNPC then return end
            local hrp = SelectedNPC:FindFirstChild("HumanoidRootPart")
            local hit = Mouse.Hit
            if hrp and hit then
                hrp.AssemblyLinearVelocity = Vector3.zero
                SelectedNPC:PivotTo(CFrame.new(hit.Position + Vector3.new(0, 2, 0)))
            end
        end)
    else
        if GrabLoop then GrabLoop:Disconnect(); GrabLoop = nil end
    end
end)

AddToggle(np, "NPC Chase Players", 18, function(v)
    if v then
        if not SelectedNPC then Toast("No NPC", "Select one first", C.red) return end
        NPCChaseLoop = RunService.Stepped:Connect(function()
            if not SelectedNPC then return end
            local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
            local hrp = SelectedNPC:FindFirstChild("HumanoidRootPart")
            if not h or not hrp or h.Health <= 0 then return end
            h.WalkSpeed = 80
            local nearest, nearDist = nil, math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local tHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if tHrp then
                        local d = (tHrp.Position - hrp.Position).Magnitude
                        if d < nearDist then nearDist = d; nearest = tHrp end
                    end
                end
            end
            if nearest then h:MoveTo(nearest.Position) end
        end)
    else
        if NPCChaseLoop then NPCChaseLoop:Disconnect(); NPCChaseLoop = nil end
    end
end)

AddToggle(np, "Loop Goto NPC", 19, function(v)
    if v then
        if not SelectedNPC then Toast("No NPC", "Select one first", C.red) return end
        LoopGotoLoop = RunService.RenderStepped:Connect(function()
            if not SelectedNPC or not LocalPlayer.Character then return end
            local npcHrp = SelectedNPC:FindFirstChild("HumanoidRootPart")
            local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not npcHrp or not myHrp then return end
            local target = npcHrp.CFrame * CFrame.new(0, 0, 4)
            if (myHrp.Position - target.Position).Magnitude > 1.5 then
                LocalPlayer.Character:PivotTo(target)
            end
        end)
    else
        if LoopGotoLoop then LoopGotoLoop:Disconnect(); LoopGotoLoop = nil end
    end
end)

AddToggle(np, "Loop Speed NPC (80)", 20, function(v)
    if v then
        if not SelectedNPC then Toast("No NPC", "Select one first", C.red) return end
        LoopSpeedNPCLoop = RunService.RenderStepped:Connect(function()
            if not SelectedNPC then return end
            local h = SelectedNPC:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = 80; h.JumpPower = NPCJumpPower end
        end)
    else
        if LoopSpeedNPCLoop then LoopSpeedNPCLoop:Disconnect(); LoopSpeedNPCLoop = nil end
    end
end)

AddSep(np, 21, "Nearby (15 studs)")

AddToggle(np, "Freeze Nearby NPCs", 22, function(v)
    if v then
        FreezeLoop = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character; if not c then return end
            local hr = c:FindFirstChild("HumanoidRootPart"); if not hr then return end
            for _, pt in pairs(Workspace:GetPartBoundsInRadius(hr.Position, 15)) do
                local m = pt:FindFirstAncestorOfClass("Model")
                if IsNPC(m) then
                    local h = m:FindFirstChildOfClass("Humanoid")
                    if h then h:ChangeState(Enum.HumanoidStateType.Physics) end
                end
            end
        end)
    else
        if FreezeLoop then FreezeLoop:Disconnect(); FreezeLoop = nil end
    end
end)

AddToggle(np, "Jump Nearby NPCs", 23, function(v)
    if v then
        NearbyJumpLoop = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character; if not c then return end
            local hr = c:FindFirstChild("HumanoidRootPart"); if not hr then return end
            for _, pt in pairs(Workspace:GetPartBoundsInRadius(hr.Position, 15)) do
                local m = pt:FindFirstAncestorOfClass("Model")
                if IsNPC(m) then
                    local h = m:FindFirstChildOfClass("Humanoid")
                    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                end
            end
        end)
    else
        if NearbyJumpLoop then NearbyJumpLoop:Disconnect(); NearbyJumpLoop = nil end
    end
end)

AddSep(np, 24, "Chase Aura")

AddToggle(np, "Chase Aura (All NPCs)", 25, function(v)
    if v then
        ChaseLoop = RunService.Stepped:Connect(function()
            local targets = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then table.insert(targets, hrp) end
                end
            end
            if #targets == 0 then return end
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and IsNPC(model) then
                    local h = model:FindFirstChildOfClass("Humanoid")
                    local hrp = model:FindFirstChild("HumanoidRootPart")
                    if h and hrp and h.Health > 0 then
                        h.WalkSpeed = 80
                        local nearest, nearDist = nil, math.huge
                        for _, tHrp in ipairs(targets) do
                            local d = (tHrp.Position - hrp.Position).Magnitude
                            if d < nearDist then nearDist = d; nearest = tHrp end
                        end
                        if nearest then h:MoveTo(nearest.Position) end
                    end
                end
            end
        end)
    else
        if ChaseLoop then ChaseLoop:Disconnect(); ChaseLoop = nil end
    end
end)

AddSep(np, 26, "All NPCs")

AddToggle(np, "All NPC Speed 80", 27, function(v)
    if v then
        AllNPCSpeedLoop = RunService.Stepped:Connect(function()
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and IsNPC(model) then
                    local h = model:FindFirstChildOfClass("Humanoid")
                    if h and h.Health > 0 then h.WalkSpeed = 80 end
                end
            end
        end)
    else
        if AllNPCSpeedLoop then AllNPCSpeedLoop:Disconnect(); AllNPCSpeedLoop = nil end
    end
end)

AddToggle(np, "Loop Speed All NPCs (80)", 28, function(v)
    if v then
        LoopSpeedAllLoop = RunService.RenderStepped:Connect(function()
            for _, model in ipairs(Workspace:GetDescendants()) do
                if model:IsA("Model") and IsNPC(model) then
                    local h = model:FindFirstChildOfClass("Humanoid")
                    if h then h.WalkSpeed = 80 end
                end
            end
        end)
    else
        if LoopSpeedAllLoop then LoopSpeedAllLoop:Disconnect(); LoopSpeedAllLoop = nil end
    end
end)

do
    local FlyGui = Instance.new("Frame")
    FlyGui.Name = "FlyGui"
    FlyGui.Size = UDim2.new(0, 200, 0, 110)
    FlyGui.Position = UDim2.new(0, 20, 0.5, -55)
    FlyGui.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    FlyGui.BorderSizePixel = 0
    FlyGui.Active = true
    FlyGui.Draggable = true
    FlyGui.Visible = false
    FlyGui.Parent = ScreenGui
    Instance.new("UICorner", FlyGui).CornerRadius = UDim.new(0, 6)
    do local s = Instance.new("UIStroke", FlyGui); s.Color = Color3.fromRGB(38,38,38); s.Thickness = 1 end

    local FGTitle = Instance.new("Frame")
    FGTitle.Size = UDim2.new(1, 0, 0, 28)
    FGTitle.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    FGTitle.BorderSizePixel = 0
    FGTitle.Parent = FlyGui
    Instance.new("UICorner", FGTitle).CornerRadius = UDim.new(0, 6)
    do
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0.5, 0); f.Position = UDim2.new(0, 0, 0.5, 0)
        f.BackgroundColor3 = Color3.fromRGB(26, 26, 26); f.BorderSizePixel = 0; f.Parent = FGTitle
    end

    local FGBar = Instance.new("Frame")
    FGBar.Size = UDim2.new(0, 2, 0, 12); FGBar.Position = UDim2.new(0, 8, 0.5, -6)
    FGBar.BackgroundColor3 = Color3.fromRGB(180, 180, 180); FGBar.BorderSizePixel = 0; FGBar.Parent = FGTitle
    Instance.new("UICorner", FGBar).CornerRadius = UDim.new(1, 0)

    local FGLbl = Instance.new("TextLabel")
    FGLbl.Size = UDim2.new(1, -40, 1, 0); FGLbl.Position = UDim2.new(0, 16, 0, 0)
    FGLbl.BackgroundTransparency = 1; FGLbl.Font = Enum.Font.GothamBold
    FGLbl.TextSize = 11; FGLbl.TextColor3 = Color3.fromRGB(195, 195, 195)
    FGLbl.TextXAlignment = Enum.TextXAlignment.Left; FGLbl.Text = "Fly GUI"; FGLbl.Parent = FGTitle

    local FGClose = Instance.new("TextButton")
    FGClose.Size = UDim2.new(0, 20, 0, 20); FGClose.Position = UDim2.new(1, -24, 0.5, -10)
    FGClose.BackgroundColor3 = Color3.fromRGB(30, 30, 30); FGClose.Font = Enum.Font.GothamBold
    FGClose.TextSize = 12; FGClose.TextColor3 = Color3.fromRGB(120, 120, 120)
    FGClose.Text = "×"; FGClose.BorderSizePixel = 0; FGClose.Parent = FGTitle
    Instance.new("UICorner", FGClose).CornerRadius = UDim.new(0, 4)
    FGClose.MouseButton1Click:Connect(function() FlyGui.Visible = false end)

    local flyOn = false
    local flyBg2, flyBv2 = nil, nil
    local fgSpeed = 1
    local fgNowe = false
    local fgTpwalking = false

    local function fgFlyStop()
        fgNowe = false
        fgTpwalking = false
        local c = LocalPlayer.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                pcall(function() hum:SetStateEnabled(s, true) end)
            end
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            hum.PlatformStand = false
        end
        local anim = c:FindFirstChild("Animate")
        if anim then anim.Disabled = false end
        if flyBg2 then flyBg2:Destroy(); flyBg2 = nil end
        if flyBv2 then flyBv2:Destroy(); flyBv2 = nil end
        flyOn = false
    end

    local function fgFlyStart()
        local c = LocalPlayer.Character; if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local body = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
        if not hum or not hrp or not body then return end

        fgNowe = true
        fgTpwalking = true
        flyOn = true

        for i = 1, fgSpeed do
            task.spawn(function()
                local hb = RunService.Heartbeat
                local chr = LocalPlayer.Character
                local h = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while fgTpwalking and hb:Wait() and chr and h and h.Parent do
                    if h.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(h.MoveDirection)
                    end
                end
            end)
        end

        local anim = c:FindFirstChild("Animate")
        if anim then anim.Disabled = true end
        for _, t in pairs(hum:GetPlayingAnimationTracks()) do t:AdjustSpeed(0) end
        for _, s in pairs(Enum.HumanoidStateType:GetEnumItems()) do
            pcall(function() hum:SetStateEnabled(s, false) end)
        end
        hum:ChangeState(Enum.HumanoidStateType.Swimming)
        hum.PlatformStand = true

        local maxspeed = 50
        local spd = 0
        local ctrl = {f=0,b=0,l=0,r=0}
        local lastctrl = {f=0,b=0,l=0,r=0}

        flyBg2 = Instance.new("BodyGyro", body)
        flyBg2.P = 9e4; flyBg2.maxTorque = Vector3.new(9e9,9e9,9e9); flyBg2.cframe = body.CFrame

        flyBv2 = Instance.new("BodyVelocity", body)
        flyBv2.velocity = Vector3.new(0,0.1,0); flyBv2.maxForce = Vector3.new(9e9,9e9,9e9)

        task.spawn(function()
            while fgNowe do
                RunService.RenderStepped:Wait()
                ctrl.f = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0
                ctrl.b = UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0
                ctrl.l = UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
                ctrl.r = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
                if ctrl.l+ctrl.r ~= 0 or ctrl.f+ctrl.b ~= 0 then
                    spd = math.min(spd + 0.5 + spd/maxspeed, maxspeed)
                elseif spd ~= 0 then
                    spd = math.max(spd - 1, 0)
                end
                local cam = Workspace.CurrentCamera.CoordinateFrame
                if (ctrl.l+ctrl.r) ~= 0 or (ctrl.f+ctrl.b) ~= 0 then
                    flyBv2.velocity = ((cam.LookVector*(ctrl.f+ctrl.b)) + ((cam*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*0.2,0).p) - cam.p)) * spd
                    lastctrl = {f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
                elseif spd ~= 0 then
                    flyBv2.velocity = ((cam.LookVector*(lastctrl.f+lastctrl.b)) + ((cam*CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*0.2,0).p) - cam.p)) * spd
                else
                    flyBv2.velocity = Vector3.new(0,0,0)
                end
                flyBg2.cframe = cam * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*spd/maxspeed),0,0)
            end
            fgFlyStop()
        end)
    end

    local FGContent = Instance.new("Frame")
    FGContent.Size = UDim2.new(1, -14, 1, -36); FGContent.Position = UDim2.new(0, 7, 0, 33)
    FGContent.BackgroundTransparency = 1; FGContent.Parent = FlyGui
    local FGL = Instance.new("UIListLayout", FGContent)
    FGL.Padding = UDim.new(0, 4); FGL.SortOrder = Enum.SortOrder.LayoutOrder

    local FGToggleCard = Instance.new("Frame")
    FGToggleCard.Size = UDim2.new(1, 0, 0, 28); FGToggleCard.BackgroundColor3 = Color3.fromRGB(26,26,26)
    FGToggleCard.BorderSizePixel = 0; FGToggleCard.LayoutOrder = 1; FGToggleCard.Parent = FGContent
    Instance.new("UICorner", FGToggleCard).CornerRadius = UDim.new(0, 4)
    do local s = Instance.new("UIStroke", FGToggleCard); s.Color = Color3.fromRGB(38,38,38); s.Thickness = 1 end

    local FGToggleLbl = Instance.new("TextLabel")
    FGToggleLbl.Size = UDim2.new(1, -55, 1, 0); FGToggleLbl.Position = UDim2.new(0, 10, 0, 0)
    FGToggleLbl.BackgroundTransparency = 1; FGToggleLbl.Font = Enum.Font.Gotham
    FGToggleLbl.TextSize = 11; FGToggleLbl.TextColor3 = Color3.fromRGB(195,195,195)
    FGToggleLbl.TextXAlignment = Enum.TextXAlignment.Left; FGToggleLbl.Text = "Fly"; FGToggleLbl.Parent = FGToggleCard

    local FGTrack = Instance.new("Frame")
    FGTrack.Size = UDim2.new(0, 34, 0, 18); FGTrack.Position = UDim2.new(1, -42, 0.5, -9)
    FGTrack.BackgroundColor3 = Color3.fromRGB(38,38,38); FGTrack.BorderSizePixel = 0; FGTrack.Parent = FGToggleCard
    Instance.new("UICorner", FGTrack).CornerRadius = UDim.new(1, 0)

    local FGKnob = Instance.new("Frame")
    FGKnob.Size = UDim2.new(0, 12, 0, 12); FGKnob.Position = UDim2.new(0, 3, 0.5, -6)
    FGKnob.BackgroundColor3 = Color3.fromRGB(85,85,85); FGKnob.BorderSizePixel = 0; FGKnob.Parent = FGTrack
    Instance.new("UICorner", FGKnob).CornerRadius = UDim.new(1, 0)

    local FGHit = Instance.new("TextButton")
    FGHit.Size = UDim2.new(1, 0, 1, 0); FGHit.BackgroundTransparency = 1; FGHit.Text = ""; FGHit.Parent = FGToggleCard
    local fgToggleOn = false
    FGHit.MouseButton1Click:Connect(function()
        fgToggleOn = not fgToggleOn
        if fgToggleOn then
            Tween(FGTrack, {BackgroundColor3 = Color3.fromRGB(75,160,85)})
            Tween(FGKnob, {Position = UDim2.new(0, 19, 0.5, -6), BackgroundColor3 = Color3.fromRGB(210,210,210)})
            fgFlyStart()
        else
            fgFlyStop()
            FlyGui:Destroy()
        end
    end)
    local FGSliderCard = Instance.new("Frame")
    FGSliderCard.Size = UDim2.new(1, 0, 0, 42); FGSliderCard.BackgroundColor3 = Color3.fromRGB(26,26,26)
    FGSliderCard.BorderSizePixel = 0; FGSliderCard.LayoutOrder = 2; FGSliderCard.Parent = FGContent
    Instance.new("UICorner", FGSliderCard).CornerRadius = UDim.new(0, 4)
    do local s = Instance.new("UIStroke", FGSliderCard); s.Color = Color3.fromRGB(38,38,38); s.Thickness = 1 end

    local FGSlLbl = Instance.new("TextLabel")
    FGSlLbl.Size = UDim2.new(1, -50, 0, 16); FGSlLbl.Position = UDim2.new(0, 10, 0, 4)
    FGSlLbl.BackgroundTransparency = 1; FGSlLbl.Font = Enum.Font.Gotham
    FGSlLbl.TextSize = 11; FGSlLbl.TextColor3 = Color3.fromRGB(195,195,195)
    FGSlLbl.TextXAlignment = Enum.TextXAlignment.Left; FGSlLbl.Text = "Speed"; FGSlLbl.Parent = FGSliderCard

    local FGValLbl = Instance.new("TextLabel")
    FGValLbl.Size = UDim2.new(0, 42, 0, 16); FGValLbl.Position = UDim2.new(1, -50, 0, 4)
    FGValLbl.BackgroundTransparency = 1; FGValLbl.Font = Enum.Font.GothamBold
    FGValLbl.TextSize = 10; FGValLbl.TextColor3 = Color3.fromRGB(180,180,180)
    FGValLbl.TextXAlignment = Enum.TextXAlignment.Right; FGValLbl.Text = "50"; FGValLbl.Parent = FGSliderCard

    local FGTrackSl = Instance.new("Frame")
    FGTrackSl.Size = UDim2.new(1, -20, 0, 3); FGTrackSl.Position = UDim2.new(0, 10, 0, 30)
    FGTrackSl.BackgroundColor3 = Color3.fromRGB(38,38,38); FGTrackSl.BorderSizePixel = 0; FGTrackSl.Parent = FGSliderCard
    Instance.new("UICorner", FGTrackSl).CornerRadius = UDim.new(1, 0)

    local FGFill = Instance.new("Frame")
    FGFill.Size = UDim2.new(0.49, 0, 1, 0); FGFill.BackgroundColor3 = Color3.fromRGB(180,180,180)
    FGFill.BorderSizePixel = 0; FGFill.Parent = FGTrackSl
    Instance.new("UICorner", FGFill).CornerRadius = UDim.new(1, 0)

    local FGThumb = Instance.new("Frame")
    FGThumb.Size = UDim2.new(0, 10, 0, 10); FGThumb.Position = UDim2.new(0.49, -5, 0.5, -5)
    FGThumb.BackgroundColor3 = Color3.fromRGB(190,190,190); FGThumb.BorderSizePixel = 0; FGThumb.Parent = FGTrackSl
    Instance.new("UICorner", FGThumb).CornerRadius = UDim.new(1, 0)

    local fgDrag = false
    local function fgRestartTpwalk()
        if not fgNowe then return end
        fgTpwalking = false
        task.wait(0.05)
        fgTpwalking = true
        for i = 1, fgSpeed do
            task.spawn(function()
                local hb = RunService.Heartbeat
                local chr = LocalPlayer.Character
                local h = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while fgTpwalking and hb:Wait() and chr and h and h.Parent do
                    if h.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(h.MoveDirection)
                    end
                end
            end)
        end
    end

    local function fgUpdateSlider(x)
        local a = FGTrackSl.AbsolutePosition.X; local sz = FGTrackSl.AbsoluteSize.X
        local t = math.clamp((x - a) / sz, 0, 1)
        fgSpeed = math.max(1, math.round(1 + t * 9))
        FGFill.Size = UDim2.new(t, 0, 1, 0)
        FGThumb.Position = UDim2.new(t, -5, 0.5, -5)
        FGValLbl.Text = tostring(fgSpeed)
        fgRestartTpwalk()
    end

    local FGSlHit = Instance.new("TextButton")
    FGSlHit.Size = UDim2.new(1, 0, 4, 0); FGSlHit.Position = UDim2.new(0, 0, 0.5, -8)
    FGSlHit.BackgroundTransparency = 1; FGSlHit.Text = ""; FGSlHit.Parent = FGTrackSl

    FGSlHit.MouseButton1Down:Connect(function()
        fgDrag = true; fgUpdateSlider(UserInputService:GetMouseLocation().X)
    end)
    UserInputService.InputChanged:Connect(function(i)
        if fgDrag then
            if i.UserInputType == Enum.UserInputType.MouseMovement then
                fgUpdateSlider(UserInputService:GetMouseLocation().X)
            elseif i.UserInputType == Enum.UserInputType.Touch then
                fgUpdateSlider(i.Position.X)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            fgDrag = false
        end
    end)
    FGSlHit.TouchLongPress:Connect(function()
        fgDrag = true
    end)
    FGSlHit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then
            fgDrag = true; fgUpdateSlider(i.Position.X)
        end
    end)
end
