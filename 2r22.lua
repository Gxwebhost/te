
-- Nazuro UI Library - Roblox Implementation
-- Modern Glassmorphism UI Components for Roblox
-- Created by: Nazuro Team
-- Version: 2.0.0

local NazuroUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Constants
local NAZURO_THEME = {
    BackgroundPrimary = Color3.fromRGB(30, 20, 50),
    BackgroundSecondary = Color3.fromRGB(40, 30, 70),
    BackgroundTertiary = Color3.fromRGB(50, 40, 80),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Accent = Color3.fromRGB(120, 80, 200),
    AccentHover = Color3.fromRGB(140, 100, 220),
    Border = Color3.fromRGB(90, 70, 150),
    Success = Color3.fromRGB(34, 197, 94),
    Warning = Color3.fromRGB(251, 191, 36),
    Error = Color3.fromRGB(239, 68, 68)
}

local ANIMATION_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local FAST_ANIMATION = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Utility Functions
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

local function createGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors or ColorSequence.new({
        ColorSequenceKeypoint.new(0, NAZURO_THEME.BackgroundPrimary),
        ColorSequenceKeypoint.new(1, NAZURO_THEME.BackgroundSecondary)
    })
    gradient.Rotation = rotation or 135
    gradient.Parent = parent
    return gradient
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or NAZURO_THEME.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0.4
    stroke.Parent = parent
    return stroke
end

local function animateHover(element, hoverProps, normalProps)
    element.MouseEnter:Connect(function()
        local tween = TweenService:Create(element, FAST_ANIMATION, hoverProps)
        tween:Play()
    end)
    
    element.MouseLeave:Connect(function()
        local tween = TweenService:Create(element, FAST_ANIMATION, normalProps)
        tween:Play()
    end)
end

-- Window Class
local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    config = config or {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NazuroUI"
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local window = Instance.new("Frame")
    window.Name = "Window"
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, 0, 0.5, 0)
    window.AnchorPoint = Vector2.new(0.5, 0.5)
    window.BackgroundColor3 = NAZURO_THEME.BackgroundPrimary
    window.BackgroundTransparency = 0.05
    window.BorderSizePixel = 0
    window.Parent = screenGui
    
    createCorner(window, 12)
    createStroke(window)
    createGradient(window)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundColor3 = NAZURO_THEME.BackgroundSecondary
    titleBar.BackgroundTransparency = 0.1
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window
    
    createCorner(titleBar, 12)
    createGradient(titleBar, ColorSequence.new({
        ColorSequenceKeypoint.new(0, NAZURO_THEME.BackgroundSecondary),
        ColorSequenceKeypoint.new(1, NAZURO_THEME.BackgroundTertiary)
    }))
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.Name or "Nazuro UI"
    titleLabel.TextColor3 = NAZURO_THEME.TextPrimary
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0.5, 0)
    closeButton.AnchorPoint = Vector2.new(0, 0.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(220, 38, 127)
    closeButton.BackgroundTransparency = 0.3
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = NAZURO_THEME.TextPrimary
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    createCorner(closeButton, 8)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    animateHover(closeButton, 
        {BackgroundTransparency = 0.1}, 
        {BackgroundTransparency = 0.3}
    )
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 1, -50)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = window
    
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.Size = UDim2.new(0, 120, 1, 0)
    tabButtons.BackgroundColor3 = NAZURO_THEME.BackgroundSecondary
    tabButtons.BackgroundTransparency = 0.1
    tabButtons.BorderSizePixel = 0
    tabButtons.Parent = tabContainer
    
    createStroke(tabButtons)
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.Padding = UDim.new(0, 4)
    buttonLayout.Parent = tabButtons
    
    local buttonPadding = Instance.new("UIPadding")
    buttonPadding.PaddingTop = UDim.new(0, 16)
    buttonPadding.Parent = tabButtons
    
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -120, 1, 0)
    contentArea.Position = UDim2.new(0, 120, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = tabContainer
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 20)
    contentPadding.PaddingRight = UDim.new(0, 20)
    contentPadding.PaddingTop = UDim.new(0, 20)
    contentPadding.PaddingBottom = UDim.new(0, 20)
    contentPadding.Parent = contentArea
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    self.Window = window
    self.ContentArea = contentArea
    self.TabButtons = tabButtons
    self.ScreenGui = screenGui
    self.Tabs = {}
    self.ActiveTab = nil
    
    return self
