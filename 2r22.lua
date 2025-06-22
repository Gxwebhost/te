-- Nazuro UI Library (Executor Edition)
local NazuroUI = {}

local uis = game:GetService("UserInputService")

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")local NazuroUI = {}

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

-- Divider under title
local Line = Instance.new("Frame", Main)
Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(60, 60, 100)

-- Body container
local BodyFrame = Instance.new("Frame", Main)
BodyFrame.Size = UDim2.new(1, 0, 1, -41)
BodyFrame.Position = UDim2.new(0, 0, 0, 41)
BodyFrame.BackgroundTransparency = 1

-- Sidebar
local Sidebar = Instance.new("Frame", BodyFrame)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 15, 40)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 10)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Draggable UI (via title bar)
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
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

TitleBar.InputChanged:Connect(function(input)
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

-- Tab + Page system
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
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("Frame", BodyFrame)
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

-- UI Elements
function NazuroUI:CreateToggle(parent, labelText, callback)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1, -20, 0, 30)
    holder.Position = UDim2.new(0, 10, 0, 0)
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

function NazuroUI:CreateSlider(parent, labelText, minValue, maxValue, defaultValue, callback)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1, -20, 0, 30)
    holder.Position = UDim2.new(0, 10, 0, 0)
    holder.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", holder)
    label.Text = labelText
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local valueLabel = Instance.new("TextLabel", holder)
    valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.Text = tostring(defaultValue)

    local slider = Instance.new("TextButton", holder)
    slider.Size = UDim2.new(1, -20, 0, 5)
    slider.Position = UDim2.new(0, 10, 0, 20)
    slider.BackgroundColor3 = Color3.fromRGB(64, 48, 120)
    slider.Text = ""
    Instance.new("UICorner", slider).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame", slider)
    knob.Size = UDim2.new(0, 10, 1, 0)
    knob.BackgroundColor3 = Color3.fromRGB(140, 90, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local value = defaultValue

    slider.MouseButton1Down:Connect(function(input)
        local mouse = uis:GetMouseLocation()
        local x = math.clamp(mouse.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
        value = minValue + (maxValue - minValue) * (x / slider.AbsoluteSize.X)
        value = math.floor(value)
        knob.Position = UDim2.new(0, x - 5, 0, 0)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end)

    return value
end

function NazuroUI:CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(90, 70, 160)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

-- NEW: Section Creator (Box Panel)
function NazuroUI:CreateSection(parent, title)
    local section = Instance.new("Frame", parent)
    section.Size = UDim2.new(1, -20, 0, 160)
    section.Position = UDim2.new(0, 10, 0, 10)
    section.BackgroundColor3 = Color3.fromRGB(38, 26, 66)
    section.BorderSizePixel = 0
    Instance.new("UICorner", section).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", section)
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Text = title
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    return section
end

-- Initialize UI
local performancePage = NazuroUI:CreateTab("Performance")
local optimizationSection = NazuroUI:CreateSection(performancePage, "Optimization")
NazuroUI:CreateToggle(optimizationSection, "Hardware Acceleration", function(state) print("Hardware Acceleration: " .. tostring(state)) end)
NazuroUI:CreateToggle(optimizationSection, "Reduce Animations", function(state) print("Reduce Animations: " .. tostring(state)) end)

local memorySection = NazuroUI:CreateSection(performancePage, "Memory")
NazuroUI:CreateSlider(memorySection, "Cache Size (MB)", 0, 500, 150, function(value) print("Cache Size: " .. value) end)
NazuroUI:CreateButton(memorySection, "Clear Cache", function() print("Cache Cleared") end)

local fpsSection = NazuroUI:CreateSection(performancePage, "FPS Limit")
NazuroUI:CreateSlider(fpsSection, "FPS Limit", 30, 120, 60, function(value) print("FPS Limit: " .. value) end)

return NazuroUI
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
TitleBar.Text = "   Nazuro UI Library - Modern Web Edition"
TitleBar.TextColor3 = Color3.fromRGB(220, 220, 255)
TitleBar.Font = Enum.Font.GothamSemibold
TitleBar.TextSize = 16
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.BorderSizePixel = 0

-- Divider under title
local Line = Instance.new("Frame", Main)
Line.Size = UDim2.new(1, 0, 0, 1)
Line.Position = UDim2.new(0, 0, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(60, 60, 100)

-- Body container
local BodyFrame = Instance.new("Frame", Main)
BodyFrame.Size = UDim2.new(1, 0, 1, -41)
BodyFrame.Position = UDim2.new(0, 0, 0, 41)
BodyFrame.BackgroundTransparency = 1

-- Sidebar
local Sidebar = Instance.new("Frame", BodyFrame)
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 15, 40)

local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 10)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Draggable UI (via title bar)
local dragging, dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
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

TitleBar.InputChanged:Connect(function(input)
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

-- Tab + Page system
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
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

	local page = Instance.new("Frame", BodyFrame)
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

-- UI Elements
function NazuroUI:CreateToggle(parent, labelText, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1, -20, 0, 30)
	holder.Position = UDim2.new(0, 10, 0, 0)
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
	btn.Position = UDim2.new(0, 10, 0, 0)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(90, 70, 160)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
end

-- NEW: Section Creator (Box Panel)
function NazuroUI:CreateSection(parent, title)
	local section = Instance.new("Frame", parent)
	section.Size = UDim2.new(1, -20, 0, 160)
	section.Position = UDim2.new(0, 10, 0, 10)
	section.BackgroundColor3 = Color3.fromRGB(38, 26, 66)
	section.BorderSizePixel = 0
	Instance.new("UICorner", section).CornerRadius = UDim.new(0, 6)

	local label = Instance.new("TextLabel", section)
	label.Size = UDim2.new(1, -20, 0, 25)
	label.Position = UDim2.new(0, 10, 0, 5)
	label.Text = title
	label.TextColor3 = Color3.fromRGB(220, 220, 255)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 14
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left

	return section
end

return NazuroUI
