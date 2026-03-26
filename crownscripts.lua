-- CrownScripts 2026
-- Build: stable_v1

local game = game
local Enum = Enum
local Instance = Instance
local UDim2 = UDim2
local Color3 = Color3
local ColorSequence = ColorSequence
local ColorSequenceKeypoint = ColorSequenceKeypoint
local CFrame = CFrame
local TweenInfo = TweenInfo
local workspace = workspace

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local VirtualUser = game:GetService("VirtualUser")

-- Anti-AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

local function getBestParent()
    local success, _ = pcall(function() return CoreGui.Name end)
    if success then return CoreGui end
    return playerGui
end

local targetParent = getBestParent()

if targetParent:FindFirstChild("CrownScripts2026") then
    targetParent.CrownScripts2026:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrownScripts2026"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

local uiVisible = true
local function toggleUI()
    uiVisible = not uiVisible
    Main.Visible = uiVisible
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Insert then
        toggleUI()
    end
end)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 255)
OpenBtn.Text = "C"
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.TextSize = 25
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1, 0)
local OpenGradient = Instance.new("UIGradient")
OpenGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 0, 255)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 180))
}
OpenGradient.Parent = OpenBtn
OpenBtn.MouseButton1Click:Connect(toggleUI)

local function Notification(msg)
    local note = Instance.new("TextLabel")
    note.Size = UDim2.new(0, 250, 0, 40)
    note.Position = UDim2.new(1, 0, 1, -100)
    note.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    note.BorderSizePixel = 0
    note.Text = msg
    note.TextColor3 = Color3.new(1, 1, 1)
    note.TextSize = 14
    note.Font = Enum.Font.GothamMedium
    note.Parent = ScreenGui
    Instance.new("UICorner", note).CornerRadius = UDim.new(0, 8)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(Color3.fromRGB(90, 0, 255), Color3.fromRGB(0, 255, 180))
    grad.Parent = note
    note:TweenPosition(UDim2.new(1, -270, 1, -100), "Out", "Back", 0.5)
    task.delay(3, function()
        note:TweenPosition(UDim2.new(1, 20, 1, -100), "In", "Quad", 0.5)
        task.wait(0.5)
        note:Destroy()
    end)
end

-- Initialize Settings and Quest Data EARLY
local sailorSettings = {
    autoLevel = false,
    autoAttack = false,
    autoSkills = false,
    autoStats = false,
    autoHaki = false,
    autoBoss = false,
    farmDist = 8,
    statType = "Strength",
    bossTarget = "All",
    autoSummon = false,
    activeQuestLine = "None",
    autoNPC = false,
    npcDist = 10
}

local questLines = {
    ["Aizen Sword"] = { npc = "Hueco Mundo Quest", mobs = {"Hollow"}, boss = "Aizen", level = "2000+" },
    ["True Aizen"] = { npc = "Soul Society Quest", mobs = {"Quincy"}, boss = "True Aizen", level = "3500+" },
    ["Blessed Maiden"] = { npc = "Blessed NPC", mobs = {"Maiden Guard"}, boss = "Blessed Maiden", level = "4000+" },
    ["Yamato"] = { npc = "Wano Quest", mobs = {"Kaido Minion"}, boss = "Yamato", level = "3000+" },
    ["Shadow Monarch"] = { npc = "Jinwoo NPC", mobs = {"Shadow Soldier"}, boss = "Shadow Monarch", level = "5000+" },
    ["Escanor"] = { npc = "Sun NPC", mobs = {"Holy Knight"}, boss = "Escanor", level = "4500+" },
    ["Shinigami"] = { npc = "Race NPC", mobs = {"Spirit"}, boss = nil, level = "Any" },
    ["Whitebeard"] = { npc = "Marineford NPC", mobs = {"Marine Soldier"}, boss = "Whitebeard", level = "2500+" },
    ["Roger"] = { npc = "Loguetown NPC", mobs = {"Executioner"}, boss = "Roger", level = "5000+" },
    ["Garp Mastery"] = { npc = "Training NPC", mobs = {"Navy Cadet"}, boss = "Garp", level = "3000+" },
    ["Dual Sword"] = { npc = "Dual NPC", mobs = {"Samurai"}, boss = "Zoro", level = "1500+" },
    ["Dark Blade"] = { npc = "Mihawk NPC", mobs = {"Swordsman"}, boss = "Mihawk", level = "Max" },
    ["Anos Mastery"] = { npc = "Anos NPC", mobs = {"Demon Soldier"}, boss = "Anos", level = "6000+" },
    ["Rimuru"] = { npc = "Slime NPC", mobs = {"Orc"}, boss = "Rimuru", level = "7000+" },
    ["Strongest"] = { npc = "Strongest NPC", mobs = {"Elite Guard"}, boss = "Strongest Boss", level = "8000+" }
}