end

function Window:CreateTab(config)
    config = config or {}
    local tab = Tab.new(self, config)
    table.insert(self.Tabs, tab)
    
    -- Activate first tab by default
    if #self.Tabs == 1 then
        tab:Activate()
        self.ActiveTab = tab
    end
    
    return tab
end

-- Tab Class
local Tab = {}
Tab.__index = Tab

function Tab.new(window, config)
    local self = setmetatable({}, Tab)
    
    self.Window = window
    self.Name = config.Name or "Tab"
    self.Icon = config.Icon
    self.Sections = {}
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. self.Name
    tabButton.Size = UDim2.new(1, -8, 0, 40)
    tabButton.BackgroundColor3 = NAZURO_THEME.BackgroundTertiary
    tabButton.BackgroundTransparency = 1
    tabButton.BorderSizePixel = 0
    tabButton.Text = self.Name
    tabButton.TextColor3 = NAZURO_THEME.TextSecondary
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.Gotham
    tabButton.LayoutOrder = #window.Tabs + 1
    tabButton.Parent = window.TabButtons
    
    createCorner(tabButton, 8)
    
    -- Create tab content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = "TabContent_" .. self.Name
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 6
    tabContent.ScrollBarImageColor3 = NAZURO_THEME.Accent
    tabContent.CanvasSize = UDim2.new(0, 0, 2, 0)
    tabContent.Visible = false
    tabContent.Parent = window.ContentArea
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 16)
    contentLayout.Parent = tabContent
    
    self.Button = tabButton
    self.Content = tabContent
    
    tabButton.MouseButton1Click:Connect(function()
        self:Activate()
    end)
    
    animateHover(tabButton,
        {BackgroundTransparency = 0.3},
        {BackgroundTransparency = 1}
    )
    
    return self
end

function Tab:Activate()
    -- Deactivate all tabs
    for _, tab in pairs(self.Window.Tabs) do
        tab.Content.Visible = false
        tab.Button.BackgroundTransparency = 1
        tab.Button.TextColor3 = NAZURO_THEME.TextSecondary
    end
    
    -- Activate this tab
    self.Content.Visible = true
    self.Button.BackgroundTransparency = 0.2
    self.Button.BackgroundColor3 = NAZURO_THEME.Accent
    self.Button.TextColor3 = NAZURO_THEME.TextPrimary
    self.Window.ActiveTab = self
end

function Tab:CreateSection(config)
    config = config or {}
    local section = Section.new(self, config)
    table.insert(self.Sections, section)
    return section
end

-- Section Class
local Section = {}
Section.__index = Section

function Section.new(tab, config)
    local self = setmetatable({}, Section)
    
    self.Tab = tab
    self.Name = config.Name or "Section"
    self.Controls = {}
    
    local section = Instance.new("Frame")
    section.Name = "Section_" .. self.Name
    section.Size = UDim2.new(1, 0, 0, 200)
    section.BackgroundColor3 = NAZURO_THEME.BackgroundTertiary
    section.BackgroundTransparency = 0.2
    section.BorderSizePixel = 0
    section.LayoutOrder = #tab.Sections + 1
    section.Parent = tab.Content
    
    createCorner(section, 12)
    createStroke(section)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = self.Name
    title.TextColor3 = NAZURO_THEME.TextPrimary
    title.TextScaled = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = section
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -20, 1, -50)
    content.Position = UDim2.new(0, 10, 0, 40)
    content.BackgroundTransparency = 1
    content.Parent = section
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = content
    
    self.Frame = section
    self.Content = content
    
    return self
end

