-- ============================================
-- KAWATAN HUB STYLE GUI
-- Dengan Auto Play Sub-GUI
-- ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

-- Variables untuk Auto Play
local AutoPlayGUI = nil
local AutoPlayEnabled = false
local AutoPlayVisible = false

-- ============================================
-- MAIN GUI
-- ============================================
local sg = Instance.new("ScreenGui")
sg.Name = "KawatanHub"
sg.ResetOnSpawn = false
sg.Parent = Player.PlayerGui

-- Fungsi untuk membuat UI Stroke gradient
local function addGradientStroke(frame, color1, color2)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.5, color2),
        ColorSequenceKeypoint.new(1, color1)
    })
    return grad
end

-- MAIN WINDOW
local main = Instance.new("Frame", sg)
main.Name = "Main"
main.Size = UDim2.new(0, 300, 0, 400)
main.Position = UDim2.new(0.5, -150, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Stroke gradient biru-ungu
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 2
local mainGrad = Instance.new("UIGradient", mainStroke)
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
})

-- HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Kawatan Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Center

local subtitle = Instance.new("TextLabel", header)
subtitle.Size = UDim2.new(1, 0, 0, 15)
subtitle.Position = UDim2.new(0, 0, 1, -15)
subtitle.BackgroundTransparency = 1
subtitle.Text = "discord.gg/kawatanhub"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 255)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10

-- CLOSE BUTTON
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.ZIndex = 5
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- CONTENT
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, 0, 1, -60)
content.Position = UDim2.new(0, 0, 0, 55)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.CanvasSize = UDim2.new(0, 0, 0, 400)
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)

local layout = Instance.new("UIListLayout", content)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)

local padding = Instance.new("UIPadding", content)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.PaddingTop = UDim.new(0, 10)

-- ============================================
-- FUNGSI MEMBUAT SECTION
-- ============================================
local function createSection(parent, title)
    local section = Instance.new("Frame", parent)
    section.Size = UDim2.new(1, 0, 0, 30)
    section.BackgroundTransparency = 1
    section.BorderSizePixel = 0
    
    local line = Instance.new("Frame", section)
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, -1)
    line.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    
    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(0, 100, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return section
end

-- ============================================
-- FUNGSI MEMBUAT BUTTON
-- ============================================
local function createButton(parent, text, order)
    local btn = Instance.new("TextButton", parent)
    btn.Name = text:gsub("%s+", "")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.LayoutOrder = order or 1
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(100, 150, 255)
    btnStroke.Transparency = 0.5
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    end)
    
    return btn
end

