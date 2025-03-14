-- Credits To The Original Devs @xz, @goof
getgenv().Config = {
    Invite = "Quarix",
    Version = "0.0.3",
}

getgenv().luaguardvars = {
    DiscordName = "username#0000",
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SmooveC0de/aiuscniamc-zlksoiaaw11d14rrd/refs/heads/main/ui_main.lua"))()
library:init()

local Window = library.NewWindow({
    title = "Quarix | Beta 0.0.3",
    size = UDim2.new(0, 800, 0, 500)
})

local tabs = {
    Main = Window:AddTab("Visual"),
    Settings = library:CreateSettingsTab(Window),
}

local sections = {
    ESP = tabs.Main:AddSection("ESP Settings", 1),
    Extras = tabs.Main:AddSection("ESP Extras", 1),
    Circle = tabs.Main:AddSection("ESP Circle", 1),
    Trail = tabs.Main:AddSection("ESP Trail", 1),
    Look = tabs.Main:AddSection("Look Direction", 1),
}

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")

local ESPEnabled = false
local ESPBoxEnabled = false
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

-- Функция проверки, жив ли игрок
local function isPlayerAlive(player)
    return player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
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

local function updateESPBox()
    if not ESPBoxEnabled then return end
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and isPlayerAlive(player) then
            removeESPBox(player)
            createESPBox(player)
        end
    end
end

-- ESP Name, Weapon, Distance
local function createTextESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_Text"
        billboard.Adornee = player.Character.HumanoidRootPart
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextScaled = true
        textLabel.Text = ""
        textLabel.Parent = billboard

        billboard.Parent = player.Character
    end
end

local function updateTextESP()
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer and isPlayerAlive(player) then
            local billboard = player.Character and player.Character:FindFirstChild("ESP_Text")
            if billboard then
                local textLabel = billboard:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    local text = ""
                    if ESPNameEnabled then
                        text = text .. player.Name .. "\n"
                    end
                    if ESPWeaponEnabled and player.Character:FindFirstChildOfClass("Tool") then
                        text = text .. "Weapon: " .. player.Character:FindFirstChildOfClass("Tool").Name .. "\n"
                    end
                    if ESPDistanceEnabled then
                        local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                        text = text .. "Distance: " .. math.floor(distance) .. "m\n"
                    end
                    textLabel.Text = text
                end
            end
        end
    end
end

-- ESP Circle
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

-- ESP Trail
local function createESPTrail(player)
    if not ESPTrailEnabled then return end
    local trail = Instance.new("Trail")
    trail.Color = ColorSequence.new(ESPTrailColor)
    trail.Lifetime = ESPTrailMaxDistance / 10
    trail.Parent = player.Character
end

-- Look Direction
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

-- UI Elements (с правильным синтаксисом для кнопок и цветовых пикеров)
sections.ESP:AddToggle({
    text = "Enable ESP Box",
    flag = "ESP_Box_Toggle",
    callback = function(state)
        ESPBoxEnabled = state
        updateESPBox()
    end
})

sections.ESP:AddColor({
    text = "ESP Color",
    flag = "ESP_Color",
    color = ESPColor,
    callback = function(color)
        ESPColor = color
        updateESPBox()
    end
})

sections.ESP:AddToggle({
    text = "ESP Rainbow",
    flag = "ESP_Rainbow",
    callback = function(state)
        ESPRainbow = state
        updateESPBox()
    end
})

sections.Extras:AddToggle({
    text = "ESP Name",
    flag = "ESP_Name_Toggle",
    callback = function(state)
        ESPNameEnabled = state
        updateTextESP()
    end
})

sections.Extras:AddToggle({
    text = "ESP Weapon",
    flag = "ESP_Weapon_Toggle",
    callback = function(state)
        ESPWeaponEnabled = state
        updateTextESP()
    end
})

sections.Extras:AddToggle({
    text = "ESP Distance",
    flag = "ESP_Distance_Toggle",
    callback = function(state)
        ESPDistanceEnabled = state
        updateTextESP()
    end
})

sections.Extras:AddToggle({
    text = "ESP Info",
    flag = "ESP_Info_Toggle",
    callback = function(state)
        ESPInfoEnabled = state
        updateTextESP()
    end
})

sections.Circle:AddToggle({
    text = "ESP Circle",
    flag = "ESP_Circle_Toggle",
    callback = function(state)
        ESPCircleEnabled = state
        updateESPBox()
    end
})

sections.Circle:AddColor({
    text = "Circle Color",
    flag = "ESP_Circle_Color",
    color = ESPCircleColor,
    callback = function(color)
        ESPCircleColor = color
        updateESPBox()
    end
})

sections.Circle:AddToggle({
    text = "Circle Rainbow",
    flag = "ESP_Circle_Rainbow",
    callback = function(state)
        ESPCircleRainbow = state
        updateESPBox()
    end
})

sections.Trail:AddToggle({
    text = "ESP Trail",
    flag = "ESP_Trail_Toggle",
    callback = function(state)
        ESPTrailEnabled = state
        updateESPBox()
    end
})

sections.Trail:AddColor({
    text = "Trail Color",
    flag = "ESP_Trail_Color",
    color = ESPTrailColor,
    callback = function(color)
        ESPTrailColor = color
        updateESPBox()
    end
})

sections.Trail:AddSlider({
    text = "Trail Distance",
    flag = "ESP_Trail_Distance",
    min = 10,
    max = 100,
    callback = function(value)
        ESPTrailMaxDistance = value
        updateESPBox()
    end
})

sections.Look:AddToggle({
    text = "Look Direction",
    flag = "ESP_Look_Direction_Toggle",
    callback = function(state)
        LookDirectionEnabled = state
        updateESPBox()
    end
})

sections.Look:AddColor({
    text = "Look Direction Color",
    flag = "ESP_Look_Direction_Color",
    color = LookDirectionColor,
    callback = function(color)
        LookDirectionColor = color
        updateESPBox()
    end
})

sections.Look:AddToggle({
    text = "Look Direction Rainbow",
    flag = "ESP_Look_Direction_Rainbow",
    callback = function(state)
        LookDirectionRainbow = state
        updateESPBox()
    end
})

runService.RenderStepped:Connect(function()
    updateESPBox()
    updateTextESP()
end)

library:SendNotification("Quarix Loaded", 5, Color3.new(0, 1, 0))