-- UI Containers (Consolidated)
local Main -- Will be initialized in Main UI Setup section

local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 450, 0, 300)
KeyFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui
makeDraggable(KeyFrame)

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 16)
local KeyGradient = Instance.new("UIGradient")
KeyGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 0, 255)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 180))
}
KeyGradient.Rotation = 135
KeyGradient.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 70)
KeyTitle.Text = "CROWN SCRIPTS"
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.TextSize = 28
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 50)
KeyInput.Position = UDim2.new(0.1, 0, 0, 100)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.TextColor3 = Color3.new(1,1,1)
KeyInput.TextSize = 18
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.Parent = KeyFrame
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 8)

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.35, 0, 0, 45)
SubmitBtn.Position = UDim2.new(0.1, 0, 0, 180)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 255)
SubmitBtn.Text = "Submit"
SubmitBtn.TextColor3 = Color3.new(1,1,1)
SubmitBtn.TextSize = 18
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyFrame
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.35, 0, 0, 45)
GetKeyBtn.Position = UDim2.new(0.55, 0, 0, 180)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Color3.new(1,1,1)
GetKeyBtn.TextSize = 18
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Parent = KeyFrame
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

local KeyStatus = Instance.new("TextLabel")
KeyStatus.Size = UDim2.new(1, 0, 0, 30)
KeyStatus.Position = UDim2.new(0, 0, 0, 240)
KeyStatus.BackgroundTransparency = 1
KeyStatus.Text = "Waiting for key..."
KeyStatus.TextColor3 = Color3.new(0.8, 0.8, 0.8)
KeyStatus.TextSize = 14
KeyStatus.Font = Enum.Font.GothamMedium
KeyStatus.Parent = KeyFrame

local function StartMain()
    KeyFrame:Destroy()
    Main.Visible = true
    uiVisible = true
    OpenBtn.Visible = true
end

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "CROWN-2026-SAILOR" then
        KeyStatus.Text = "Key Correct! Loading..."
        KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 180)
        task.wait(1)
        StartMain()
    else
        KeyStatus.Text = "Invalid Key! Try again."
        KeyStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
        KeyInput.Text = ""
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("discord.gg/crownscripts") end
    KeyStatus.Text = "Link copied to clipboard!"
    KeyStatus.TextColor3 = Color3.fromRGB(0, 150, 255)
end)

-- Neon Theme Config
local Theme = {
    MainBG = Color3.fromRGB(12, 12, 28),
    SecondaryBG = Color3.fromRGB(18, 18, 38),
    Accent = Color3.fromRGB(150, 0, 255), -- Purple
    Cyan = Color3.fromRGB(0, 255, 255),
    Glow = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))
    },
    Text = Color3.new(1,1,1),
    DarkText = Color3.fromRGB(180,180,200)
}

