local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/WetCheezit/Bracket-V2/main/src.lua"))()

-- Window
local Window, MainGUI = Library:CreateWindow("Bracket-V2")

-- Tabs
local Tab1 = Window:CreateTab("Tab 1")
local Tab2 = Window:CreateTab("Tab 2")

local Groupbox1 = Tab1:CreateGroupbox("Groupbox 1", "Left")
local Groupbox2 = Tab1:CreateGroupbox("Groupbox 2", "Right")

local Groupbox3 = Tab2:CreateGroupbox("Groupbox 1", "Left")
local Groupbox4 = Tab2:CreateGroupbox("Groupbox 2", "Right")

-- Groupbox 1
local ExampleToggle = Groupbox1:CreateToggle("Example toggle", function(state)
   print(state)
end)

local ExampleToggle2 = Groupbox1:CreateToggle("Example keybind", function(state)
   print(state)
end)

local ExampleButton = Groupbox1:CreateButton("Example Button", function()
    print("Pressed")
end)

ExampleToggle2:CreateKeyBind()

local ExampleSlider = Groupbox1:CreateSlider("Example slider", 0, 25, 0, function(value)
   print(value)
end)

local ExampleDropdown = Groupbox1:CreateDropdown("Example Dropdown", {"Option 1", "Option 2", "Option 3"}, function(state)
   print(state)
end)

local ExampleColorPicker = Groupbox1:CreateColorPicker("Color", Color3.fromRGB(0, 0, 0), function(state)
   print(state.R, state.G, state.B)
end)

-- Groupbox 2
local ESPToggle = Groupbox2:CreateToggle("ESP", function(state)
    ESPEnabled = state
    if ESPEnabled then
        EnableESP()
    else
        DisableESP()
    end
end)

-- ESP Logic
local ESPEnabled = false
local ESPObjects = {}

function EnableESP()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.Adornee = character
                highlight.Name = "ESP_" .. player.Name
                table.insert(ESPObjects, highlight)
            end
        end
    end
end

function DisableESP()
    for _, highlight in pairs(ESPObjects) do
        highlight:Destroy()
    end
    ESPObjects = {}
end

-- Groupbox 3
local ExampleToggle4 = Groupbox3:CreateToggle("Example toggle", function(state)
   print(state)
end)

local ExampleToggle5 = Groupbox3:CreateToggle("Example keybind", function(state)
   print(state)
end)

local ExampleButton3 = Groupbox3:CreateButton("Example Button", function()
    print("Pressed")
end)

ExampleToggle5:CreateKeyBind()

local ExampleSlider3 = Groupbox3:CreateSlider("Example slider", 0, 25, 0, function(value)
   print(value)
end)

local ExampleDropdown3 = Groupbox3:CreateDropdown("Example Dropdown", {"Option 1", "Option 2", "Option 3"}, function(state)
   print(state)
end)

local ExampleColorPicker3 = Groupbox3:CreateColorPicker("Color", Color3.fromRGB(0, 0, 0), function(state)
   print(state.R, state.G, state.B)
end)

-- Groupbox 4
local ExampleToggle5 = Groupbox4:CreateToggle("Example toggle", function(state)
   print(state)
end)

local ExampleToggle6 = Groupbox4:CreateToggle("Example keybind", function(state)
   print(state)
end)

local ExampleButton4 = Groupbox4:CreateButton("Example Button", function()
    print("Pressed")
end)

ExampleToggle6:CreateKeyBind()

local ExampleSlider4 = Groupbox4:CreateSlider("Example slider", 0, 25, 0, function(value)
   print(value)
end)

local ExampleDropdown4 = Groupbox4:CreateDropdown("Example Dropdown", {"Option 1", "Option 2", "Option 3"}, function(state)
   print(state)
end)

local ExampleColorPicker4 = Groupbox4:CreateColorPicker("Color", Color3.fromRGB(0, 0, 0), function(state)
   print(state.R, state.G, state.B)
end)
