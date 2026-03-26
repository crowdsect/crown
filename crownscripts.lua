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
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Insert then
        uiVisible = not uiVisible
        ScreenGui.Enabled = uiVisible
    end
end)

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

-- UI Containers
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 680, 0, 520)
Main.Position = UDim2.new(0.5, -340, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
Main.Visible = false
makeDraggable(Main)

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
KeyTitle.Size = UDim2.new(1, 0, 0, 60)
KeyTitle.Text = "CrownScripts | Key System"
KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.TextScaled = true
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

-- Main UI Setup
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 16)
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 0, 255)), 
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 180))
}
MainGradient.Rotation = 135
MainGradient.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundTransparency = 0.35
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Text = "CrownScripts 2026"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 10)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextScaled = true
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 50)
TabContainer.Position = UDim2.new(0, 10, 0, 70)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

local TabButtons = {}
local Pages = {}
local Tabs = {"Home", "Combat", "ESP", "Sailor", "QuestLines", "Misc", "Credits"}

-- Helper functions for UI
local function AddSlider(parent, name, minV, maxV, default, unit, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,25)
    label.Position = UDim2.new(0,15,0,5)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default .. unit
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.85,0,0,8)
    bar.Position = UDim2.new(0.075,0,0,45)
    bar.BackgroundColor3 = Color3.fromRGB(50,50,70)
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0,999)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-minV)/(maxV-minV),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,255,180)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0,999)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0,18,0,18)
    thumb.Position = UDim2.new((default-minV)/(maxV-minV), -9, 0.5, -9)
    thumb.BackgroundColor3 = Color3.new(1,1,1)
    thumb.Parent = bar
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(0,999)

    local value = default
    local dragging = false

    local function update(newVal)
        value = math.clamp(newVal, minV, maxV)
        local percent = (value - minV) / (maxV - minV)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        thumb.Position = UDim2.new(percent, -9, 0.5, -9)
        label.Text = name .. ": " .. math.floor(value*10)/10 .. unit
        pcall(callback, value)
    end

    bar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local p = math.clamp((inp.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            update(minV + p*(maxV-minV))
        end
    end)

    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    bar.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local p = math.clamp((inp.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            update(minV + p*(maxV-minV))
        end
    end)
end

local function AddToggle(parent, name, default, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-20,0,55)
    f.BackgroundColor3 = Color3.fromRGB(25,25,40)
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.75,0,1,0)
    lbl.Position = UDim2.new(0,15,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = f

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0,70,0,35)
    sw.Position = UDim2.new(1,-85,0.5,-17.5)
    sw.BackgroundColor3 = default and Color3.fromRGB(0,255,100) or Color3.fromRGB(70,70,85)
    sw.Text = default and "ON" or "OFF"
    sw.TextColor3 = Color3.new(1,1,1)
    sw.TextScaled = true
    sw.Font = Enum.Font.GothamBold
    sw.Parent = f
    Instance.new("UICorner", sw).CornerRadius = UDim.new(0,999)

    local state = default
    sw.MouseButton1Click:Connect(function()
        state = not state
        sw.Text = state and "ON" or "OFF"
        TweenService:Create(sw, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(0,255,100) or Color3.fromRGB(70,70,85)}):Play()
        pcall(callback, state)
    end)
end

local function AddDropdown(parent, name, options, callback)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,-20,0,55)
    f.BackgroundColor3 = Color3.fromRGB(25,25,40)
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5,0,1,0)
    lbl.Position = UDim2.new(0,15,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamSemibold
    lbl.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4,0,0,35)
    btn.Position = UDim2.new(1,-15,0.5,-17.5)
    btn.AnchorPoint = Vector2.new(1,0)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,45)
    btn.Text = options[1]
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1,0,0,#options*35)
    list.Position = UDim2.new(0,0,1,5)
    list.BackgroundColor3 = Color3.fromRGB(20,20,35)
    list.Visible = false
    list.ZIndex = 5
    list.Parent = btn
    Instance.new("UICorner", list).CornerRadius = UDim.new(0,8)

    btn.MouseButton1Click:Connect(function() list.Visible = not list.Visible end)

    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1,0,0,35)
        optBtn.Position = UDim2.new(0,0,0,(i-1)*35)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1,1,1)
        optBtn.TextSize = 14
        optBtn.Font = Enum.Font.GothamMedium
        optBtn.ZIndex = 6
        optBtn.Parent = list
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            list.Visible = false
            pcall(callback, opt)
        end)
    end
end

-- Create Pages
for i = 1, #Tabs do
    local name = Tabs[i]
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/#Tabs, -4, 1, 0)
    btn.Position = UDim2.new((i-1)/#Tabs, 2, 0, 0)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 0, 255) or Color3.fromRGB(30, 30, 45)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = TabContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -140)
    page.Position = UDim2.new(0, 10, 0, 130)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 6
    page.Visible = (i == 1)
    page.BorderSizePixel = 0
    page.Parent = Main

    table.insert(TabButtons, btn)
    table.insert(Pages, page)

    btn.MouseButton1Click:Connect(function()
        for j = 1, #Pages do Pages[j].Visible = false end
        page.Visible = true
        for j = 1, #TabButtons do 
            TweenService:Create(TabButtons[j], TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}):Play()
        end
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 0, 255)}):Play()
    end)
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
        
        if target and target:FindFirstChild("HumanoidRootPart") then
            local isNPC = qData and target.Name:lower():find(qData.npc:lower())
            if isNPC then
                char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, sailorSettings.npcDist)
                acceptQuest(sailorSettings.activeQuestLine)
            else
                char.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, sailorSettings.farmDist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                if sailorSettings.autoAttack then
                    local t = char:FindFirstChildOfClass("Tool")
                    if t then t:Activate() end
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
            target.Humanoid:TakeDamage(5)
            local t = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if t then t:Activate() end
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