-- Main UI Setup
Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 850, 0, 620)
Main.Position = UDim2.new(0.5, -425, 0.5, -310)
Main.BackgroundColor3 = Theme.MainBG
Main.BorderSizePixel = 1
Main.BorderColor3 = Theme.Accent
Main.Visible = false
Main.ClipsDescendants = false
Main.ZIndex = 1
Main.Parent = ScreenGui
makeDraggable(Main)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(0, 200, 0, 20)
StatusLabel.Position = UDim2.new(1, -210, 1, -30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Initialize..."
StatusLabel.TextColor3 = Color3.new(1,0,0) -- Bright Red for visibility
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSansBold
StatusLabel.Parent = ScreenGui
StatusLabel.ZIndex = 100

pcall(function()
    Main.BorderSizePixel = 0
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local UIStrokeGradient = Instance.new("UIGradient")
    UIStrokeGradient.Color = Theme.Glow
    UIStrokeGradient.Rotation = 45
    UIStrokeGradient.Parent = UIStroke
    UIStroke.Parent = Main
end)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
TopBar.BorderSizePixel = 1
TopBar.BorderColor3 = Color3.fromRGB(40, 40, 60)
TopBar.ZIndex = 2
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "CrownScripts 2026"
Title.TextColor3 = Theme.Text
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.ZIndex = 3
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 3
CloseBtn.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -20, 0, 45)
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.ZIndex = 2
TabContainer.Parent = Main

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 8)
TabListLayout.Parent = TabContainer

local TabButtons = {}
local Pages = {}
local Tabs = {"Home", "Combat", "ESP", "Sailor", "QuestLines", "Misc", "Credits"}

-- Helper functions for UI
local function AddSlider(parent, name, minV, maxV, default, unit, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 15
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-40,0,20)
    label.BackgroundTransparency = 1
    label.Text = "• " .. name .. ": " .. default .. unit
    label.TextColor3 = Theme.Text
    label.TextSize = 13
    label.Font = Enum.Font.SourceSansBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 16
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.65,0,0,4)
    bar.Position = UDim2.new(0,0,0,30)
    bar.BackgroundColor3 = Color3.fromRGB(40,40,60)
    bar.ZIndex = 16
    bar.Parent = frame
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0,999)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-minV)/(maxV-minV),0,1,0)
    fill.BackgroundColor3 = Theme.Cyan
    fill.ZIndex = 17
    fill.Parent = bar
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0,999)
    fillCorner.Parent = fill

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0,50,0,18)
    valueLabel.Position = UDim2.new(0.7,0,0,23)
    valueLabel.BackgroundColor3 = Theme.SecondaryBG
    valueLabel.Text = default .. unit
    valueLabel.TextColor3 = Theme.Text
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.SourceSansBold
    valueLabel.ZIndex = 17
    valueLabel.Parent = frame
    local valCorner = Instance.new("UICorner")
    valCorner.CornerRadius = UDim.new(0,4)
    valCorner.Parent = valueLabel

    local value = default
    local dragging = false

    local function update(newVal)
        value = math.clamp(newVal, minV, maxV)
        local percent = (value - minV) / (maxV - minV)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = math.floor(value*10)/10 .. unit
        pcall(callback, value)
    end

    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local p = math.clamp((inp.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            update(minV + p*(maxV-minV))
        end
    end)
    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    bar.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((inp.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            update(minV + p*(maxV-minV))
        end
    end)
end

local function AddToggle(parent, name, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,30)
    f.BackgroundTransparency = 1
    f.ZIndex = 15
    f.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "• " .. name
    lbl.TextColor3 = Theme.Text
    lbl.TextSize = 14
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 16
    lbl.Parent = f

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 60, 0, 24)
    sw.Position = UDim2.new(1, -65, 0.5, -12)
    sw.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(40,40,60)
    sw.Text = default and "ON" or "OFF"
    sw.TextColor3 = Theme.Text
    sw.TextSize = 12
    sw.Font = Enum.Font.SourceSansBold
    sw.ZIndex = 16
    sw.Parent = f
    local swCorner = Instance.new("UICorner")
    swCorner.CornerRadius = UDim.new(0, 4)
    swCorner.Parent = sw

    local state = default
    sw.MouseButton1Click:Connect(function()
        state = not state
        sw.Text = state and "ON" or "OFF"
        TweenService:Create(sw, TweenInfo.new(0.25), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(40,40,60)}):Play()
        pcall(callback, state)
    end)
