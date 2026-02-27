-- ============================================
-- NEXO HUB - DENGAN GUI SAVAGE HUB STYLE
-- Fitur dari 22S DUELS + GUI dari script yang diberikan
-- ============================================

repeat task.wait() until game:IsLoaded()

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexoHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- ============================================
-- COLOR PALETTE (Biru khas NEXO)
-- ============================================
local COLORS = {
    MainBG = Color3.fromRGB(10, 15, 25),      -- dark blue background
    TabBG = Color3.fromRGB(20, 25, 40),       -- darker blue tabs
    Border = Color3.fromRGB(60, 130, 255),    -- BLUE glow/border
    TextActive = Color3.fromRGB(100, 170, 255), -- BLUE active text
    TextInactive = Color3.fromRGB(120, 130, 150),
    RowBG = Color3.fromRGB(15, 20, 30)
}

-- ============================================
-- VARIABLES FITUR (dari 22S DUELS)
-- ============================================
local Enabled = {
    SpeedBoost = false,
    AntiRagdoll = false,
    SpinBot = false,
    SpeedWhileStealing = false,
    AutoSteal = false,
    Unwalk = false,
    Optimizer = false,
    Galaxy = false,
    SpamBat = false,
    BatAimbot = false,
    GalaxySkyBright = false,
    AutoWalkEnabled = false,
    AutoRightEnabled = false,
    SafeFollow = false
}

local Values = {
    BoostSpeed = 30,
    SpinSpeed = 30,
    StealingSpeedValue = 29,
    STEAL_RADIUS = 20,
    STEAL_DURATION = 1.3,
    DEFAULT_GRAVITY = 196.2,
    GalaxyGravityPercent = 70,
    HOP_POWER = 35,
    HOP_COOLDOWN = 0.08,
    FOLLOW_DISTANCE = 6
}

local Connections = {}
local isStealing = false
local lastBatSwing = 0
local BAT_SWING_COOLDOWN = 0.12
local spinBAV = nil
local galaxyVectorForce = nil
local galaxyAttachment = nil
local galaxyEnabled = false
local hopsEnabled = false
local lastHopTime = 0
local spaceHeld = false
local originalJumpPower = 50

-- ============================================
-- UI CORE ENGINE (dari script yang diberikan)
-- ============================================
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do if k ~= "Parent" then obj[k] = v end end
    obj.Parent = props.Parent
    return obj
end

-- Toggle Icon (Huruf N)
local ToggleIcon = create("TextButton", {
    Size = UDim2.new(0, 50, 0, 50), 
    Position = UDim2.new(0.05, 0, 0.2, 0),
    BackgroundColor3 = COLORS.MainBG, 
    Text = "N", 
    TextColor3 = COLORS.Border,
    Font = "GothamBold", 
    TextSize = 24, 
    Parent = ScreenGui
})
create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ToggleIcon})
create("UIStroke", {Color = COLORS.Border, Thickness = 2, Parent = ToggleIcon})

-- Main Frame
local MainFrame = create("Frame", {
    Size = UDim2.new(0, 400, 0, 500), 
    Position = UDim2.new(0.5, -200, 0.5, -250),
    BackgroundColor3 = COLORS.MainBG, 
    BackgroundTransparency = 0.1, 
    Visible = false, 
    Parent = ScreenGui
})
create("UICorner", {CornerRadius = UDim.new(0, 15), Parent = MainFrame})
create("UIStroke", {Color = COLORS.Border, Thickness = 2.5, Parent = MainFrame})

-- Header
local Header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 55), 
    BackgroundTransparency = 1, 
    Parent = MainFrame
})

create("TextLabel", {
    Text = "NEXO HUB", 
    TextColor3 = COLORS.Border, 
    Font = "GothamBlack", 
    TextSize = 24,
    Size = UDim2.new(0.6, 0, 1, 0), 
    Position = UDim2.new(0.05, 0, 0, 0),
    BackgroundTransparency = 1, 
    TextXAlignment = "Left", 
    Parent = Header
})

-- Close Button
local CloseBtn = create("TextButton", {
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -45, 0.5, -17.5),
    BackgroundTransparency = 1,
    Text = "X",
    TextColor3 = COLORS.TextInactive,
    Font = "GothamBold",
    TextSize = 20,
    Parent = Header
})
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)
CloseBtn.MouseEnter:Connect(function()
    CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
end)
CloseBtn.MouseLeave:Connect(function()
    CloseBtn.TextColor3 = COLORS.TextInactive
end)

