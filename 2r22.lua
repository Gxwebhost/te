local NazuroUI = {}

local uis = game:GetService("UserInputService")

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NazuroExecutorUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protect for exploit GUI (e.g. Synapse X)
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
end

ScreenGui.Parent = game.CoreGui

-- Main frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 620, 0, 420)
Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 6)

-- Title bar
local TitleBar = Instance.new("TextLabel", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(38, 26, 66)
TitleBar.Text = "   Nazuro UI Library - Executor Edition"
TitleBar.TextColor3 = Color3.fromRGB(220, 220, 255)
TitleBar.Font = Enum.Font.GothamSemibold
TitleBar.TextSize = 16
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 6)

-- Divider under title
local Line = Instance.new("Frame", Main)
Line.Size = UDim2.new(1, -12, 0, 1)
Line.Position = UDim2.new(0, 6, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
Instance.new("UICorner", Line).CornerRadius = UDim.new(0, 0.5)


return NazuroUI