end

local function AddDropdown(parent, name, options, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,35)
    f.BackgroundTransparency = 1
    f.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundColor3 = Theme.SecondaryBG
    btn.Text = name .. ": " .. options[1]
    btn.TextColor3 = Theme.Text
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = f
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1,0,0,#options*30)
    list.Position = UDim2.new(0,0,1,5)
    list.BackgroundColor3 = Color3.fromRGB(25,25,45)
    list.Visible = false
    list.ZIndex = 50
    list.Parent = btn
    Instance.new("UICorner", list).CornerRadius = UDim.new(0,4)

    btn.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1,0,0,30)
        optBtn.Position = UDim2.new(0,0,0,(i-1)*30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Theme.Text
        optBtn.TextSize = 12
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.ZIndex = 60
        optBtn.Parent = list
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = name .. ": " .. opt
            list.Visible = false
            pcall(callback, opt)
        end)
    end
end

-- Create Pages Layout
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -20, 1, -120)
ContentArea.Position = UDim2.new(0, 10, 0, 110)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = false
ContentArea.Parent = Main

for i = 1, #Tabs do
    pcall(function()
        local name = Tabs[i]
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Tab"
        btn.Size = UDim2.new(1/#Tabs, -8, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,50)
        btn.Text = name
        btn.TextColor3 = Theme.Text
        btn.TextSize = 14
        btn.Font = Enum.Font.SourceSansBold
        btn.ZIndex = 5
        btn.Parent = TabContainer
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0,4)
        btnCorner.Parent = btn

        local indicator = Instance.new("Frame")
        indicator.Name = "TabIndicator"
        indicator.Size = UDim2.new(1, 0, 0, 2)
        indicator.Position = UDim2.new(0, 0, 1, 0)
        indicator.BackgroundColor3 = Theme.Accent
        indicator.Visible = (i == 1)
        indicator.ZIndex = 6
        indicator.Parent = btn

        local page = Instance.new("Frame")
        page.Name = name .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = (i == 1)
        page.ZIndex = 5
        page.Parent = ContentArea

        local LeftPane = Instance.new("ScrollingFrame")
        LeftPane.Name = "LeftPane"
        LeftPane.Size = UDim2.new(0.48, 0, 1, -80)
        LeftPane.Position = UDim2.new(0, 0, 0, 80)
        LeftPane.BackgroundTransparency = 1
        LeftPane.ScrollBarThickness = 2
        LeftPane.ZIndex = 10
        LeftPane.CanvasSize = UDim2.new(0,0,5,0)
        LeftPane.Parent = page
        pcall(function() LeftPane.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
        
        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Padding = UDim.new(0,10)
        LeftLayout.Parent = LeftPane

        local RightPane = Instance.new("ScrollingFrame")
        RightPane.Name = "RightPane"
        RightPane.Size = UDim2.new(0.48, 0, 1, -80)
        RightPane.Position = UDim2.new(0.52, 0, 0, 80)
        RightPane.BackgroundTransparency = 1
        RightPane.ScrollBarThickness = 2
        RightPane.ZIndex = 10
        RightPane.CanvasSize = UDim2.new(0,0,5,0)
        RightPane.Parent = page
        pcall(function() RightPane.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
        
        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Padding = UDim.new(0,10)
        RightLayout.Parent = RightPane

        -- Info Banner
        local Banner = Instance.new("Frame")
        Banner.Name = "Banner"
        Banner.Size = UDim2.new(1, 0, 0, 70)
        Banner.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        Banner.ZIndex = 10
        Banner.Parent = page
        local BannerCorner = Instance.new("UICorner")
        BannerCorner.CornerRadius = UDim.new(0, 6)
        BannerCorner.Parent = Banner
        
        local BannerTitle = Instance.new("TextLabel")
        BannerTitle.Size = UDim2.new(1, 0, 0, 30)
        BannerTitle.Text = "CrownScripts 2026"
        BannerTitle.TextColor3 = Theme.Text
        BannerTitle.TextSize = 18
        BannerTitle.Font = Enum.Font.SourceSansBold
        BannerTitle.BackgroundTransparency = 1
        BannerTitle.ZIndex = 11
        BannerTitle.Parent = Banner

        local BannerSub = Instance.new("TextLabel")
        BannerSub.Size = UDim2.new(1, 0, 0, 40)
        BannerSub.Position = UDim2.new(0, 0, 0, 30)
        BannerSub.Text = "Status: Online | Game: Sailor Piece"
        BannerSub.TextColor3 = Theme.DarkText
        BannerSub.TextSize = 13
        BannerSub.Font = Enum.Font.SourceSans
        BannerSub.BackgroundTransparency = 1
        BannerSub.ZIndex = 11
        BannerSub.Parent = Banner

        table.insert(Pages, {page = page, left = LeftPane, right = RightPane})

        btn.MouseButton1Click:Connect(function()
            pcall(function()
                for _, p in ipairs(Pages) do p.page.Visible = false end
                page.Visible = true
                for _, b in ipairs(TabContainer:GetChildren()) do
                    if b:IsA("TextButton") then
                        local ind = b:FindFirstChild("TabIndicator")
                        if ind then ind.Visible = (b == btn) end
                        TweenService:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = (b == btn) and Color3.fromRGB(45, 45, 75) or Color3.fromRGB(30,30,50)}):Play()
                    end
                end
            end)
        end)
    end)
