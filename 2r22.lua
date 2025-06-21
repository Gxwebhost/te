-- Nazuro UI Library for Roblox Executor
-- Modern, clean UI components with custom color scheme

local NazuroUI = {}

-- Color and style definitions
local Colors = {
    PrimaryBg = Color3.fromRGB(30, 20, 50),
    SecondaryBg = Color3.fromRGB(40, 30, 70),
    PrimaryText = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(178, 178, 178),
    Accent = Color3.fromRGB(120, 80, 200),
    AccentHover = Color3.fromRGB(140, 100, 220),
    Border = Color3.fromRGB(90, 70, 150),
    Shadow = Color3.fromRGB(0, 0, 0)
}

local Styles = {
    BorderRadius = UDim.new(0, 12),
    BorderRadiusSmall = UDim.new(0, 8),
    TransitionTime = 0.3
}

-- Helper function to create a shadow effect
local function addShadow(element)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217" -- Roblox shadow asset
    shadow.ImageColor3 = Colors.Shadow
    shadow.ImageTransparency = 0.7
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.ZIndex = element.ZIndex - 1
    shadow.Parent = element
    return shadow
end

-- Create a new UI window
function NazuroUI:CreateWindow(title, size)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NazuroUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui

    local frame = Instance.new("Frame")
    frame.Name = "Window"
    frame.Size = size or UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Colors.PrimaryBg
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Styles.BorderRadius
    corner.Parent = frame

    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 1
    border.Transparency = 0.4
    border.Parent = frame

    addShadow(frame)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Nazuro UI"
    titleLabel.TextColor3 = Colors.PrimaryText
    titleLabel.TextTransparency = 0.05
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    local window = { Frame = frame, Elements = {} }

    -- Draggable window
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    return window
end

-- Create a button
function NazuroUI:CreateButton(window, text, callback, size, position)
    local button = Instance.new("TextButton")
    button.Size = size or UDim2.new(0, 150, 0, 40)
    button.Position = position or UDim2.new(0, 10, 0, 50)
    button.BackgroundColor3 = Colors.Accent
    button.BackgroundTransparency = 0.1
    button.BorderSizePixel = 0
    button.Text = text or "Button"
    button.TextColor3 = Colors.PrimaryText
    button.TextTransparency = 0.05
    button.Font = Enum.Font.SourceSans
    button.TextSize = 16
    button.Parent = window.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Styles.BorderRadiusSmall
    corner.Parent = button

    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 1
    border.Transparency = 0.4
    border.Parent = button

    addShadow(button)

    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(Styles.TransitionTime), {BackgroundColor3 = Colors.AccentHover}):Play()
    end)

    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(Styles.TransitionTime), {BackgroundColor3 = Colors.Accent}):Play()
    end)

    button.MouseButton1Click:Connect(callback or function() end)
    table.insert(window.Elements, button)
    return button
end

-- Create a text label
function NazuroUI:CreateLabel(window, text, size, position)
    local label = Instance.new("TextLabel")
    label.Size = size or UDim2.new(0, 150, 0, 30)
    label.Position = position or UDim2.new(0, 10, 0, 100)
    label.BackgroundColor3 = Colors.SecondaryBg
    label.BackgroundTransparency = 0.1
    label.BorderSizePixel = 0
    label.Text = text or "Label"
    label.TextColor3 = Colors.SecondaryText
    label.TextTransparency = 0.3
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.Parent = window.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Styles.BorderRadiusSmall
    corner.Parent = label

    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 1
    border.Transparency = 0.4
    border.Parent = label

    table.insert(window.Elements, label)
    return label
end

-- Create a text input
function NazuroUI:CreateTextInput(window, placeholder, size, position)
    local input = Instance.new("TextBox")
    input.Size = size or UDim2.new(0, 150, 0, 40)
    input.Position = position or UDim2.new(0, 10, 0, 140)
    input.BackgroundColor3 = Colors.SecondaryBg
    input.BackgroundTransparency = 0.1
    input.BorderSizePixel = 0
    input.PlaceholderText = placeholder or "Enter text..."
    input.Text = ""
    input.TextColor3 = Colors.PrimaryText
    input.TextTransparency = 0.05
    input.Font = Enum.Font.SourceSans
    input.TextSize = 14
    input.Parent = window.Frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = Styles.BorderRadiusSmall
    corner.Parent = input

    local border = Instance.new("UIStroke")
    border.Color = Colors.Border
    border.Thickness = 1
    border.Transparency = 0.4
    border.Parent = input

    addShadow(input)

    table.insert(window.Elements, input)
    return input
end


return NazuroUI