function Section:CreateToggle(config)
    config = config or {}
    
    local container = Instance.new("Frame")
    container.Name = "Toggle_" .. (config.Name or "Toggle")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.Controls + 1
    container.Parent = self.Content
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Toggle"
    label.TextColor3 = NAZURO_THEME.TextPrimary
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(0, 48, 0, 24)
    toggleFrame.Position = UDim2.new(1, -48, 0.5, 0)
    toggleFrame.AnchorPoint = Vector2.new(0, 0.5)
    toggleFrame.BackgroundColor3 = NAZURO_THEME.BackgroundSecondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = container
    
    createCorner(toggleFrame, 12)
    createStroke(toggleFrame)
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 18, 0, 18)
    toggleButton.Position = UDim2.new(0, 3, 0.5, 0)
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.BackgroundColor3 = NAZURO_THEME.TextPrimary
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame
    
    createCorner(toggleButton, 9)
    
    local isToggled = config.Default or false
    
    local function updateToggle()
        local targetPos = isToggled and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        local targetColor = isToggled and NAZURO_THEME.Accent or NAZURO_THEME.BackgroundSecondary
        
        local buttonTween = TweenService:Create(toggleButton, ANIMATION_INFO, {Position = targetPos})
        local frameTween = TweenService:Create(toggleFrame, ANIMATION_INFO, {BackgroundColor3 = targetColor})
        
        buttonTween:Play()
        frameTween:Play()
    end
    
    updateToggle()
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = container
    
    clickDetector.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        updateToggle()
        if config.Callback then
            config.Callback(isToggled)
        end
    end)
    
    table.insert(self.Controls, container)
    return container
end