end

-- Update helper function aliases for new 3-panel layout
local function AddControl(tabIndex, pane, name, default, type, callback, extra)
    local target = pane == "left" and Pages[tabIndex].left or Pages[tabIndex].right
    if type == "toggle" then
        AddToggle(target, name, default, callback)
    elseif type == "slider" then
        AddSlider(target, name, extra.min, extra.max, default, extra.unit, callback)
    elseif type == "dropdown" then
        AddDropdown(target, name, extra.options, callback)
    end
end

-- Core Logic Functions
local function getBestMob()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local bestMob = nil
    local dist = 10000
    
    local targetMobs = nil
    if sailorSettings.activeQuestLine ~= "None" then
        targetMobs = questLines[sailorSettings.activeQuestLine].mobs
    end

    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(v) then
            local name = v.Name:lower()
            if not (name:find("quest") or name:find("npc")) then
                local isValid = true
                if targetMobs then
                    isValid = false
                    for _, m in ipairs(targetMobs) do
                        if name:find(m:lower()) then isValid = true break end
                    end
                end

                if isValid then
                    local d = (v.PrimaryPart and (v.PrimaryPart.Position - root.Position).Magnitude) or 10000
                    if d < dist then
                        dist = d
                        bestMob = v
                    end
                end
            end
        end
    end
    return bestMob
end

local function getBoss()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local bosses = {"Aizen", "True Aizen", "Quincy", "Hollow", "Maiden", "Yamato", "Monarch", "Escanor"}
    local targetName = sailorSettings.bossTarget
    
    if sailorSettings.activeQuestLine ~= "None" then
        local questBoss = questLines[sailorSettings.activeQuestLine].boss
        if questBoss then targetName = questBoss end
    end

    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local name = v.Name
            local isBoss = false
            for _, b in ipairs(bosses) do
                if name:find(b) then isBoss = true break end
            end
            if isBoss then
                if targetName == "All" or name:find(targetName) then return v end
            end
        end
    end
    return nil
end

local function hasActiveQuest()
    local qf = player:FindFirstChild("Quest") or player:FindFirstChild("ActiveQuest")
    if qf and #qf:GetChildren() > 0 then return true end
    local gui = playerGui:FindFirstChild("MainUI") or playerGui:FindFirstChild("QuestUI")
    if gui then
        local f = gui:FindFirstChild("QuestFrame", true) or gui:FindFirstChild("Quest", true)
        if f and f.Visible then return true end
    end
    return false