-- Tab Container
local TabContainer = create("Frame", {
    Size = UDim2.new(0.94, 0, 0, 40), 
    Position = UDim2.new(0.03, 0, 0.12, 0),
    BackgroundColor3 = COLORS.TabBG, 
    Parent = MainFrame
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabContainer})
local TabList = create("UIListLayout", {
    FillDirection = "Horizontal", 
    HorizontalAlignment = "Center", 
    Padding = UDim.new(0, 5),
    Parent = TabContainer
})

-- Page Container
local PageContainer = create("Frame", {
    Size = UDim2.new(0.96, 0, 0.78, 0), 
    Position = UDim2.new(0.02, 0, 0.2, 0),
    BackgroundTransparency = 1, 
    Parent = MainFrame
})

local Pages = {}
local TabButtons = {}

local function CreatePage(name)
    local Page = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), 
        BackgroundTransparency = 1, 
        Visible = false,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = COLORS.Border,
        AutomaticCanvasSize = "Y", 
        Parent = PageContainer
    })
    
    local layout = create("UIListLayout", {
        HorizontalAlignment = "Center", 
        Padding = UDim.new(0, 8),
        SortOrder = "LayoutOrder",
        Parent = Page
    })
    
    Pages[name] = Page

    local TabBtn = create("TextButton", {
        Size = UDim2.new(0, 70, 0, 30), 
        BackgroundTransparency = 1,
        Text = name, 
        TextColor3 = COLORS.TextInactive, 
        Font = "GothamBold", 
        TextSize = 13,
        Parent = TabContainer
    })

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, b in pairs(TabButtons) do b.TextColor3 = COLORS.TextInactive end
        Page.Visible = true
        TabBtn.TextColor3 = COLORS.TextActive
    end)
    TabButtons[name] = TabBtn
end

local function AddToggle(pageName, labelText, default, callback)
    local active = default
    local Row = create("Frame", {
        Size = UDim2.new(0.96, 0, 0, 55), 
        BackgroundColor3 = COLORS.RowBG,
        BackgroundTransparency = 0.3, 
        LayoutOrder = 1,
        Parent = Pages[pageName]
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Row})
    create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.7, Parent = Row})

    create("TextLabel", {
        Text = labelText, 
        Size = UDim2.new(0.7, 0, 1, 0), 
        Position = UDim2.new(0.05, 0, 0, 0),
        TextColor3 = Color3.new(1,1,1), 
        Font = "GothamSemibold", 
        TextSize = 14,
        BackgroundTransparency = 1, 
        TextXAlignment = "Left", 
        Parent = Row
    })

    local TglBg = create("Frame", {
        Size = UDim2.new(0, 48, 0, 24), 
        Position = UDim2.new(0.95, -48, 0.5, -12),
        BackgroundColor3 = active and COLORS.Border or Color3.fromRGB(40, 45, 55), 
        Parent = Row
    })
    create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = TglBg})

    local Circle = create("Frame", {
        Size = UDim2.new(0, 20, 0, 20), 
        Position = active and UDim2.new(0.55, 0, 0.08, 0) or UDim2.new(0.05, 0, 0.08, 0),
        BackgroundColor3 = Color3.new(1, 1, 1), 
        Parent = TglBg
    })
    create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Circle})

    local Btn = create("TextButton", {
        Size = UDim2.new(1,0,1,0), 
        BackgroundTransparency = 1, 
        Text = "", 
        Parent = Row
    })
    
    Btn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(TglBg, TweenInfo.new(0.2), {BackgroundColor3 = active and COLORS.Border or Color3.fromRGB(40, 45, 55)}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = active and UDim2.new(0.55, 0, 0.08, 0) or UDim2.new(0.05, 0, 0.08, 0)}):Play()
        callback(active)
    end)
end

