-- UI Library by [Your Name]
-- Version 1.0

local UILibrary = {}

-- Theme settings (customizable)
UILibrary.Theme = {
    PrimaryColor = Color3.fromRGB(0, 120, 215),
    SecondaryColor = Color3.fromRGB(40, 40, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.Gotham,
    CornerRadius = UDim.new(0, 8),
    DropShadow = true
}

-- Create a new screen GUI if one doesn't exist
function UILibrary:CreateScreenGui(name)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name or "UILibraryGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    return screenGui
end

-- Create a frame container
function UILibrary:CreateFrame(props)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = props.BackgroundColor3 or self.Theme.SecondaryColor
    frame.Size = props.Size or UDim2.new(0, 200, 0, 150)
    frame.Position = props.Position or UDim2.new(0.5, -100, 0.5, -75)
    frame.AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5)
    
    if self.Theme.CornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = self.Theme.CornerRadius
        corner.Parent = frame
    end
    
    if self.Theme.DropShadow then
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "DropShadow"
        shadow.Image = "rbxassetid://1316045217"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = 0.5
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.new(0, -10, 0, -10)
        shadow.BackgroundTransparency = 1
        shadow.Parent = frame
        shadow.ZIndex = -1
    end
    
    if props.Parent then
        frame.Parent = props.Parent
    end
    
    return frame
end

-- Create a button
function UILibrary:CreateButton(props)
    local button = Instance.new("TextButton")
    button.Name = props.Name or "Button"
    button.Size = props.Size or UDim2.new(0, 120, 0, 40)
    button.Position = props.Position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = props.BackgroundColor3 or self.Theme.PrimaryColor
    button.TextColor3 = props.TextColor3 or self.Theme.TextColor
    button.Text = props.Text or "Button"
    button.Font = props.Font or self.Theme.Font
    button.TextSize = props.TextSize or 14
    
    -- Add corner radius
    if self.Theme.CornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = self.Theme.CornerRadius
        corner.Parent = button
    end
    
    -- Button hover effects
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundTransparency = 0.2}
        ):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.2),
            {BackgroundTransparency = 0}
        ):Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.1),
            {BackgroundTransparency = 0.4}
        ):Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        game:GetService("TweenService"):Create(
            button,
            TweenInfo.new(0.1),
            {BackgroundTransparency = 0}
        ):Play()
    end)
    
    if props.OnClick then
        button.MouseButton1Click:Connect(props.OnClick)
    end
    
    if props.Parent then
        button.Parent = props.Parent
    end
    
    return button
end

-- Create a label
function UILibrary:CreateLabel(props)
    local label = Instance.new("TextLabel")
    label.Name = props.Name or "Label"
    label.Size = props.Size or UDim2.new(1, 0, 0, 20)
    label.Position = props.Position or UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = props.TextColor3 or self.Theme.TextColor
    label.Text = props.Text or "Label"
    label.Font = props.Font or self.Theme.Font
    label.TextSize = props.TextSize or 14
    label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    
    if props.Parent then
        label.Parent = props.Parent
    end
    
    return label
end

-- Create a toggle switch
function UILibrary:CreateToggle(props)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = props.Name or "Toggle"
    toggleFrame.Size = props.Size or UDim2.new(0, 50, 0, 25)
    toggleFrame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    toggleFrame.BackgroundTransparency = 1
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    toggleButton.AutoButtonColor = false
    toggleButton.Text = ""
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "ToggleCircle"
    toggleCircle.Size = UDim2.new(0.45, 0, 0.8, 0)
    toggleCircle.Position = UDim2.new(0.05, 0, 0.1, 0)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
    
    -- Add corner radius
    if self.Theme.CornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = toggleButton
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = toggleCircle
    end
    
    local state = props.Default or false
    
    local function updateToggle()
        if state then
            game:GetService("TweenService"):Create(
                toggleCircle,
                TweenInfo.new(0.2),
                {Position = UDim2.new(0.5, 0, 0.1, 0)}
            ):Play()
            toggleButton.BackgroundColor3 = self.Theme.PrimaryColor
        else
            game:GetService("TweenService"):Create(
                toggleCircle,
                TweenInfo.new(0.2),
                {Position = UDim2.new(0.05, 0, 0.1, 0)}
            ):Play()
            toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        if props.OnToggle then
            props.OnToggle(state)
        end
    end)
    
    toggleCircle.Parent = toggleButton
    toggleButton.Parent = toggleFrame
    
    if props.Parent then
        toggleFrame.Parent = props.Parent
    end
    
    -- Initialize state
    updateToggle()
    
    return {
        Frame = toggleFrame,
        SetState = function(newState)
            state = newState
            updateToggle()
        end,
        GetState = function()
            return state
        end
    }
end

-- Create a slider
function UILibrary:CreateSlider(props)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = props.Name or "Slider"
    sliderFrame.Size = props.Size or UDim2.new(0, 200, 0, 30)
    sliderFrame.Position = props.Position or UDim2.new(0, 0, 0, 0)
    sliderFrame.BackgroundTransparency = 1
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 5)
    track.Position = UDim2.new(0, 0, 0.5, 0)
    track.AnchorPoint = Vector2.new(0, 0.5)
    track.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = self.Theme.PrimaryColor
    
    local thumb = Instance.new("TextButton")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new(0.5, -10, 0.5, -10)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    thumb.Text = ""
    thumb.AutoButtonColor = false
    
    -- Add corner radius
    if self.Theme.CornerRadius then
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(1, 0)
        trackCorner.Parent = track
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local thumbCorner = Instance.new("UICorner")
        thumbCorner.CornerRadius = UDim.new(1, 0)
        thumbCorner.Parent = thumb
    end
    
    local min = props.Min or 0
    local max = props.Max or 100
    local value = props.Default or min
    
    local function updateSlider()
        local ratio = (value - min) / (max - min)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        thumb.Position = UDim2.new(ratio, -10, 0.5, -10)
        
        if props.OnChange then
            props.OnChange(value)
        end
    end
    
    local dragging = false
    
    thumb.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = game:GetService("Players").LocalPlayer:GetMouse().X
            local absolutePos = sliderFrame.AbsolutePosition.X
            local absoluteSize = sliderFrame.AbsoluteSize.X
            
            local relativePos = math.clamp(mousePos - absolutePos, 0, absoluteSize)
            local ratio = relativePos / absoluteSize
            value = math.floor(min + (max - min) * ratio)
            
            updateSlider()
        end
    end)
    
    fill.Parent = track
    track.Parent = sliderFrame
    thumb.Parent = sliderFrame
    
    if props.Parent then
        sliderFrame.Parent = props.Parent
    end
    
    -- Initialize
    updateSlider()
    
    return {
        Frame = sliderFrame,
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            updateSlider()
        end,
        GetValue = function()
            return value
        end
    }
end

return UILibrary
