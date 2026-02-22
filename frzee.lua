-- SCRIPT FREEZE TRADE VISUAL - STEAL A BRAINROT
-- [⚠️ EDUKASI SAJA - RISIKO BAN SANGAT TINGGI]
-- Dibuat berdasarkan pemahaman sistem trade Roblox

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

-- ===========================================
-- KONFIGURASI
-- ===========================================
local config = {
    itemPalsu = "A",        -- Item yang akan TERLIHAT di layar lawan
    itemAsli = "B",         -- Item yang SEBENARNYA Anda pasang
    aktifkanFreeze = true,
    modeVisualOnly = true   -- Hanya manipulasi tampilan (lebih aman)
}

-- ===========================================
-- FUNGSI UTAMA FREEZE
-- ===========================================

-- Mencari RemoteEvent trade
local tradeEvent = nil
local possibleEvents = {
    "TradeEvent", "TradeSystem", "TradeRemote", 
    "UpdateTrade", "ClientTrade", "TradeRequest"
}

for _, eventName in pairs(possibleEvents) do
    local event = replicatedStorage:FindFirstChild(eventName)
    if event then
        tradeEvent = event
        print("[FREEZE] Trade event ditemukan:", eventName)
        break
    end
end

if not tradeEvent then
    warn("[FREEZE] Trade event tidak ditemukan!")
    return
end

-- ===========================================
-- HOOK FUNGSI UNTUK FREEZE
-- ===========================================

-- Simpan fungsi asli
local oldFireServer = tradeEvent.FireServer
local oldInvokeServer = tradeEvent.InvokeServer

-- Variabel untuk menyimpan status freeze
local freezeActive = false
local frozenItem = config.itemPalsu

-- Fungsi untuk mengaktifkan freeze
function aktifkanFreezeMode()
    freezeActive = true
    print("[FREEZE] Mode freeze AKTIF - Lawan akan melihat item:", config.itemPalsu)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FREEZE TRADE",
        Text = "Mode freeze aktif! Lawan melihat item A",
        Duration = 3
    })
end

-- Fungsi untuk menonaktifkan freeze
function nonaktifkanFreezeMode()
    freezeActive = false
    print("[FREEZE] Mode freeze NONAKTIF")
end

-- Hook FireServer (untuk event client ke server)
tradeEvent.FireServer = function(self, ...)
    local args = {...}
    
    -- Log untuk debugging
    if freezeActive then
        print("[FREEZE] Mencegat FireServer dengan args:", #args)
        
        -- Coba deteksi argumen yang berisi data trade
        for i, arg in pairs(args) do
            if type(arg) == "string" and (arg == "A" or arg == "B" or arg:match("Item")) then
                print("[FREEZE] Menemukan item:", arg, "di posisi", i)
                
                -- Ganti dengan item palsu sebelum dikirim
                if arg == config.itemAsli and freezeActive then
                    args[i] = config.itemPalsu
                    print("[FREEZE] ✅ MENGUBAH", config.itemAsli, "→", config.itemPalsu)
                end
            end
        end
    end
    
    return oldFireServer(self, unpack(args))
end

-- Hook InvokeServer (alternatif)
tradeEvent.InvokeServer = function(self, ...)
    local args = {...}
    
    if freezeActive then
        for i, arg in pairs(args) do
            if type(arg) == "string" and arg == config.itemAsli then
                args[i] = config.itemPalsu
            end
        end
    end
    
    return oldInvokeServer(self, unpack(args))
end

-- ===========================================
-- HOOK REMOTEFUNCTION TAMBAHAN
-- ===========================================

-- Cek juga RemoteFunction
local tradeFunction = replicatedStorage:FindFirstChild("TradeFunction")
if tradeFunction then
    local oldInvoke = tradeFunction.InvokeServer
    
    tradeFunction.InvokeServer = function(self, ...)
        local args = {...}
        
        if freezeActive then
            for i, arg in pairs(args) do
                if type(arg) == "string" and arg == config.itemAsli then
                    args[i] = config.itemPalsu
                end
            end
        end
        
        return oldInvoke(self, unpack(args))
    end
    
    print("[FREEZE] RemoteFunction juga di-hook")
end

-- ===========================================
-- MANIPULASI TAMPILAN LOCAL (CLIENT-SIDE)
-- ===========================================

-- Buat GUI sederhana untuk kontrol
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local toggleBtn = Instance.new("TextButton")
local statusLabel = Instance.new("TextLabel")

screenGui.Parent = player:WaitForChild("PlayerGui")
frame.Parent = screenGui
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0, 10, 0.5, -50)
frame.Size = UDim2.new(0, 150, 0, 100)
frame.Active = true
frame.Draggable = true