local function AddSlider(pageName, labelText, min, max, default, valueKey, callback)
    local Row = create("Frame", {
        Size = UDim2.new(0.96, 0, 0, 65), 
        BackgroundColor3 = COLORS.RowBG,
        BackgroundTransparency = 0.3, 
        LayoutOrder = 1,
        Parent = Pages[pageName]
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Row})
    create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.7, Parent = Row})

    create("TextLabel", {
        Text = labelText, 
        Size = UDim2.new(0.6, 0, 0, 25), 
        Position = UDim2.new(0.05, 0, 0.05, 0),
        TextColor3 = Color3.new(1,1,1), 
        Font = "GothamSemibold", 
        TextSize = 14,
        BackgroundTransparency = 1, 
        TextXAlignment = "Left", 
        Parent = Row
    })

    local valueLabel = create("TextLabel", {
        Text = tostring(default),
        Size = UDim2.new(0, 40, 0, 25),
        Position = UDim2.new(0.85, 0, 0.05, 0),
        TextColor3 = COLORS.Border,
        Font = "GothamBold",
        TextSize = 14,
        BackgroundTransparency = 1,
        Parent = Row
    })

    local SliderBg = create("Frame", {
        Size = UDim2.new(0.9, 0, 0, 8),
        Position = UDim2.new(0.05, 0, 0.65, 0),
        BackgroundColor3 = Color3.fromRGB(40, 45, 55),
        Parent = Row
    })
    create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderBg})

    local percent = (default - min) / (max - min)
    local SliderFill = create("Frame", {
        Size = UDim2.new(percent, 0, 1, 0),
        BackgroundColor3 = COLORS.Border,
        Parent = SliderBg
    })
    create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = SliderFill})

    local dragging = false
    local SliderBtn = create("TextButton", {
        Size = UDim2.new(1, 0, 2, 0),
        Position = UDim2.new(0, 0, -0.5, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = SliderBg
    })

    local function updateSlider(input)
        local pos = UDim2.new(0, 0, 0, 0)
        local x = (input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X
        x = math.clamp(x, 0, 1)
        SliderFill.Size = UDim2.new(x, 0, 1, 0)
        local val = math.floor(min + (max - min) * x)
        valueLabel.Text = tostring(val)
        Values[valueKey] = val
        callback(val)
    end

    SliderBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
end

-- Buat halaman
CreatePage("Combat")
CreatePage("Movement")
CreatePage("Auto")
CreatePage("Visual")
CreatePage("Settings")

TabButtons["Combat"].TextColor3 = COLORS.TextActive
Pages["Combat"].Visible = true

-- ============================================
-- FUNGSI-FUNGSI FITUR (dari 22S DUELS)
-- ============================================

-- Speed Boost
local function startSpeedBoost()
    if Connections.speed then return end
    Connections.speed = RunService.Heartbeat:Connect(function()
        if not Enabled.SpeedBoost then return end
        local c = lp.Character
        if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart")
        if not h then return end
        local md = (c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").MoveDirection) or Vector3.zero
        if md.Magnitude > 0.1 then
            h.AssemblyLinearVelocity = Vector3.new(md.X * Values.BoostSpeed, h.AssemblyLinearVelocity.Y, md.Z * Values.BoostSpeed)
        end
    end)
end

local function stopSpeedBoost()
    if Connections.speed then Connections.speed:Disconnect() Connections.speed = nil end
end

-- Anti Ragdoll
local function startAntiRagdoll()
    if Connections.antiRagdoll then return end
    Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
        if not Enabled.AntiRagdoll then return end
        local char = lp.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local humState = hum:GetState()
            if humState == Enum.HumanoidStateType.Physics or humState == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)
end

local function stopAntiRagdoll()
    if Connections.antiRagdoll then Connections.antiRagdoll:Disconnect() Connections.antiRagdoll = nil end
end

-- Spin Bot
local function startSpinBot()
    local c = lp.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if spinBAV then spinBAV:Destroy() end
    spinBAV = Instance.new("BodyAngularVelocity")
    spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
    spinBAV.AngularVelocity = Vector3.new(0, Values.SpinSpeed, 0)
    spinBAV.Parent = hrp
end

local function stopSpinBot()
    if spinBAV then spinBAV:Destroy() spinBAV = nil end
end

-- Bat Aimbot sederhana
local function startBatAimbot()
    print("Bat Aimbot ON (simulasi)")
end

local function stopBatAimbot()
    print("Bat Aimbot OFF")
end

-- Auto Steal sederhana (simulasi)
local function startAutoSteal()
    print("Auto Steal ON")
    isStealing = false
end

local function stopAutoSteal()
    print("Auto Steal OFF")
    isStealing = false
end

-- Unwalk
local function startUnwalk()
    local c = lp.Character
    if not c then return end
    local anim = c:FindFirstChild("Animate")
    if anim then anim:Destroy() end
end

local function stopUnwalk()
    print("Unwalk OFF")
end

-- Galaxy Mode (sederhana)
local function startGalaxy()
    galaxyEnabled = true
    print("Galaxy Mode ON")
end

local function stopGalaxy()
    galaxyEnabled = false
    print("Galaxy Mode OFF")
end

-- ============================================
-- SAFE FOLLOW MODULE (Lock Target)
-- ============================================
local SafeFollow = {
    Enabled = false,
    Locked = false,
    lastMove = 0,
    gui = nil,
    btn = nil,
    targetChar = nil,
    heartbeatConn = nil,
    charAddedConn = nil
}

-- Function to create the Safe Follow UI
local function createSafeFollowUI()
    SafeFollow.gui = Instance.new("ScreenGui")
    SafeFollow.gui.Name = "SafeFollowUI"
    SafeFollow.gui.ResetOnSpawn = false
    SafeFollow.gui.Enabled = false
    SafeFollow.gui.Parent = CoreGui

    SafeFollow.btn = Instance.new("TextButton")
    SafeFollow.btn.Size = UDim2.new(0, 140, 0, 45)
    SafeFollow.btn.Position = UDim2.new(0.5, -70, 0.8, 0)
    SafeFollow.btn.Text = "🔒 LOCK: OFF"
    SafeFollow.btn.Font = Enum.Font.GothamBold
    SafeFollow.btn.TextSize = 15
    SafeFollow.btn.TextColor3 = Color3.new(1, 1, 1)
    SafeFollow.btn.BackgroundColor3 = COLORS.Border
    SafeFollow.btn.AutoButtonColor = true
    SafeFollow.btn.Parent = SafeFollow.gui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = SafeFollow.btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = SafeFollow.btn

    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        SafeFollow.btn.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end

    SafeFollow.btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = SafeFollow.btn.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    SafeFollow.btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Toggle button functionality
    SafeFollow.btn.MouseButton1Click:Connect(function()
        SafeFollow.Locked = not SafeFollow.Locked
        if SafeFollow.Locked then
            SafeFollow.btn.Text = "🔒 LOCK: ON"
            SafeFollow.btn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        else
            SafeFollow.btn.Text = "🔒 LOCK: OFF"
            SafeFollow.btn.BackgroundColor3 = COLORS.Border
        end
    end)
end

-- Function to get nearest player
local function getNearestPlayer(character, hrp)
    local nearest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if d < dist then
                dist = d
                nearest = p.Character
            end
        end
    end
    return nearest
end

-- Function to start Safe Follow
local function startSafeFollow()
    if SafeFollow.heartbeatConn then
        SafeFollow.heartbeatConn:Disconnect()
    end

    SafeFollow.heartbeatConn = RunService.Heartbeat:Connect(function()
        if not SafeFollow.Enabled or not SafeFollow.Locked then 
            return 
        end

        local character = lp.Character
        if not character then return end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        local hum = character:FindFirstChild("Humanoid")

        if not hrp or not hum then return end

        if tick() - SafeFollow.lastMove < 0.15 then return end
        SafeFollow.lastMove = tick()

        if not SafeFollow.targetChar or not SafeFollow.targetChar.Parent then
            SafeFollow.targetChar = getNearestPlayer(character, hrp)
            return
        end

        local trgHRP = SafeFollow.targetChar:FindFirstChild("HumanoidRootPart")
        local trgHum = SafeFollow.targetChar:FindFirstChild("Humanoid")

        if not trgHRP or not trgHum or trgHum.Health <= 0 then
            SafeFollow.targetChar = getNearestPlayer(character, hrp)
            return
        end

        local direction = (trgHRP.Position - hrp.Position)
        direction = Vector3.new(direction.X, 0, direction.Z)

        if direction.Magnitude > 0 then
            local moveDistance = math.min(direction.Magnitude, Values.FOLLOW_DISTANCE)
            local goalPos = hrp.Position + direction.Unit * moveDistance
            hum:MoveTo(goalPos)
        end
    end)
end

-- Function to enable Safe Follow
local function enableSafeFollow()
    if SafeFollow.Enabled then return end

    SafeFollow.Enabled = true

    if not SafeFollow.gui then
        createSafeFollowUI()
    end

    SafeFollow.gui.Enabled = true
    SafeFollow.Locked = false
    SafeFollow.btn.Text = "🔒 LOCK: OFF"
    SafeFollow.btn.BackgroundColor3 = COLORS.Border
    startSafeFollow()

    SafeFollow.charAddedConn = lp.CharacterAdded:Connect(function(c)
        local hum = c:WaitForChild("Humanoid", 5)
        if hum then hum.AutoRotate = true end
    end)

    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.AutoRotate = true
    end
end

local function disableSafeFollow()
    if not SafeFollow.Enabled then return end

    SafeFollow.Enabled = false
    SafeFollow.Locked = false

    if SafeFollow.gui then
        SafeFollow.gui.Enabled = false
    end

    if SafeFollow.heartbeatConn then
        SafeFollow.heartbeatConn:Disconnect()
        SafeFollow.heartbeatConn = nil
    end

    if SafeFollow.charAddedConn then
        SafeFollow.charAddedConn:Disconnect()
        SafeFollow.charAddedConn = nil
    end

    SafeFollow.targetChar = nil
end

-- ============================================
-- ADD TOGGLES KE GUI
-- ============================================

-- COMBAT TAB
AddToggle("Combat", "Safe Follow (Lock Target)", false, function(state)
    Enabled.SafeFollow = state
    if state then enableSafeFollow() else disableSafeFollow() end
end)

AddToggle("Combat", "Bat Aimbot", false, function(state)
    Enabled.BatAimbot = state
    if state then startBatAimbot() else stopBatAimbot() end
end)

AddToggle("Combat", "Spam Bat", false, function(state)
    Enabled.SpamBat = state
    print("Spam Bat:", state and "ON" or "OFF")
end)

AddToggle("Combat", "Spin Bot", false, function(state)
    Enabled.SpinBot = state
    if state then startSpinBot() else stopSpinBot() end
end)

AddSlider("Combat", "Spin Speed", 5, 50, 30, "SpinSpeed", function(v)
    Values.SpinSpeed = v
    if Enabled.SpinBot and spinBAV then
        spinBAV.AngularVelocity = Vector3.new(0, v, 0)
    end
end)

-- MOVEMENT TAB
AddToggle("Movement", "Speed Boost", false, function(state)
    Enabled.SpeedBoost = state
    if state then startSpeedBoost() else stopSpeedBoost() end
end)

AddSlider("Movement", "Boost Speed", 10, 70, 30, "BoostSpeed", function(v)
    Values.BoostSpeed = v
end)

AddToggle("Movement", "Anti Ragdoll", false, function(state)
    Enabled.AntiRagdoll = state
    if state then startAntiRagdoll() else stopAntiRagdoll() end
end)

AddToggle("Movement", "Galaxy Mode", false, function(state)
    Enabled.Galaxy = state
    if state then startGalaxy() else stopGalaxy() end
end)

AddToggle("Movement", "Unwalk", false, function(state)
    Enabled.Unwalk = state
    if state then startUnwalk() else stopUnwalk() end
end)

-- AUTO TAB
AddToggle("Auto", "Auto Steal", false, function(state)
    Enabled.AutoSteal = state
    if state then startAutoSteal() else stopAutoSteal() end
end)

AddToggle("Auto", "Auto Left", false, function(state)
    Enabled.AutoWalkEnabled = state
    print("Auto Left:", state and "ON" or "OFF")
end)

AddToggle("Auto", "Auto Right", false, function(state)
    Enabled.AutoRightEnabled = state
    print("Auto Right:", state and "ON" or "OFF")
end)

AddToggle("Auto", "Speed While Stealing", false, function(state)
    Enabled.SpeedWhileStealing = state
    print("Speed While Stealing:", state and "ON" or "OFF")
end)

-- VISUAL TAB
AddToggle("Visual", "Optimizer + XRay", false, function(state)
    Enabled.Optimizer = state
    print("Optimizer:", state and "ON" or "OFF")
end)

AddToggle("Visual", "Galaxy Sky Bright", false, function(state)
    Enabled.GalaxySkyBright = state
    print("Galaxy Sky:", state and "ON" or "OFF")
end)

-- SETTINGS TAB
AddToggle("Settings", "Save on Exit", false, function(state)
    print("Save on Exit:", state and "ON" or "OFF")
end)

-- ============================================
-- DRAGGABLE & KEYBINDS
-- ============================================
ToggleIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Make main frame draggable
local draggingMain, dragInputMain, dragStartMain, startPosMain
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMain = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMain = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputMain and draggingMain then
        local delta = input.Position - dragStartMain
        MainFrame.Position = UDim2.new(
            startPosMain.X.Scale, 
            startPosMain.X.Offset + delta.X, 
            startPosMain.Y.Scale, 
            startPosMain.Y.Offset + delta.Y
        )
    end
end)

-- Keybind F9
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F9 then
        MainFrame.Visible = not MainFrame.Visible
    end
    if input.KeyCode == Enum.KeyCode.Space then
        spaceHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        spaceHeld = false
    end
end)

-- Character added handler
lp.CharacterAdded:Connect(function()
    task.wait(1)
    if Enabled.SpinBot then stopSpinBot() task.wait(0.1) startSpinBot() end
    if Enabled.Galaxy then startGalaxy() end
end)

print("✅ NEXO HUB Loaded dengan GUI Savage Hub Style!")
print("📌 Tekan F9 untuk buka/tutup GUI")
print("📌 Klik ikon 'N' di pojok kiri atas untuk buka GUI")