-- ============================================
-- FUNGSI MEMBUAT TOGGLE
-- ============================================
local function createToggle(parent, text, default, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBg = Instance.new("Frame", row)
    toggleBg.Size = UDim2.new(0, 40, 0, 20)
    toggleBg.Position = UDim2.new(1, -45, 0.5, -10)
    toggleBg.BackgroundColor3 = default and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(50, 50, 65)
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local toggleCircle = Instance.new("Frame", toggleBg)
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local isOn = default
    
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggleBg.BackgroundColor3 = isOn and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(50, 50, 65)
        toggleCircle:TweenPosition(isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quad", 0.2, true)
        callback(isOn)
    end)
    
    return row
end

-- ============================================
-- MEMBUAT KONTEN MAIN GUI
-- ============================================

-- Section: Auto Walk
createSection(content, "Auto Walk").LayoutOrder = 1

-- Tombol Auto Play
local autoPlayBtn = createButton(content, "Auto Play", 2)
autoPlayBtn.MouseButton1Click:Connect(function()
    AutoPlayVisible = not AutoPlayVisible
    if AutoPlayVisible then
        showAutoPlayGUI()
        autoPlayBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    else
        hideAutoPlayGUI()
        autoPlayBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    end
end)

createButton(content, "Lock Target", 3)
createButton(content, "Auto Medusa", 4)
createButton(content, "Auto Bat", 5)

-- Section: Butavernulus
createSection(content, "Butavernulus").LayoutOrder = 6

createButton(content, "Combat", 7)
createButton(content, "Protect", 8)
createButton(content, "Visual", 9)
createButton(content, "Settings", 10)
createButton(content, "Keys", 11)

-- Label user
local userLabel = Instance.new("TextLabel", content)
userLabel.Size = UDim2.new(1, 0, 0, 30)
userLabel.BackgroundTransparency = 1
userLabel.Text = "putravernulus"
userLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
userLabel.Font = Enum.Font.GothamBold
userLabel.TextSize = 14
userLabel.LayoutOrder = 12

local discordLabel = Instance.new("TextLabel", content)
discordLabel.Size = UDim2.new(1, 0, 0, 20)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/kawatanhub"
discordLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextSize = 12
discordLabel.LayoutOrder = 13

-- Section: Butavernulus (bottom)
createSection(content, "Butavernulus").LayoutOrder = 14

-- Bottom buttons (grid)
local gridFrame = Instance.new("Frame", content)
gridFrame.Size = UDim2.new(1, 0, 0, 180)
gridFrame.BackgroundTransparency = 1
gridFrame.LayoutOrder = 15

local gridLayout = Instance.new("UIGridLayout", gridFrame)
gridLayout.CellSize = UDim2.new(0, 85, 0, 35)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.StartCorner = Enum.StartCorner.TopLeft
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

local bottomButtons = {
    "FLOAT", "LOCK", "FLING", "AUTO PLAY",
    "PLAY", "SURAT", "Piala", "Kedai", 
    "Obat"
}

for i, btnText in ipairs(bottomButtons) do
    local btn = Instance.new("TextButton", gridFrame)
    btn.Size = UDim2.new(0, 85, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = btnText
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.LayoutOrder = i
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    if btnText == "AUTO PLAY" then
        btn.MouseButton1Click:Connect(function()
            AutoPlayVisible = not AutoPlayVisible
            if AutoPlayVisible then
                showAutoPlayGUI()
                btn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
            else
                hideAutoPlayGUI()
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            end
        end)
    end
end

-- ============================================
-- AUTO PLAY SUB-GUI
-- ============================================
local function createAutoPlayGUI()
    if AutoPlayGUI then return end
    
    AutoPlayGUI = Instance.new("Frame", sg)
    AutoPlayGUI.Name = "AutoPlayGUI"
    AutoPlayGUI.Size = UDim2.new(0, 250, 0, 300)
    AutoPlayGUI.Position = UDim2.new(0.5, 150, 0.5, -150)
    AutoPlayGUI.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    AutoPlayGUI.BorderSizePixel = 0
    AutoPlayGUI.Active = true
    AutoPlayGUI.Draggable = true
    AutoPlayGUI.Visible = false
    Instance.new("UICorner", AutoPlayGUI).CornerRadius = UDim.new(0, 10)
    
    -- Stroke
    local apStroke = Instance.new("UIStroke", AutoPlayGUI)
    apStroke.Thickness = 2
    local apGrad = Instance.new("UIGradient", apStroke)
    apGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 150))
    })
    
    -- Header
    local apHeader = Instance.new("Frame", AutoPlayGUI)
    apHeader.Size = UDim2.new(1, 0, 0, 40)
    apHeader.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    apHeader.BorderSizePixel = 0
    Instance.new("UICorner", apHeader).CornerRadius = UDim.new(0, 10)
    
    local apTitle = Instance.new("TextLabel", apHeader)
    apTitle.Size = UDim2.new(1, 0, 1, 0)
    apTitle.BackgroundTransparency = 1
    apTitle.Text = "Auto Play Settings"
    apTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    apTitle.Font = Enum.Font.GothamBold
    apTitle.TextSize = 14
    
    -- Lock button
    local lockBtn = Instance.new("TextButton", apHeader)
    lockBtn.Size = UDim2.new(0, 24, 0, 24)
    lockBtn.Position = UDim2.new(1, -28, 0.5, -12)
    lockBtn.BackgroundTransparency = 1
    lockBtn.Text = "🔒"
    lockBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    lockBtn.Font = Enum.Font.Gotham
    lockBtn.TextSize = 16
    lockBtn.ZIndex = 5
    
    local isLocked = false
    lockBtn.MouseButton1Click:Connect(function()
        isLocked = not isLocked
        AutoPlayGUI.Draggable = not isLocked
        lockBtn.Text = isLocked and "🔓" or "🔒"
        lockBtn.TextColor3 = isLocked and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(200, 200, 200)
    end)
    
    -- Close button
    local apCloseBtn = Instance.new("TextButton", apHeader)
    apCloseBtn.Size = UDim2.new(0, 24, 0, 24)
    apCloseBtn.Position = UDim2.new(1, -52, 0.5, -12)
    apCloseBtn.BackgroundTransparency = 1
    apCloseBtn.Text = "×"
    apCloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    apCloseBtn.Font = Enum.Font.GothamBold
    apCloseBtn.TextSize = 20
    apCloseBtn.ZIndex = 5
    apCloseBtn.MouseButton1Click:Connect(function()
        AutoPlayVisible = false
        hideAutoPlayGUI()
    end)
    
    -- Content
    local apContent = Instance.new("Frame", AutoPlayGUI)
    apContent.Size = UDim2.new(1, -20, 1, -50)
    apContent.Position = UDim2.new(0, 10, 0, 45)
    apContent.BackgroundTransparency = 1
    
    local apLayout = Instance.new("UIListLayout", apContent)
    apLayout.SortOrder = Enum.SortOrder.LayoutOrder
    apLayout.Padding = UDim.new(0, 10)
    
    -- Auto Play toggle
    local apToggle = createToggle(apContent, "Enable Auto Play", false, function(state)
        AutoPlayEnabled = state
        print("Auto Play:", state and "ON" or "OFF")
    end)
    apToggle.LayoutOrder = 1
    
    -- Speed slider
    local speedFrame = Instance.new("Frame", apContent)
    speedFrame.Size = UDim2.new(1, 0, 0, 50)
    speedFrame.BackgroundTransparency = 1
    speedFrame.LayoutOrder = 2
    
    local speedLabel = Instance.new("TextLabel", speedFrame)
    speedLabel.Size = UDim2.new(1, 0, 0, 20)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed"
    speedLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 14
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local speedValue = Instance.new("TextBox", speedFrame)
    speedValue.Size = UDim2.new(0, 50, 0, 20)
    speedValue.Position = UDim2.new(1, -50, 0, 0)
    speedValue.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    speedValue.Text = "30"
    speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedValue.Font = Enum.Font.GothamBold
    speedValue.TextSize = 12
    Instance.new("UICorner", speedValue).CornerRadius = UDim.new(0, 4)
    
    local sliderBg = Instance.new("Frame", speedFrame)
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 1, -10)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
    
    -- Mode dropdown
    local modeFrame = Instance.new("Frame", apContent)
    modeFrame.Size = UDim2.new(1, 0, 0, 30)
    modeFrame.BackgroundTransparency = 1
    modeFrame.LayoutOrder = 3
    
    local modeLabel = Instance.new("TextLabel", modeFrame)
    modeLabel.Size = UDim2.new(0.5, 0, 1, 0)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = "Mode:"
    modeLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    modeLabel.Font = Enum.Font.Gotham
    modeLabel.TextSize = 14
    modeLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local modeBtn = Instance.new("TextButton", modeFrame)
    modeBtn.Size = UDim2.new(0.5, 0, 1, 0)
    modeBtn.Position = UDim2.new(0.5, 0, 0, 0)
    modeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    modeBtn.Text = "Left ↔ Right"
    modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeBtn.Font = Enum.Font.Gotham
    modeBtn.TextSize = 12
    Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 4)
    
    local modes = {"Left ↔ Right", "Left Only", "Right Only", "Circle"}
    local currentMode = 1
    
    modeBtn.MouseButton1Click:Connect(function()
        currentMode = currentMode % #modes + 1
        modeBtn.Text = modes[currentMode]
    end)
    
    -- Start/Stop button
    local startBtn = Instance.new("TextButton", apContent)
    startBtn.Size = UDim2.new(1, 0, 0, 40)
    startBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    startBtn.Text = "START AUTO PLAY"
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 14
    startBtn.LayoutOrder = 4
    Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 6)
    
    local isRunning = false
    startBtn.MouseButton1Click:Connect(function()
        isRunning = not isRunning
        startBtn.Text = isRunning and "STOP AUTO PLAY" or "START AUTO PLAY"
        startBtn.BackgroundColor3 = isRunning and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(100, 150, 255)
        print("Auto Play:", isRunning and "Started" or "Stopped")
    end)
end

-- Fungsi untuk show/hide
local function showAutoPlayGUI()
    if not AutoPlayGUI then createAutoPlayGUI() end
    if AutoPlayGUI then AutoPlayGUI.Visible = true end
end

local function hideAutoPlayGUI()
    if AutoPlayGUI then AutoPlayGUI.Visible = false end
end

-- Buat Auto Play GUI
createAutoPlayGUI()

-- ============================================
-- ANIMASI STROKE BERGERAK
-- ============================================
task.spawn(function()
    local rot = 0
    while sg.Parent do
        rot = (rot + 1) % 360
        if mainGrad then mainGrad.Rotation = rot end
        if AutoPlayGUI and AutoPlayGUI.Visible then
            local apStroke = AutoPlayGUI:FindFirstChildOfClass("UIStroke")
            if apStroke then
                local grad = apStroke:FindFirstChildOfClass("UIGradient")
                if grad then grad.Rotation = rot * 2 end
            end
        end
        task.wait(0.03)
    end
end)

print("Kawatan Hub Loaded!")