-- Nazuro UI Library for Executors
local Nazuro = {}
Nazuro.__index = Nazuro

-- Default configuration
local config = {
    Name = "Nazuro UI",
    Theme = "Dark",
    Size = UDim2.new(0, 500, 0, 600),
    Position = UDim2.new(0.5, -250, 0.5, -300),
    AnchorPoint = Vector2.new(0.5, 0.5),
    Tabs = {}
}

-- Color scheme
local colors = {
    Dark = {
        BgPrimary = Color3.fromRGB(30, 20, 50),
        BgSecondary = Color3.fromRGB(40, 30, 70),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(120, 80, 200),
        AccentHover = Color3.fromRGB(140, 100, 220),
        Border = Color3.fromRGB(90, 70, 150),
        Shadow = Color3.fromRGB(0, 0, 0)
    }
}

-- Transparency values
local transparency = {
    BgPrimary = 0.05,
    BgSecondary = 0.1,
    TextPrimary = 0.05,
    TextSecondary = 0.3,
    Accent = 0.1,
    AccentHover = 0.05,
    Border = 0.4,
    Shadow = 0.7
}

-- UI settings
local settings = {
    Radius = 12,
    RadiusSmall = 8,
    BlurIntensity = 10,
    Glassmorphism = true
}

-- Create a new instance
function Nazuro:CreateWindow(options)
    for i,v in pairs(options) do
        config[i] = v
    end
    
    local self = setmetatable({}, Nazuro)
    self.windows = {}
    self.tabs = {}
    
    -- Create main UI container
    self.screen = Instance.new("ScreenGui")
    self.screen.Name = "NazuroUI_"..tostring(math.random(1, 10000))
    self.screen.ResetOnSpawn = false
    self.screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- Main window frame
    self.main = Instance.new("Frame")
    self.main.Name = "Main"
    self.main.Size = config.Size
    self.main.Position = config.Position
    self.main.AnchorPoint = config.AnchorPoint
    self.main.BackgroundColor3 = colors[config.Theme].BgPrimary
    self.main.BackgroundTransparency = transparency.BgPrimary
    self.main.Parent = self.screen
    
    -- Glassmorphism effect
    if settings.Glassmorphism then
        local blur = Instance.new("BlurEffect")
        blur.Size = settings.BlurIntensity
        blur.Name = "NazuroBlur"
        blur.Parent = self.main
    end
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, settings.Radius)
    corner.Parent = self.main
    
    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = colors[config.Theme].Shadow
    shadow.ImageTransparency = transparency.Shadow
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.ZIndex = -1
    shadow.Parent = self.main
    
    -- Title bar (draggable area)
    self.titleBar = Instance.new("Frame")
    self.titleBar.Name = "TitleBar"
    self.titleBar.BackgroundColor3 = colors[config.Theme].BgSecondary
    self.titleBar.BackgroundTransparency = transparency.BgSecondary
    self.titleBar.Size = UDim2.new(1, 0, 0, 36)
    self.titleBar.Position = UDim2.new(0, 0, 0, 0)
    self.titleBar.Parent = self.main
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, settings.Radius)
    titleCorner.Parent = self.titleBar
    
    self.titleText = Instance.new("TextLabel")
    self.titleText.Name = "Title"
    self.titleText.Text = config.Name
    self.titleText.Font = Enum.Font.GothamSemibold
    self.titleText.TextColor3 = colors[config.Theme].TextPrimary
    self.titleText.TextTransparency = transparency.TextPrimary
    self.titleText.TextSize = 16
    self.titleText.BackgroundTransparency = 1
    self.titleText.Size = UDim2.new(1, -20, 1, 0)
    self.titleText.Position = UDim2.new(0, 10, 0, 0)
    self.titleText.TextXAlignment = Enum.TextXAlignment.Left
    self.titleText.Parent = self.titleBar
    
    -- Close button
    self.closeBtn = Instance.new("TextButton")
    self.closeBtn.Name = "CloseButton"
    self.closeBtn.Text = "×"
    self.closeBtn.Font = Enum.Font.GothamBold
    self.closeBtn.TextSize = 20
    self.closeBtn.TextColor3 = colors[config.Theme].TextPrimary
    self.closeBtn.BackgroundTransparency = 1
    self.closeBtn.Size = UDim2.new(0, 30, 0, 30)
    self.closeBtn.Position = UDim2.new(1, -30, 0.5, -15)
    self.closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    self.closeBtn.Parent = self.titleBar
    
    self.closeBtn.MouseButton1Click:Connect(function()
        self.screen:Destroy()
    end)
    
    -- Tab bar
    self.tabBar = Instance.new("Frame")
    self.tabBar.Name = "TabBar"
    self.tabBar.BackgroundColor3 = colors[config.Theme].BgSecondary
    self.tabBar.BackgroundTransparency = transparency.BgSecondary + 0.1
    self.tabBar.Size = UDim2.new(1, 0, 0, 40)
    self.tabBar.Position = UDim2.new(0, 0, 0, 36)
    self.tabBar.Parent = self.main
    
    self.tabList = Instance.new("Frame")
    self.tabList.Name = "TabList"
    self.tabList.BackgroundTransparency = 1
    self.tabList.Size = UDim2.new(1, -40, 1, 0)
    self.tabList.Position = UDim2.new(0, 10, 0, 0)
    self.tabList.Parent = self.tabBar
    
    self.tabListLayout = Instance.new("UIListLayout")
    self.tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    self.tabListLayout.Padding = UDim.new(0, 5)
    self.tabListLayout.Parent = self.tabList
    
    -- Content area
    self.content = Instance.new("Frame")
    self.content.Name = "Content"
    self.content.BackgroundTransparency = 1
    self.content.Size = UDim2.new(1, -20, 1, -76)
    self.content.Position = UDim2.new(0, 10, 0, 76)
    self.content.Parent = self.main
    
    self.tabContent = Instance.new("Frame")
    self.tabContent.Name = "TabContent"
    self.tabContent.BackgroundTransparency = 1
    self.tabContent.Size = UDim2.new(1, 0, 1, 0)
    self.tabContent.Parent = self.content
    
    -- Dragging functionality
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    self.titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.main.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Show the UI
    self.screen.Parent = game:GetService("CoreGui")
    
    return setmetatable({
        screen = self.screen,
        main = self.main,
        tabs = self.tabs,
        currentTab = nil
    }, Nazuro)
