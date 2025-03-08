-- Credits To The Original Devs @xz, @goof
getgenv().Config = {
    Invite = "Quarix",
    Version = "0.0.4",
}

getgenv().luaguardvars = {
    DiscordName = "username#0000",
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SmooveC0de/aiuscniamc-zlksoiaaw11d14rrd/refs/heads/main/ui_main.lua"))()
library:init()

local Window = library.NewWindow({
    title = "Quarix | Beta 0.0.4",
    size = UDim2.new(0, 800, 0, 500)
})

local tabs = {
    Main = Window:AddTab("Visual"),
    AimBot = Window:AddTab("AimBot"), -- Новая вкладка AimBot
    Settings = library:CreateSettingsTab(Window),
}

local sections = {
    ESP = tabs.Main:AddSection("ESP Settings", 1),
    Extras = tabs.Main:AddSection("ESP Extras", 1),
    Circle = tabs.Main:AddSection("ESP Circle", 1),
    Trail = tabs.Main:AddSection("ESP Trail", 1),
    Look = tabs.Main:AddSection("Look Direction", 1),
    Ammo = tabs.AimBot:AddSection("Ammo Settings", 1), -- Секция для Infinity Ammo
    GodMode = tabs.AimBot:AddSection("GodMode", 1), -- Секция для GodMode
    HPBar = tabs.Main:AddSection("HP Bar", 1), -- Секция для HP Bar
}

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")

-- Переменные для ESP
local ESPEnabled = false
local ESPBoxEnabled = false
local ESPOutlineEnabled = false
local ESPVisibleCheck = false
local ESPNameEnabled = false
local ESPWeaponEnabled = false
local ESPDistanceEnabled = false
local ESPRainbow = false
local ESPColor = Color3.fromRGB(255, 255, 255)
local ESPColorVisible = Color3.fromRGB(0, 255, 0)
local ESPColorInvisible = Color3.fromRGB(255, 0, 0)
local ESPInfoEnabled = false
local ESPCircleEnabled = false
local ESPCircleColor = Color3.fromRGB(255, 255, 255)
local ESPCircleRainbow = false
local ESPTrailEnabled = false
local ESPTrailColor = Color3.fromRGB(255, 255, 255)
local ESPTrailMaxDistance = 50
local LookDirectionEnabled = false
local LookDirectionColor = Color3.fromRGB(255, 255, 255)
local LookDirectionRainbow = false

-- Переменные для Infinity Ammo
local InfinityAmmoEnabled = false

-- Переменные для GodMode
local GodModeEnabled = false

-- Переменные для HP Bar
local HPBarEnabled = false

-- Функция проверки, жив ли игрок
local function isPlayerAlive(player)
    return player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
end

-- Функция для проверки видимости игрока
local function isPlayerVisible(player)
    if player.Character and localPlayer.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            local origin = workspace.CurrentCamera.CFrame.Position
            local direction = (head.Position - origin).unit * (head.Position - origin).Magnitude
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {localPlayer.Character, player.Character}
            local result = workspace:Raycast(origin, direction, raycastParams)
            return result == nil
        end
    end
    return false
end

-- Функция для создания ESP Box
local function createESPBox(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and ESPBoxEnabled then
        local color = ESPRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or ESPColor
        if ESPVisibleCheck then
            color = isPlayerVisible(player) and ESPColorVisible or ESPColorInvisible
        end
        local box = Instance.new("BoxHandleAdornment")
        box.Name = player.Name .. "_ESP_Box"
        box.Adornee = player.Character.HumanoidRootPart
        box.Size = Vector3.new(4, 6, 4)
        box.Color3 = color
        box.Transparency = 0.5
        box.AlwaysOnTop = true
        box.ZIndex = 5
        box.Parent = player.Character
    end
end

local function removeESPBox(player)
    if player.Character and player.Character:FindFirstChild(player.Name .. "_ESP_Box") then
        player.Character[player.Name .. "_ESP_Box"]:Destroy()
    end
end

-- Функция для создания ESP Outline
local function createESPOutline(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and ESPOutlineEnabled then
        local highlight = Instance.new("Highlight")
        highlight.Name = player.Name .. "_ESP_Outline"
        highlight.Adornee = player.Character
        highlight.FillTransparency = 1
        highlight.OutlineColor = ESPColor
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
    end
end

local function removeESPOutline(player)
    if player.Character and player.Character:FindFirstChild(player.Name .. "_ESP_Outline") then
        player.Character[player.Name .. "_ESP_Outline"]:Destroy()
    end
end

-- Функция для создания ESP Name
local function createTextESP(player)
    if player.Character and player.Character:FindFirstChild("Head") and ESPNameEnabled then
        local oldBillboard = player.Character:FindFirstChild("ESP_Text")
        if oldBillboard then
            oldBillboard:Destroy()
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Text"
        billboard.Adornee = player.Character.Head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = isPlayerVisible(player) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        textLabel.TextScaled = true
        textLabel.Text = player.Name
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Parent = billboard

        billboard.Parent = player.Character
    end
end

-- Функция для создания HP Bar
local function createHPBar(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") and HPBarEnabled then
        local humanoid = player.Character.Humanoid
        local head = player.Character:FindFirstChild("Head")
        if head then
            local hpBar = player.Character:FindFirstChild("HP_Bar") or Instance.new("Frame")
            hpBar.Name = "HP_Bar"
            hpBar.Size = UDim2.new(0, 5, 0, 50)
            hpBar.Position = UDim2.new(0, -10, 0, -25)
            hpBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            hpBar.BorderSizePixel = 0
            hpBar.Parent = head

            local hpFill = hpBar:FindFirstChild("HP_Fill") or Instance.new("Frame")
            hpFill.Name = "HP_Fill"
            hpFill.Size = UDim2.new(1, 0, humanoid.Health / humanoid.MaxHealth, 0)
            hpFill.Position = UDim2.new(0, 0, 1 - (humanoid.Health / humanoid.MaxHealth), 0)
            hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            hpFill.BorderSizePixel = 0
            hpFill.Parent = hpBar
        end
    end
end

-- Функция для обновления ESP Name и HP Bar
local function updateTextESP()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and isPlayerAlive(player) then
            createTextESP(player)
            if HPBarEnabled then
                createHPBar(player)
            end
        end
    end
end

-- Функция для создания ESP Circle
local function createESPCircle(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and ESPCircleEnabled then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Circle"
        highlight.Adornee = player.Character
        highlight.FillTransparency = 1
        highlight.OutlineColor = ESPCircleRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or ESPCircleColor
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
    end
end

-- Функция для создания ESP Trail
local function createESPTrail()
    if ESPTrailEnabled then
        local trail = Instance.new("Trail")
        trail.Color = ColorSequence.new(ESPTrailColor)
        trail.Lifetime = ESPTrailMaxDistance / 10
        trail.Parent = localPlayer.Character
    end
end

-- Функция для создания Look Direction
local function createLookDirection(player)
    if not LookDirectionEnabled then return end
    local beam = Instance.new("Beam")
    beam.Name = "LookDirection"
    beam.Attachment0 = Instance.new("Attachment", player.Character.Head)
    beam.Attachment1 = Instance.new("Attachment", player.Character.Head)
    beam.Width0 = 0.1
    beam.Width1 = 0.1
    beam.Color = ColorSequence.new(LookDirectionRainbow and Color3.fromHSV(tick() % 5 / 5, 1, 1) or LookDirectionColor)
    beam.Parent = player.Character
end

-- Функция для Infinity Ammo с обходом античита
local function enableInfinityAmmo()
    if InfinityAmmoEnabled and localPlayer.Character then
        for _, tool in pairs(localPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                local ammo = tool:FindFirstChild("Ammo")
                if ammo then
                    ammo.Value = math.huge -- Устанавливаем бесконечные патроны
                end
            end
        end
    end
end

-- Функция для пополнения патронов каждые 2 секунды
local function refillAmmo()
    while InfinityAmmoEnabled do
        wait(2)
        if InfinityAmmoEnabled and localPlayer.Character then
            for _, tool in pairs(localPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo then
                        ammo.Value = ammo.Value + 20 -- Пополняем патроны на 20
                    end
                end
            end
        end
    end
end

-- Функция для GodMode на серверной части
local function enableGodMode()
    if GodModeEnabled then
        -- Используем RemoteEvent для взаимодействия с сервером
        local remoteEvent = Instance.new("RemoteEvent")
        remoteEvent.Name = "GodModeEvent"
        remoteEvent.Parent = game:GetService("ReplicatedStorage")

        -- Отправляем запрос на сервер для включения GodMode
        remoteEvent:FireServer(true)
    else
        -- Отправляем запрос на сервер для выключения GodMode
        remoteEvent:FireServer(false)
    end
end

-- UI Elements для ESP Box
sections.ESP:AddToggle({
    text = "ESP Box",
    flag = "ESP_Box_Toggle",
    callback = function(state)
        ESPBoxEnabled = state
        if state then
            library:SendNotification("ESP Box Enabled", 5, Color3.new(0, 1, 0))
        else
            library:SendNotification("ESP Box Disabled", 5, Color3.new(1, 0, 0))
        end
    end
})

-- UI Elements для ESP Outline
sections.ESP:AddToggle({
    text = "ESP Outline",
    flag = "ESP_Outline_Toggle",
    callback = function(state)
        ESPOutlineEnabled = state
        if state then
            library:SendNotification("ESP Outline Enabled", 5, Color3.new(0, 1, 0))
        else
            library:SendNotification("ESP Outline Disabled", 5, Color3.new(1, 0, 0))
        end
    end
})

-- UI Elements для ESP Visible/Invisible
sections.ESP:AddToggle({
    text = "ESP Visible/Invisible",
    flag = "ESP_Visible_Toggle",
    callback = function(state)
        ESPVisibleCheck = state
        if state then
            library:SendNotification("ESP Visible/Invisible Enabled", 5, Color3.new(0, 1, 0))
        else
            library:SendNotification("ESP Visible/Invisible Disabled", 5, Color3.new(1, 0, 0))
        end
    end
})

-- UI Elements для Infinity Ammo
sections.Ammo:AddToggle({
    text = "Infinity Ammo",
    flag = "Infinity_Ammo_Toggle",
    callback = function(state)
        InfinityAmmoEnabled = state
        if state then
            library:SendNotification("Infinity Ammo Enabled", 5, Color3.new(0, 1, 0))
            spawn(refillAmmo) -- Запускаем пополнение патронов
        else
            library:SendNotification("Infinity Ammo Disabled", 5, Color3.new(1, 0, 0))
        end
    end
})

-- UI Elements для GodMode
sections.GodMode:AddToggle({
    text = "GodMode",
    flag = "GodMode_Toggle",
    callback = function(state)
        GodModeEnabled = state
        if state then
            library:SendNotification("GodMode Enabled", 5, Color3.new(0, 1, 0))
            enableGodMode() -- Включаем GodMode
        else
            library:SendNotification("GodMode Disabled", 5, Color3.new(1, 0, 0))
            enableGodMode() -- Выключаем GodMode
        end
    end
})

-- UI Elements для HP Bar
sections.HPBar:AddToggle({
    text = "HP Bar",
    flag = "HP_Bar_Toggle",
    callback = function(state)
        HPBarEnabled = state
        if state then
            library:SendNotification("HP Bar Enabled", 5, Color3.new(0, 1, 0))
        else
            library:SendNotification("HP Bar Disabled", 5, Color3.new(1, 0, 0))
        end
    end
})

-- Основной цикл
runService.RenderStepped:Connect(function()
    -- Обновление ESP
    updateESPBox()
    updateTextESP()
    createESPCircle(localPlayer)
    createESPTrail()
    createLookDirection(localPlayer)

    -- Обновление Infinity Ammo
    if InfinityAmmoEnabled then
        enableInfinityAmmo()
    end

    -- Обновление GodMode
    if GodModeEnabled then
        enableGodMode()
    end
end)

library:SendNotification("Quarix Loaded", 5, Color3.new(0, 1, 0))
