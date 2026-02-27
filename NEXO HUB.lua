-- ============================================
-- NEXO HUB - SAVAGE HUB STYLE
-- Dengan Safe Follow (Lock Target) Toggle
-- ============================================

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

-- Color Palette - NEXO Colors (Biru/Oranye)
local COLORS = {
    MainBG = Color3.fromRGB(10, 15, 25),      -- dark blue background
    TabBG = Color3.fromRGB(20, 25, 40),       -- darker blue tabs
    Border = Color3.fromRGB(60, 130, 255),    -- BLUE glow/border
    TextActive = Color3.fromRGB(100, 170, 255), -- BLUE active text
    TextInactive = Color3.fromRGB(120, 130, 150),
    RowBG = Color3.fromRGB(15, 20, 30)
}

-- UI CORE ENGINE

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
    Size = UDim2.new(0, 380, 0, 450), 
    Position = UDim2.new(0.5, -190, 0.5, -225),
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
    Size = UDim2.new(0.94, 0, 0, 35), 
    Position = UDim2.new(0.03, 0, 0.13, 0),
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
    Size = UDim2.new(0.96, 0, 0.75, 0), 
    Position = UDim2.new(0.02, 0, 0.22, 0),
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
        Size = UDim2.new(0.22, 0, 1, 0), 
        BackgroundTransparency = 1,
        Text = name, 
        TextColor3 = COLORS.TextInactive, 
        Font = "GothamBold", 
        TextSize = 12,
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

local function AddButton(pageName, text, color, callback)
    local Row = create("Frame", {
        Size = UDim2.new(0.96, 0, 0, 55), 
        BackgroundColor3 = COLORS.RowBG,
        BackgroundTransparency = 0.3, 
        LayoutOrder = 1,
        Parent = Pages[pageName]
    })
    create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Row})
    create("UIStroke", {Color = COLORS.Border, Thickness = 1, Transparency = 0.7, Parent = Row})

    local Btn = create("TextButton", {
        Size = UDim2.new(0.9, 0, 0.7, 0),
        Position = UDim2.new(0.05, 0, 0.15, 0),
        BackgroundColor3 = color or COLORS.Border,
        Text = text,
        TextColor3 = Color3.new(1,1,1),
        Font = "GothamBold",
        TextSize = 14,
        Parent = Row
    })
    create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Btn})
    
    Btn.MouseButton1Click:Connect(callback)
    
    -- Hover effect
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.2)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
end

-- Create Pages
for _, tab in ipairs({"Combat", "Protect", "Visual", "Settings", "Auto"}) do 
    CreatePage(tab) 
end
TabButtons["Combat"].TextColor3 = COLORS.TextActive
Pages["Combat"].Visible = true

-- ============================================
-- SAFE FOLLOW MODULE (Lock Target)
-- ============================================

local SafeFollow = {
    Enabled = false,
    Locked = false,
    FOLLOW_DISTANCE = 6,
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

        -- If no target or target is invalid, get nearest
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
            local moveDistance = math.min(direction.Magnitude, SafeFollow.FOLLOW_DISTANCE)
            local goalPos = hrp.Position + direction.Unit * moveDistance
            hum:MoveTo(goalPos)
        end
    end)
end

-- Function to enable Safe Follow
local function enableSafeFollow()
    if SafeFollow.Enabled then return end

    SafeFollow.Enabled = true

    -- Create UI if it doesn't exist
    if not SafeFollow.gui then
        createSafeFollowUI()
    end

    SafeFollow.gui.Enabled = true

    -- Reset locked state
    SafeFollow.Locked = false
    if SafeFollow.btn then
        SafeFollow.btn.Text = "🔒 LOCK: OFF"
        SafeFollow.btn.BackgroundColor3 = COLORS.Border
    end

    -- Start the follow logic
    startSafeFollow()

    -- Handle character added
    SafeFollow.charAddedConn = lp.CharacterAdded:Connect(function(c)
        local hum = c:WaitForChild("Humanoid", 5)
        if hum then
            hum.AutoRotate = true
        end
    end)

    -- Set current character's auto rotate
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.AutoRotate = true
    end
end

-- Function to disable Safe Follow
local function disableSafeFollow()
    if not SafeFollow.Enabled then return end

    SafeFollow.Enabled = false
    SafeFollow.Locked = false

    -- Hide UI
    if SafeFollow.gui then
        SafeFollow.gui.Enabled = false
    end

    -- Disconnect connections
    if SafeFollow.heartbeatConn then
        SafeFollow.heartbeatConn:Disconnect()
        SafeFollow.heartbeatConn = nil
    end

    if SafeFollow.charAddedConn then
        SafeFollow.charAddedConn:Disconnect()
        SafeFollow.charAddedConn = nil
    end

    -- Reset target
    SafeFollow.targetChar = nil
end

-- Add toggle for Safe Follow in Combat tab
AddToggle("Combat", "Safe Follow (Lock Target)", false, function(state)
    if state then
        enableSafeFollow()
    else
        disableSafeFollow()
    end
end)

-- Add other Combat toggles
AddToggle("Combat", "Aimbot", false, function(state)
    print("Aimbot:", state and "ON" or "OFF")
end)

AddToggle("Combat", "Anti Ragdoll", false, function(state)
    print("Anti Ragdoll:", state and "ON" or "OFF")
end)

-- Protect tab toggles
AddToggle("Protect", "Auto Shield", false, function(state)
    print("Auto Shield:", state and "ON" or "OFF")
end)

AddToggle("Protect", "Anti Stun", false, function(state)
    print("Anti Stun:", state and "ON" or "OFF")
end)

-- Visual tab toggles
AddToggle("Visual", "ESP Players", false, function(state)
    print("ESP:", state and "ON" or "OFF")
end)

AddToggle("Visual", "X-Ray", false, function(state)
    print("X-Ray:", state and "ON" or "OFF")
end)

-- Auto tab toggles
AddToggle("Auto", "Auto Left", false, function(state)
    print("Auto Left:", state and "ON" or "OFF")
end)

AddToggle("Auto", "Auto Right", false, function(state)
    print("Auto Right:", state and "ON" or "OFF")
end)

AddToggle("Auto", "Auto Steal", false, function(state)
    print("Auto Steal:", state and "ON" or "OFF")
end)

-- Settings tab buttons
AddButton("Settings", "Save Config", COLORS.Border, function()
    print("Config Saved!")
end)

AddButton("Settings", "Load Config", COLORS.Border, function()
    print("Config Loaded!")
end)

-- Initialize UI toggle
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

-- Keybind untuk buka/tutup (F9)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    
    if input.KeyCode == Enum.KeyCode.F9 then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("✅ NEXO HUB Loaded!")
print("📌 Press F9 to open/close GUI")