end

-- Create a tab
function Nazuro:CreateTab(options)
    local tab = {
        Name = options.Name,
        Icon = options.Icon or "rbxassetid://10734922324",
        Sections = {}
    }
    
    -- Create tab button
    local tabButton = Instance.new("TextButton")
    tabButton.Name = options.Name
    tabButton.Text = ""
    tabButton.BackgroundColor3 = colors[config.Theme].BgSecondary
    tabButton.BackgroundTransparency = transparency.BgSecondary
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.Parent = self.tabList
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, settings.RadiusSmall)
    tabCorner.Parent = tabButton
    
    local tabIcon = Instance.new("ImageLabel")
    tabIcon.Name = "Icon"
    tabIcon.Image = tab.Icon
    tabIcon.ImageColor3 = colors[config.Theme].TextPrimary
    tabIcon.ImageTransparency = transparency.TextPrimary
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
    tabIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Parent = tabButton
    
    local tabTitle = Instance.new("TextLabel")
    tabTitle.Name = "Title"
    tabTitle.Text = tab.Name
    tabTitle.Font = Enum.Font.Gotham
    tabTitle.TextColor3 = colors[config.Theme].TextPrimary
    tabTitle.TextTransparency = transparency.TextPrimary
    tabTitle.TextSize = 12
    tabTitle.BackgroundTransparency = 1
    tabTitle.Size = UDim2.new(1, 0, 0, 20)
    tabTitle.Position = UDim2.new(0, 0, 1, -20)
    tabTitle.TextXAlignment = Enum.TextXAlignment.Center
    tabTitle.Parent = tabButton
    
    -- Create tab content
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = tab.Name
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.ScrollBarThickness = 5
    tabContent.ScrollBarImageColor3 = colors[config.Theme].Accent
    tabContent.Visible = false
    tabContent.Parent = self.tabContent
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = tabContent
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    contentPadding.Parent = tabContent
    
    -- Tab selection logic
    tabButton.MouseButton1Click:Connect(function()
        if self.currentTab then
            self.currentTab.content.Visible = false
        end
        self.currentTab = tab
        tabContent.Visible = true
    end)
    
    -- Store tab reference
    tab.content = tabContent
    table.insert(self.tabs, tab)
    
    -- If this is the first tab, make it active
    if #self.tabs == 1 then
        self.currentTab = tab
        tabContent.Visible = true
    end
    
    -- Return tab with section creation functions
    return {
        Name = tab.Name,
        Content = tabContent,
        CreateSection = function(name, foldable)
            local section = {
                Name = name,
                Foldable = foldable or false,
                Elements = {}
            }
            
            -- Section frame
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Name = name
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.Size = UDim2.new(1, -20, 0, 0)
            sectionFrame.Position = UDim2.new(0, 10, 0, 0)
            sectionFrame.Parent = tabContent
            
            -- Section title
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Text = name
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextColor3 = colors[config.Theme].TextPrimary
            sectionTitle.TextTransparency = transparency.TextPrimary
            sectionTitle.TextSize = 14
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Size = UDim2.new(1, 0, 0, 30)
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            sectionTitle.Parent = sectionFrame
            
            -- Section content
            local sectionContent = Instance.new("Frame")
            sectionContent.Name = "Content"
            sectionContent.BackgroundTransparency = 1
            sectionContent.Size = UDim2.new(1, 0, 0, 0)
            sectionContent.Position = UDim2.new(0, 0, 0, 30)
            sectionContent.Parent = sectionFrame
            
            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 10)
            sectionLayout.Parent = sectionContent
            
            -- Function to update section size
            local function UpdateSize()
                local contentSize = sectionLayout.AbsoluteContentSize
                sectionContent.Size = UDim2.new(1, 0, 0, contentSize.Y)
                sectionFrame.Size = UDim2.new(1, -20, 0, 30 + contentSize.Y)
            end
            
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
            
            -- Foldable functionality
            if foldable then
                local isExpanded = true
                local expandIcon = Instance.new("ImageLabel")
                expandIcon.Name = "ExpandIcon"
                expandIcon.Image = "rbxassetid://3926305904"
                expandIcon.ImageRectOffset = Vector2.new(964, 324)
                expandIcon.ImageRectSize = Vector2.new(36, 36)
                expandIcon.Size = UDim2.new(0, 20, 0, 20)
                expandIcon.Position = UDim2.new(1, -25, 0.5, -10)
                expandIcon.AnchorPoint = Vector2.new(1, 0.5)
                expandIcon.BackgroundTransparency = 1
                expandIcon.Parent = sectionTitle
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Name = "ToggleButton"
                toggleBtn.Text = ""
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.Size = UDim2.new(1, 0, 1, 0)
                toggleBtn.Parent = sectionTitle
                
                toggleBtn.MouseButton1Click:Connect(function()
                    isExpanded = not isExpanded
                    sectionContent.Visible = isExpanded
                    expandIcon.ImageRectOffset = isExpanded and Vector2.new(964, 324) or Vector2.new(924, 724)
                    
                    if isExpanded then
                        UpdateSize()
                    else
                        sectionFrame.Size = UDim2.new(1, -20, 0, 30)
                    end
                end)
            end
            
            -- Store section reference
            section.frame = sectionFrame
            section.content = sectionContent
            table.insert(section.Elements, section)
            
            -- Return section with element creation functions
            return {
                Name = name,
                Frame = sectionFrame,
                Content = sectionContent,
                CreateButton = function(btnOptions)
                    local button = Instance.new("TextButton")
                    button.Name = btnOptions.Name
                    button.Text = btnOptions.Name
                    button.Font = Enum.Font.Gotham
                    button.TextColor3 = colors[config.Theme].TextPrimary
                    button.TextTransparency = transparency.TextPrimary
                    button.TextSize = 14
                    button.BackgroundColor3 = colors[config.Theme].Accent
                    button.BackgroundTransparency = transparency.Accent
                    button.AutoButtonColor = false
                    button.Size = UDim2.new(1, 0, 0, 36)
                    button.Parent = sectionContent
                    
                    local buttonCorner = Instance.new("UICorner")
                    buttonCorner.CornerRadius = UDim.new(0, settings.RadiusSmall)
                    buttonCorner.Parent = button
                    
                    local buttonStroke = Instance.new("UIStroke")
                    buttonStroke.Color = colors[config.Theme].Border
                    buttonStroke.Transparency = transparency.Border
                    buttonStroke.Thickness = 1
                    buttonStroke.Parent = button
                    
                    -- Hover effects
                    button.MouseEnter:Connect(function()
                        button.BackgroundColor3 = colors[config.Theme].AccentHover
                        button.BackgroundTransparency = transparency.AccentHover
                    end)
                    
                    button.MouseLeave:Connect(function()
                        button.BackgroundColor3 = colors[config.Theme].Accent
                        button.BackgroundTransparency = transparency.Accent
                    end)
                    
                    -- Click handler
                    if btnOptions.Callback then
                        button.MouseButton1Click:Connect(btnOptions.Callback)
                    end
                    
                    UpdateSize()
                    
                    return {
                        SetText = function(text)
                            button.Text = text
                        end,
                        SetCallback = function(callback)
                            btnOptions.Callback = callback
                        end
                    }
                end
            }
        end
    }
end

return Nazuro