end

local lastQuestFire = 0
local function acceptQuest(name)
    if tick() - lastQuestFire < 2 then return end
    lastQuestFire = tick()
    local r = ReplicatedStorage:FindFirstChild("QuestRemote", true) or ReplicatedStorage:FindFirstChild("AcceptQuest", true)
    if r then r:FireServer(name) end
end

-- Main Heartbeat Loop
RunService.Heartbeat:Connect(function()
    if not sailorSettings.autoLevel and not sailorSettings.autoBoss and sailorSettings.activeQuestLine == "None" then return end
    pcall(function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local target = nil
        local qData = sailorSettings.activeQuestLine ~= "None" and questLines[sailorSettings.activeQuestLine] or nil
        
        if sailorSettings.autoBoss or (qData and qData.boss) then
            target = getBoss()
            if not target and sailorSettings.autoSummon then
                local r = ReplicatedStorage:FindFirstChild("SummonBoss", true) or ReplicatedStorage:FindFirstChild("SummonRemote", true)
                if r then r:FireServer("Hard") end
            end
        end
        
        if not target then target = getBestMob() end
        
        if not target and qData and sailorSettings.autoNPC and not hasActiveQuest() then
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Model") and v.Name:lower():find(qData.npc:lower()) then
                    target = v
                    break
                end
            end
        end
        
        if target and target:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
            local isNPC = qData and target.Name:lower():find(qData.npc:lower())
            if isNPC then
                char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, sailorSettings.npcDist)
                acceptQuest(sailorSettings.activeQuestLine)
            else
                -- Robust Farming Position (Horizontal Above)
                char.HumanoidRootPart.Velocity = Vector3.new(0,0,0) -- Stop physics flinging
                char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, sailorSettings.farmDist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                if sailorSettings.autoAttack then
                    local t = char:FindFirstChildOfClass("Tool")
                    if not t then
                        local bp = player:FindFirstChild("Backpack")
                        if bp then
                            local tool = bp:FindFirstChildOfClass("Tool")
                            if tool then tool.Parent = char end
                        end
                    end
                    t = char:FindFirstChildOfClass("Tool")
                    if t then t:Activate() end
                    VirtualUser:ClickButton1(Vector2.new(9999, 9999)) -- Simulate mouse click
                end
                if sailorSettings.autoSkills then
                    local r = ReplicatedStorage:FindFirstChild("Skills", true)
                    if r then for _, k in ipairs({"Z", "X", "C", "V"}) do r:FireServer(k) end end
                end
            end
        end
        
        if sailorSettings.autoStats then
            local r = ReplicatedStorage:FindFirstChild("AddStat", true) or ReplicatedStorage:FindFirstChild("StatRemote", true)
            if r then r:FireServer(sailorSettings.statType, 1) end
        end
        if sailorSettings.autoHaki then
            local r = ReplicatedStorage:FindFirstChild("Haki", true) or ReplicatedStorage:FindFirstChild("ToggleHaki", true)
            if r then r:FireServer() end
        end
    end)
end)

-- Kill Aura
local killAuraEnabled = false
local killAuraRange = 25
local teamCheck = false
local targetNPCs = false
local currentTarget = nil

local function isTargetValid(m)
    return m and m:FindFirstChild("Humanoid") and m.Humanoid.Health > 0 and m:FindFirstChild("HumanoidRootPart")
end

