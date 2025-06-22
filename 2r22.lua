-- Nazuro UI Library for Executors (modern look)
-- Supports: Toggles, Sliders, Buttons, Tabs, and more

local NazuroUI = {}

-- SERVICES
local uis = game:GetService("UserInputService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NazuroExecutorUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if syn then
    syn.protect_gui(ScreenGui)
end
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 620, 0, 400)
Main.Position = UDim2.new(0.5, -310, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
Main.BorderSizePixel = 0
Main.AnchorPoint = Vector2.new(0.5, 0.5)

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 6)

-- Dragging
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

uis.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 15, 40)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 10)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tab Buttons
local Tabs = {}
local Pages = {}

function NazuroUI:CreateTab(name)
	local button = Instance.new("TextButton", Sidebar)
	button.Size = UDim2.new(1, -10, 0, 40)
	button.Position = UDim2.new(0, 5, 0, 0)
	button.BackgroundColor3 = Color3.fromRGB(64, 48, 120)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Text = name
	button.Font = Enum.Font.Gotham
	button.TextSize = 14

	local corner = Instance.new("UICorner", button)
	corner.CornerRadius = UDim.new(0, 6)

	local page = Instance.new("Frame", Main)
	page.Size = UDim2.new(1, -120, 1, 0)
	page.Position = UDim2.new(0, 120, 0, 0)
	page.BackgroundTransparency = 1
	page.Visible = false

	Tabs[name] = button
	Pages[name] = page

	button.MouseButton1Click:Connect(function()
		for _, p in pairs(Pages) do p.Visible = false end
		for _, b in pairs(Tabs) do b.BackgroundColor3 = Color3.fromRGB(64, 48, 120) end
		page.Visible = true
		button.BackgroundColor3 = Color3.fromRGB(90, 70, 160)
	end)

	return page
end

function NazuroUI:CreateToggle(parent, labelText, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1, -20, 0, 30)
	holder.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", holder)
	label.Text = labelText
	label.Size = UDim2.new(0.8, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left

	local toggle = Instance.new("TextButton", holder)
	toggle.Size = UDim2.new(0, 40, 0, 20)
	toggle.Position = UDim2.new(1, -50, 0.5, -10)
	toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	toggle.Text = ""

	local knob = Instance.new("Frame", toggle)
	knob.Size = UDim2.new(0.5, -2, 1, -4)
	knob.Position = UDim2.new(0, 2, 0, 2)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

	local toggled = false
	toggle.MouseButton1Click:Connect(function()
		toggled = not toggled
		toggle.BackgroundColor3 = toggled and Color3.fromRGB(140, 90, 255) or Color3.fromRGB(100, 100, 100)
		knob:TweenPosition(toggled and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2), "Out", "Sine", 0.2, true)
		if callback then callback(toggled) end
	end)
end

function NazuroUI:CreateButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(90, 70, 160)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(callback)
end

return NazuroUI