function Section:CreateSlider(config)
    config = config or {}
    
    local container = Instance.new("Frame")
    container.Name = "Slider_" .. (config.Name or "Slider")
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.Controls + 1
    container.Parent = self.Content
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.Name or "Slider"
    label.TextColor3 = NAZURO_THEME.TextPrimary
    label.TextScaled = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(config.Default or config.Min or 0)
    valueLabel.TextColor3 = NAZURO_THEME.Accent
    valueLabel.TextScaled = true
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = container
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, 0, 0, 6)
    sliderFrame.Position = UDim2.new(0, 0, 1, -20)
    sliderFrame.BackgroundColor3 = NAZURO_THEME.BackgroundSecondary
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = container
    
    createCorner(sliderFrame, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.BackgroundColor3 = NAZURO_THEME.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderFrame
    
    createCorner(sliderFill, 3)
    createGradient(sliderFill, ColorSequence.new({
        ColorSequenceKeypoint.new(0, NAZURO_THEME.Accent),
        ColorSequenceKeypoint.new(1, NAZURO_THEME.AccentHover)
    }), 90)
    
    local sliderButton = Instance.new("Frame")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 18, 0, 18)
    sliderButton.Position = UDim2.new(0, 0, 0.5, 0)
    sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
    sliderButton.BackgroundColor3 = NAZURO_THEME.TextPrimary
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderFrame
    
    createCorner(sliderButton, 9)
    createStroke(sliderButton, NAZURO_THEME.Accent, 2)
    
    local minValue = config.Min or 0
    local maxValue = config.Max or 100
    local currentValue = config.Default or minValue
    local step = config.Step or 1
    
    local function updateSlider(value)
        value = math.max(minValue, math.min(maxValue, value))
        value = math.floor((value - minValue) / step + 0.5) * step + minValue
        currentValue = value
        
        local percentage = (value - minValue) / (maxValue - minValue)
        
        local fillTween = TweenService:Create(sliderFill, FAST_ANIMATION, {
            Size = UDim2.new(percentage, 0, 1, 0)
        })
        local buttonTween = TweenService:Create(sliderButton, FAST_ANIMATION, {
            Position = UDim2.new(percentage, 0, 0.5, 0)
        })
        
        fillTween:Play()
        buttonTween:Play()
        
        valueLabel.Text = tostring(value)
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    updateSlider(currentValue)
    
    local dragging = false
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local relativeX = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
            local newValue = minValue + relativeX * (maxValue - minValue)
            updateSlider(newValue)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = (input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X
            local newValue = minValue + relativeX * (maxValue - minValue)
            updateSlider(newValue)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    table.insert(self.Controls, container)
    return container
end

function Section:CreateDropdown(config)
    config = config or {}
    local options = config.Options or {}
    
    local container = Instance.new("Frame")
    container.Name = "Dropdown_" .. (config.Name or "Dropdown")
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #self.Controls + 1
    container.Parent = self.Content
    
    local dropdown = Instance.new("TextButton")
    dropdown.Name = "Dropdown"
    dropdown.Size = UDim2.new(1, 0, 1, 0)
    dropdown.BackgroundColor3 = NAZURO_THEME.BackgroundSecondary
    dropdown.BackgroundTransparency = 0.1
    dropdown.BorderSizePixel = 0
    dropdown.Text = config.Default or (options[1] and options[1] or "Select...")
    dropdown.TextColor3 = NAZURO_THEME.TextPrimary
    dropdown.TextScaled = true
    dropdown.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.Font = Enum.Font.Gotham
    dropdown.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 30)
    padding.Parent = dropdown
    
    createCorner(dropdown, 8)
    createStroke(dropdown)
    
    local arrow = Instance.new("TextLabel")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = NAZURO_THEME.TextSecondary
    arrow.TextScaled = true
    arrow.Font = Enum.Font.Gotham
    arrow.Parent = dropdown
    
    local optionsFrame = Instance.new("ScrollingFrame")
    optionsFrame.Name = "OptionsFrame"
    optionsFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 35, 200))
    optionsFrame.Position = UDim2.new(0, 0, 1, 5)
    optionsFrame.BackgroundColor3 = NAZURO_THEME.BackgroundSecondary
    optionsFrame.BackgroundTransparency = 0.05
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ScrollBarThickness = 4
    optionsFrame.ScrollBarImageColor3 = NAZURO_THEME.Accent
    optionsFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 35)
    optionsFrame.Visible = false
    optionsFrame.Parent = container
    
    createCorner(optionsFrame, 8)
    createStroke(optionsFrame)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = optionsFrame
    
    local currentValue = config.Default or (options[1] and options[1] or "")
    local isOpen = false
    
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option" .. i
        optionButton.Size = UDim2.new(1, 0, 0, 35)
        optionButton.BackgroundColor3 = NAZURO_THEME.BackgroundTertiary
        optionButton.BackgroundTransparency = 1
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = NAZURO_THEME.TextPrimary
        optionButton.TextScaled = true
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Font = Enum.Font.Gotham
        optionButton.Parent = optionsFrame
        
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 12)
        optionPadding.Parent = optionButton
        
        animateHover(optionButton,
            {BackgroundTransparency = 0.7},
            {BackgroundTransparency = 1}
        )
        
        optionButton.MouseButton1Click:Connect(function()
            currentValue = option
            dropdown.Text = option
            isOpen = false
            optionsFrame.Visible = false
            arrow.Rotation = 0
            
            if config.Callback then
                config.Callback(option)
            end
        end)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        
        local arrowTween = TweenService:Create(arrow, FAST_ANIMATION, {
            Rotation = isOpen and 180 or 0
        })
        arrowTween:Play()
    end)
    
    animateHover(dropdown,
        {BackgroundTransparency =  0.05},
        {BackgroundTransparency = 0.1}
    )
    
    table.insert(self.Controls, container)
    return container
end

function Section:CreateButton(config)
    config = config or {}
    
    local button = Instance.new("TextButton")
    button.Name = "Button_" .. (config.Name or "Button")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = NAZURO_THEME.Accent
    button.BackgroundTransparency = 0.1
    button.BorderSizePixel = 0
    button.Text = config.Name or "Button"
    button.TextColor3 = NAZURO_THEME.TextPrimary
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.LayoutOrder = #self.Controls + 1
    button.Parent = self.Content
    
    createCorner(button, 8)
    createGradient(button, ColorSequence.new({
        ColorSequenceKeypoint.new(0, NAZURO_THEME.Accent),
        ColorSequenceKeypoint.new(1, NAZURO_THEME.AccentHover)
    }))
    
    animateHover(button,
        {BackgroundTransparency = 0, Size = button.Size + UDim2.new(0, 2, 0, 1)},
        {BackgroundTransparency = 0.1, Size = UDim2.new(1, 0, 0, 35)}
    )
    
    if config.Callback then
        button.MouseButton1Click:Connect(config.Callback)
    end
    
    table.insert(self.Controls, button)
    return button
end

-- Main NazuroUI functions
function NazuroUI:CreateWindow(config)
    return Window.new(config)
end

return NazuroUI