statusLabel.Parent = frame
statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Text = "FREEZE: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)

toggleBtn.Parent = frame
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 255)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)
toggleBtn.Size = UDim2.new(0, 130, 0, 30)
toggleBtn.Text = "Aktifkan Freeze"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = frame
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Position = UDim2.new(0, 10, 0, 75)
closeBtn.Size = UDim2.new(0, 130, 0, 20)
closeBtn.Text = "Tutup"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14

-- Fungsi toggle
toggleBtn.MouseButton1Click:Connect(function()
    if freezeActive then
        nonaktifkanFreezeMode()
        toggleBtn.Text = "Aktifkan Freeze"
        statusLabel.Text = "FREEZE: OFF"
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        aktifkanFreezeMode()
        toggleBtn.Text = "Nonaktifkan Freeze"
        statusLabel.Text = "FREEZE: ON"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    nonaktifkanFreezeMode()
end)

-- ===========================================
-- DETEKSI SAAT TRADE DIMULAI
-- ===========================================

-- Coba deteksi GUI trade
local function cariTradeGUI()
    for _, gui in pairs(player.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and (gui.Name:lower():match("trade") or gui.Name:lower():match("dagang")) then
            print("[FREEZE] Trade GUI ditemukan:", gui.Name)
            
            -- Cari elemen yang menampilkan item
            local function scanForItemDisplays(obj)
                if obj:IsA("TextLabel") or obj:IsA("ImageLabel") then
                    if obj.Text == config.itemAsli or obj.Text == "A" or obj.Text == "B" then
                        print("[FREEZE] Menemukan display item:", obj.Text)
                        
                        -- Buat hook untuk update tampilan
                        local oldText = obj.Text
                        local oldName = obj.Name
                        
                        obj:GetPropertyChangedSignal("Text"):Connect(function()
                            if freezeActive and obj.Text == config.itemAsli then
                                obj.Text = config.itemPalsu
                                print("[FREEZE] Mengubah tampilan lokal dari", config.itemAsli, "ke", config.itemPalsu)
                            end
                        end)
                    end
                end
                
                for _, child in pairs(obj:GetChildren()) do
                    scanForItemDisplays(child)
                end
            end
            
            scanForItemDisplays(gui)
        end
    end
end

-- Pantau PlayerGui untuk GUI baru
player.PlayerGui.ChildAdded:Connect(function(child)
    if child:IsA("ScreenGui") then
        wait(0.5) -- Tunggu GUI selesai loading
        cariTradeGUI()
    end
end)

-- Jalankan sekali untuk GUI yang sudah ada
cariTradeGUI()

-- ===========================================
-- NOTIFIKASI AWAL
-- ===========================================

print([[
╔═══════════════════════════════════════╗
║   FREEZE TRADE SCRIPT - STEAL A BRAINROT   ║
╠═══════════════════════════════════════╣
║ [⚠️] RISIKO SANGAT TINGGI             ║
║ [⚠️] Gunakan akun alternatif!          ║
║ [ℹ️] Cara pakai:                       ║
║   1. Buka GUI yang muncul             ║
║   2. Klik "Aktifkan Freeze"           ║
║   3. Saat trade, item A akan terlihat ║
║   4. Pasang item B yang asli          ║
╚═══════════════════════════════════════╝
]])

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FREEZE TRADE SCRIPT",
    Text = "Script loaded! GUI muncul di pojok kiri",
    Duration = 5
})