local function getBestTarget()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local best, d = nil, killAuraRange
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= player and v.Character and isTargetValid(v.Character) then
            if not teamCheck or v.Team ~= player.Team then
                local dist = (v.Character.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < d then best, d = v.Character, dist end
            end
        end
    end
    if targetNPCs then
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("Model") and isTargetValid(v) and not Players:GetPlayerFromCharacter(v) then
                local dist = (v.HumanoidRootPart.Position - root.Position).Magnitude
                if dist < d then best, d = v, dist end
            end
        end
    end
    return best
end

RunService.Heartbeat:Connect(function()
    if not killAuraEnabled then 
        if currentTarget and currentTarget:FindFirstChild("CrownTarget") then currentTarget.CrownTarget:Destroy() end
        currentTarget = nil
        return 
    end
    pcall(function()
        local target = getBestTarget()
        if target ~= currentTarget then
            if currentTarget and currentTarget:FindFirstChild("CrownTarget") then currentTarget.CrownTarget:Destroy() end
            if target then
                local h = Instance.new("Highlight")
                h.Name = "CrownTarget"
                h.FillColor = Color3.new(1,0,0)
                h.Parent = target
            end
            currentTarget = target
        end
        if target then
            local char = player.Character
            local t = char:FindFirstChildOfClass("Tool")
            if not t then
                local bp = player:FindFirstChild("Backpack")
                if bp then
                    local tool = bp:FindFirstChildOfClass("Tool")
                    if tool then tool.Parent = char end
                end
            end
            t = char:FindFirstChildOfClass("Tool")
            if t then t:Activate() end
            VirtualUser:ClickButton1(Vector2.new(9999, 9999))
            
            -- Optional: Add a small delay or loop for faster hits
            task.spawn(function()
                for i=1, 3 do
                    if t then t:Activate() end
                    VirtualUser:ClickButton1(Vector2.new(9999, 9999))
                    task.wait(0.05)
                end
            end)
        end
    end)
end)

-- Misc Utilities
local speedMultiplier = 1
RunService.Heartbeat:Connect(function()
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16 * speedMultiplier
        end
    end)
end)

local infiniteJumpEnabled = false
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local espEnabled = false
local function CreateESP(p)
    if p == player then return end
    local function highlight()
        pcall(function()
            if not espEnabled then 
                if p.Character and p.Character:FindFirstChild("CrownESP") then p.Character.CrownESP:Destroy() end
                return 
            end
            if p.Character and not p.Character:FindFirstChild("CrownESP") then
                local h = Instance.new("Highlight")
                h.Name = "CrownESP"
                h.FillColor = Color3.fromRGB(255, 0, 255)
                h.Parent = p.Character
            end
        end)
    end
    p.CharacterAdded:Connect(highlight)
    if p.Character then highlight() end
end

Players.PlayerAdded:Connect(CreateESP)
for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end

RunService.RenderStepped:Connect(function()
    if espEnabled then for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end end
end)