-- Fill Pages
local Welcome = Instance.new("TextLabel")
Welcome.Size = UDim2.new(1, 0, 0, 100)
Welcome.BackgroundTransparency = 1
Welcome.Text = "CrownScripts 2026\nStatus: Online\nGame: Sailor Piece\n[INSERT] to hide menu"
Welcome.TextColor3 = Color3.new(1,1,1)
Welcome.TextScaled = true
Welcome.Font = Enum.Font.GothamMedium
Welcome.Parent = Pages[1]

AddToggle(Pages[2], "Kill Aura", false, function(v) killAuraEnabled = v end)
AddToggle(Pages[2], "Team Check", false, function(v) teamCheck = v end)
AddToggle(Pages[2], "Target NPCs", false, function(v) targetNPCs = v end)
AddSlider(Pages[2], "Range", 5, 100, 25, " studs", function(v) killAuraRange = v end)

AddToggle(Pages[3], "Player ESP", false, function(v) espEnabled = v end)

AddToggle(Pages[4], "Auto Leveling", false, function(v) sailorSettings.autoLevel = v end)
AddToggle(Pages[4], "Auto Clicker", false, function(v) sailorSettings.autoAttack = v end)
AddToggle(Pages[4], "Auto Skills", false, function(v) sailorSettings.autoSkills = v end)
AddToggle(Pages[4], "Auto Haki", false, function(v) sailorSettings.autoHaki = v end)
AddToggle(Pages[4], "Auto Stats", false, function(v) sailorSettings.autoStats = v end)
AddToggle(Pages[4], "Auto Boss Farm", false, function(v) sailorSettings.autoBoss = v end)
AddDropdown(Pages[4], "Boss Target", {"All", "Aizen", "True Aizen", "Quincy"}, function(v) sailorSettings.bossTarget = v end)
AddToggle(Pages[4], "Auto Summon Boss", false, function(v) sailorSettings.autoSummon = v end)
AddSlider(Pages[4], "Farm Distance", 5, 15, 8, " studs", function(v) sailorSettings.farmDist = v end)

local questOptions = {"None"}
for k, _ in pairs(questLines) do table.insert(questOptions, k) end
table.sort(questOptions)

local qInfo = Instance.new("TextLabel")
qInfo.Size = UDim2.new(1, -20, 0, 100)
qInfo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
qInfo.Text = "Select a QuestLine to begin automation.\nEnsure you have the required level."
qInfo.TextColor3 = Color3.new(0.8, 0.8, 0.8)
qInfo.TextSize = 16
qInfo.Font = Enum.Font.GothamMedium
qInfo.Parent = Pages[5]
Instance.new("UICorner", qInfo).CornerRadius = UDim.new(0, 12)

AddDropdown(Pages[5], "Select QuestLine", questOptions, function(v) 
    sailorSettings.activeQuestLine = v 
    if v ~= "None" then
        local data = questLines[v]
        qInfo.Text = "Quest: " .. v .. "\nNPC: " .. data.npc .. "\nMobs: " .. table.concat(data.mobs, ", ") .. "\nBoss: " .. (data.boss or "None") .. "\nReq Level: " .. data.level
    else
        qInfo.Text = "Select a QuestLine to begin automation.\nEnsure you have the required level."
    end
end)
AddToggle(Pages[5], "Start QuestLine Farm", false, function(v) 
    if v then sailorSettings.autoLevel, sailorSettings.autoBoss = false, false
    else sailorSettings.activeQuestLine = "None" end 
end)
AddToggle(Pages[5], "Auto NPC Interact", false, function(v) sailorSettings.autoNPC = v end)
AddSlider(Pages[5], "NPC Interaction Dist", 5, 20, 10, " studs", function(v) sailorSettings.npcDist = v end)

AddSlider(Pages[6], "Speed Multiplier", 1, 10, 1, "x", function(v) speedMultiplier = v end)
AddToggle(Pages[6], "Infinite Jump", false, function(v) infiniteJumpEnabled = v end)

local CreditsText = Instance.new("TextLabel")
CreditsText.Size = UDim2.new(1, -40, 0, 200)
CreditsText.Position = UDim2.new(0, 20, 0, 60)
CreditsText.BackgroundTransparency = 1
CreditsText.Text = "crowdsect\ncoleistic\n\ndiscord.gg/crownscripts"
CreditsText.TextColor3 = Color3.new(1, 1, 1)
CreditsText.TextSize = 24
CreditsText.Font = Enum.Font.GothamMedium
CreditsText.Parent = Pages[7]

print("CrownScripts 2026 Loaded Successfully")