pcall(function()
    StatusLabel.Text = "Populating UI..."
    -- Fill Pages
    local Welcome = Instance.new("TextLabel")
    Welcome.Size = UDim2.new(1, -20, 0, 100)
    Welcome.Position = UDim2.new(0, 10, 0, 80)
    Welcome.BackgroundTransparency = 1
    Welcome.Text = "Welcome to CrownScripts 2026\nStatus: Online | Use [INSERT] to manage UI\nEnjoy the most advanced automation for Sailor Piece."
    Welcome.TextColor3 = Theme.Text
    Welcome.TextSize = 16
    Welcome.Font = Enum.Font.SourceSansBold
    Welcome.ZIndex = 11
    Welcome.Parent = Pages[1].left

    AddControl(2, "left", "Kill Aura", false, "toggle", function(v) killAuraEnabled = v end)
    AddControl(2, "left", "Team Check", false, "toggle", function(v) teamCheck = v end)
    AddControl(2, "left", "Target NPCs", false, "toggle", function(v) targetNPCs = v end)
    AddControl(2, "left", "Range", 25, "slider", function(v) killAuraRange = v end, {min=5, max=100, unit=" studs"})

    AddControl(3, "left", "Player ESP", false, "toggle", function(v) espEnabled = v end)

    AddControl(4, "left", "Auto Leveling", false, "toggle", function(v) sailorSettings.autoLevel = v end)
    AddControl(4, "left", "Auto Clicker", false, "toggle", function(v) sailorSettings.autoAttack = v end)
    AddControl(4, "left", "Auto Skills", false, "toggle", function(v) sailorSettings.autoSkills = v end)
    AddControl(4, "right", "Auto Haki", false, "toggle", function(v) sailorSettings.autoHaki = v end)
    AddControl(4, "right", "Auto Stats", false, "toggle", function(v) sailorSettings.autoStats = v end)
    AddControl(4, "right", "Auto Boss Farm", false, "toggle", function(v) sailorSettings.autoBoss = v end)
    AddControl(4, "right", "Boss Target", sailorSettings.bossTarget, "dropdown", function(v) sailorSettings.bossTarget = v end, {options={"All", "Aizen", "True Aizen", "Quincy"}})
    AddControl(4, "right", "Auto Summon Boss", false, "toggle", function(v) sailorSettings.autoSummon = v end)
    AddControl(4, "right", "Farm Distance", 8, "slider", function(v) sailorSettings.farmDist = v end, {min=5, max=15, unit=" studs"})

    local questOptions = {"None"}
    for k, _ in pairs(questLines) do table.insert(questOptions, k) end
    table.sort(questOptions)

    local qInfo = Instance.new("TextLabel")
    qInfo.Size = UDim2.new(1, -20, 0, 80)
    qInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    qInfo.Text = "Select a QuestLine to begin automation.\nEnsure you have the required level."
    qInfo.TextColor3 = Theme.DarkText
    qInfo.TextSize = 13
    qInfo.Font = Enum.Font.SourceSansBold
    qInfo.ZIndex = 11
    qInfo.Parent = Pages[5].right
    local qCorner = Instance.new("UICorner")
    qCorner.CornerRadius = UDim.new(0, 6)
    qCorner.Parent = qInfo

    AddControl(5, "left", "Select QuestLine", "None", "dropdown", function(v) 
        sailorSettings.activeQuestLine = v 
        if v ~= "None" then
            local data = questLines[v]
            qInfo.Text = "Quest: " .. v .. "\nNPC: " .. data.npc .. "\nMobs: " .. table.concat(data.mobs, ", ") .. "\nReq Level: " .. data.level
        else
            qInfo.Text = "Select a QuestLine to begin automation."
        end
    end, {options=questOptions})
    AddControl(5, "left", "Start QuestLine Farm", false, "toggle", function(v) 
        if v then sailorSettings.autoLevel, sailorSettings.autoBoss = false, false
        else sailorSettings.activeQuestLine = "None" end 
    end)
    AddControl(5, "left", "Auto NPC Interact", false, "toggle", function(v) sailorSettings.autoNPC = v end)
    AddControl(5, "left", "NPC Interaction Dist", 10, "slider", function(v) sailorSettings.npcDist = v end, {min=5, max=20, unit=" studs"})

    AddControl(6, "left", "Speed Multiplier", 1, "slider", function(v) speedMultiplier = v end, {min=1, max=10, unit="x"})
    AddControl(6, "left", "Infinite Jump", false, "toggle", function(v) infiniteJumpEnabled = v end)

    local CreditsText = Instance.new("TextLabel")
    CreditsText.Size = UDim2.new(1, -20, 0, 100)
    CreditsText.BackgroundTransparency = 1
    CreditsText.Text = "Developers:\ncrowdsect, coleistic\n\nOfficial Server:\ndiscord.gg/crownscripts"
    CreditsText.TextColor3 = Theme.Text
    CreditsText.TextSize = 16
    CreditsText.Font = Enum.Font.SourceSansBold
    CreditsText.ZIndex = 11
    CreditsText.Parent = Pages[7].left

    Notification("CrownScripts 2026 Loaded Successfully")
    StatusLabel.Text = "Build: stable_v1 | Active & Stable"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    print("CrownScripts 2026 Loaded Successfully")
end)
