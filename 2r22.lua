
--!native
--!optimize 2

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local NazuroUI = {}

-- Modern color scheme with proper contrast
NazuroUI.Theme = {
    Background = Color3.fromRGB(15, 15, 20),
    Surface = Color3.fromRGB(25, 25, 35),
    SurfaceElevated = Color3.fromRGB(35, 35, 45),
    Primary = Color3.fromRGB(120, 120, 255),
    PrimaryHover = Color3.fromRGB(140, 140, 255),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(255, 180, 60),
    Error = Color3.fromRGB(255, 100, 100),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 170),
    TextMuted = Color3.fromRGB(120, 120, 130),
    Border = Color3.fromRGB(45, 45, 55),
    BorderHover = Color3.fromRGB(60, 60, 70),
    
    -- Animation settings
    FastTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    MediumTween = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SlowTween = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Utility functions
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or NazuroUI.Theme.Border
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
    shadow.Position = UDim2.new(0, -size, 0, -size)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = transparency or 0.7
    shadow.ZIndex = parent.ZIndex - 1
    CreateCorner(shadow, 12)
    shadow.Parent = parent
    return shadow
end

function NazuroUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Nazuro UI"
    local subtitle = config.Subtitle or "Modern Interface"
    local size = config.Size or {600, 400}
    
    -- Main ScreenGui
    local NazuroScreen = Instance.new("ScreenGui")
    NazuroScreen.Name = "NazuroUI_" .. tostring(tick())
    NazuroScreen.ResetOnSpawn = false
    NazuroScreen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    NazuroScreen.Parent = game:GetService("CoreGui")
    
    -- Main Window Frame - Properly centered
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, size[1], 0, size[2])
    MainWindow.Position = UDim2.new(0.5, -size[1]/2, 0.5, -size[2]/2) -- Perfect centering
    MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
    MainWindow.BackgroundColor3 = NazuroUI.Theme.Background
    MainWindow.BorderSizePixel = 0
    MainWindow.ClipsDescendants = true
    MainWindow.Parent = NazuroScreen
    
    CreateCorner(MainWindow, 12)
    CreateStroke(MainWindow, 1, NazuroUI.Theme.Border, 0.3)
    CreateShadow(MainWindow, 20, 0.8)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = NazuroUI.Theme.Surface
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainWindow
    
    CreateCorner(TitleBar, 12)
    
    -- Title bar bottom border
    local TitleBorder = Instance.new("Frame")
    TitleBorder.Name = "TitleBorder"
    TitleBorder.Size = UDim2.new(1, 0, 0, 1)
    TitleBorder.Position = UDim2.new(0, 0, 1, -1)
    TitleBorder.BackgroundColor3 = NazuroUI.Theme.Border
    TitleBorder.BorderSizePixel = 0
    TitleBorder.Parent = TitleBar
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -20, 0, 25)
    TitleText.Position = UDim2.new(0, 15, 0, 5)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.TextColor3 = NazuroUI.Theme.Text
    TitleText.TextSize = 16
    TitleText.Font = Enum.Font.GothamSemibold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Subtitle Text
    local SubtitleText = Instance.new("TextLabel")
    SubtitleText.Name = "SubtitleText"
    SubtitleText.Size = UDim2.new(1, -20, 0, 15)
    SubtitleText.Position = UDim2.new(0, 15, 0, 28)
    SubtitleText.BackgroundTransparency = 1
    SubtitleText.Text = subtitle
    SubtitleText.TextColor3 = NazuroUI.Theme.TextSecondary
    SubtitleText.TextSize = 12
    SubtitleText.Font = Enum.Font.Gotham
    SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleText.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -40, 0, 10)
    CloseButton.BackgroundColor3 = NazuroUI.Theme.Error
    CloseButton.BackgroundTransparency = 0.8
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamSemibold
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = TitleBar
    
    CreateCorner(CloseButton, 6)
    
    -- Close button hover effect
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, NazuroUI.Theme.FastTween, {
            BackgroundTransparency = 0.2
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, NazuroUI.Theme.FastTween, {
            BackgroundTransparency = 0.8
        }):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(MainWindow, NazuroUI.Theme.MediumTween, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        
        wait(0.25)
        NazuroScreen:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainWindow
    
    -- Tab Navigation (Left Side)
    local TabNavigation = Instance.new("Frame")
    TabNavigation.Name = "TabNavigation"
    TabNavigation.Size = UDim2.new(0, 180, 1, 0)
    TabNavigation.Position = UDim2.new(0, 0, 0, 0)
    TabNavigation.BackgroundColor3 = NazuroUI.Theme.Surface
    TabNavigation.BorderSizePixel = 0
    TabNavigation.Parent = TabContainer
    
    CreateCorner(TabNavigation, 0)
    
    -- Tab navigation border
    local NavBorder = Instance.new("Frame")
    NavBorder.Name = "NavBorder"
    NavBorder.Size = UDim2.new(0, 1, 1, 0)
    NavBorder.Position = UDim2.new(1, -1, 0, 0)
    NavBorder.BackgroundColor3 = NazuroUI.Theme.Border
    NavBorder.BorderSizePixel = 0
    NavBorder.Parent = TabNavigation
    
    -- Tab Content Area
    local TabContent = Instance.new("Frame")
    TabContent.Name = "TabContent"
    TabContent.Size = UDim2.new(1, -180, 1, 0)
    TabContent.Position = UDim2.new(0, 180, 0, 0)
    TabContent.BackgroundColor3 = NazuroUI.Theme.Background
    TabContent.BorderSizePixel = 0
    TabContent.Parent = TabContainer
    
    -- Tab Navigation Layout
    local NavLayout = Instance.new("UIListLayout")
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Padding = UDim.new(0, 2)
    NavLayout.Parent = TabNavigation
    
    local NavPadding = Instance.new("UIPadding")
    NavPadding.PaddingTop = UDim.new(0, 10)
    NavPadding.PaddingBottom = UDim.new(0, 10)
    NavPadding.PaddingLeft = UDim.new(0, 10)
    NavPadding.PaddingRight = UDim.new(0, 10)
    NavPadding.Parent = TabNavigation
    
    -- Drag functionality with smooth movement
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainWindow.Position
            
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
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            MainWindow.Position = newPos
        end
    end)
    
    -- Window opening animation
    MainWindow.Size = UDim2.new(0, 0, 0, 0)
    MainWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainWindow, NazuroUI.Theme.SlowTween, {
        Size = UDim2.new(0, size[1], 0, size[2]),
        Position = UDim2.new(0.5, -size[1]/2, 0.5, -size[2]/2)
    }):Play()
    
    local Window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:CreateTab(config)
        config = config or {}
        local name = config.Name or "Tab"
        local icon = config.Icon or "📄"
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = NazuroUI.Theme.SurfaceElevated
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabNavigation
        
        CreateCorner(TabButton, 6)
        
        -- Tab Icon
        local TabIcon = Instance.new("TextLabel")
        TabIcon.Name = "Icon"
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Text = icon
        TabIcon.TextColor3 = NazuroUI.Theme.TextSecondary
        TabIcon.TextSize = 16
        TabIcon.Font = Enum.Font.Gotham
        TabIcon.TextXAlignment = Enum.TextXAlignment.Center
        TabIcon.TextYAlignment = Enum.TextYAlignment.Center
        TabIcon.Parent = TabButton
        
        -- Tab Label
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Position = UDim2.new(0, 35, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = NazuroUI.Theme.TextSecondary
        TabLabel.TextSize = 13
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.TextYAlignment = Enum.TextYAlignment.Center
        TabLabel.Parent = TabButton
        
        -- Tab Content Frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = name .. "_Content"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Position = UDim2.new(0, 0, 0, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 4
        TabFrame.ScrollBarImageColor3 = NazuroUI.Theme.Primary
        TabFrame.ScrollBarImageTransparency = 0.5
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.Visible = false
        TabFrame.Parent = TabContent
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabFrame
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 15)
        ContentPadding.PaddingBottom = UDim.new(0, 15)
        ContentPadding.PaddingLeft = UDim.new(0, 15)
        ContentPadding.PaddingRight = UDim.new(0, 15)
        ContentPadding.Parent = TabFrame
        
        -- Tab hover effects
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= TabFrame then
                TweenService:Create(TabButton, NazuroUI.Theme.FastTween, {
                    BackgroundTransparency = 0.9
                }):Play()
                TweenService:Create(TabIcon, NazuroUI.Theme.FastTween, {
                    TextColor3 = NazuroUI.Theme.Text
                }):Play()
                TweenService:Create(TabLabel, NazuroUI.Theme.FastTween, {
                    TextColor3 = NazuroUI.Theme.Text
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= TabFrame then
                TweenService:Create(TabButton, NazuroUI.Theme.FastTween, {
                    BackgroundTransparency = 1
                }):Play()
                TweenService:Create(TabIcon, NazuroUI.Theme.FastTween, {
                    TextColor3 = NazuroUI.Theme.TextSecondary
                }):Play()
                TweenService:Create(TabLabel, NazuroUI.Theme.FastTween, {
                    TextColor3 = NazuroUI.Theme.TextSecondary
                }):Play()
            end
        end)
        
        -- Tab selection
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Frame.Visible = false
                TweenService:Create(tab.Button, NazuroUI.Theme.FastTween, {
                    BackgroundTransparency = 1
                }):Play()
                TweenService:Create(tab.Icon, NazuroUI.Theme.FastTween, {
                    TextColor3 = NazuroUI.Theme.TextSecondary
                }):Play()
                TweenService:Create(tab.Label, NazuroUI.Theme.FastTween, {
                    TextColor3 = NazuroUI.Theme.TextSecondary
                }):Play()
            end
            
            -- Show selected tab
            TabFrame.Visible = true
            Window.CurrentTab = TabFrame
            
            TweenService:Create(TabButton, NazuroUI.Theme.FastTween, {
                BackgroundTransparency = 0.7
            }):Play()
            TweenService:Create(TabIcon, NazuroUI.Theme.FastTween, {
                TextColor3 = NazuroUI.Theme.Primary
            }):Play()
            TweenService:Create(TabLabel, NazuroUI.Theme.FastTween, {
                TextColor3 = NazuroUI.Theme.Text
            }):Play()
        end)
        
        -- Update canvas size when content changes
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 30)
        end)
        
        local Tab = {
            Frame = TabFrame,
            Button = TabButton,
            Icon = TabIcon,
            Label = TabLabel,
            Layout = ContentLayout
        }
        
        Window.Tabs[name] = Tab
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Wait()
        end
        
        function Tab:CreateSection(title)
            local Section = Instance.new("Frame")
            Section.Name = title
            Section.Size = UDim2.new(1, 0, 0, 0)
            Section.BackgroundTransparency = 1
            Section.Parent = TabFrame
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, 0, 0, 25)
            SectionTitle.Position = UDim2.new(0, 0, 0, 0)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = title
            SectionTitle.TextColor3 = NazuroUI.Theme.Text
            SectionTitle.TextSize = 14
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.TextYAlignment = Enum.TextYAlignment.Center
            SectionTitle.Parent = Section
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.Position = UDim2.new(0, 0, 0, 30)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = Section
            
            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 5)
            SectionLayout.Parent = SectionContent
            
            local function UpdateSize()
                SectionContent.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y)
                Section.Size = UDim2.new(1, 0, 0, SectionLayout.AbsoluteContentSize.Y + 40)
                TabFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 30)
            end
            
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
            
            local SectionAPI = {}
            
            function SectionAPI:CreateButton(config)
                config = config or {}
                local name = config.Name or "Button"
                local callback = config.Callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Name = name
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.BackgroundColor3 = NazuroUI.Theme.Primary
                Button.Text = name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 13
                Button.Font = Enum.Font.Gotham
                Button.AutoButtonColor = false
                Button.Parent = SectionContent
                
                CreateCorner(Button, 6)
                
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, NazuroUI.Theme.FastTween, {
                        BackgroundColor3 = NazuroUI.Theme.PrimaryHover
                    }):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, NazuroUI.Theme.FastTween, {
                        BackgroundColor3 = NazuroUI.Theme.Primary
                    }):Play()
                end)
                
                Button.MouseButton1Click:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {
                        Size = UDim2.new(1, -4, 0, 33)
                    }):Play()
                    
                    wait(0.1)
                    
                    TweenService:Create(Button, TweenInfo.new(0.1), {
                        Size = UDim2.new(1, 0, 0, 35)
                    }):Play()
                    
                    callback()
                end)
                
                UpdateSize()
                return Button
            end
            
            function SectionAPI:CreateToggle(config)
                config = config or {}
                local name = config.Name or "Toggle"
                local default = config.Default or false
                local callback = config.Callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                ToggleFrame.BackgroundColor3 = NazuroUI.Theme.SurfaceElevated
                ToggleFrame.Parent = SectionContent
                
                CreateCorner(ToggleFrame, 6)
                CreateStroke(ToggleFrame, 1, NazuroUI.Theme.Border, 0.5)
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = name
                ToggleLabel.TextColor3 = NazuroUI.Theme.Text
                ToggleLabel.TextSize = 13
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.TextYAlignment = Enum.TextYAlignment.Center
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Name = "Toggle"
                ToggleButton.Size = UDim2.new(0, 35, 0, 20)
                ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
                ToggleButton.BackgroundColor3 = default and NazuroUI.Theme.Primary or NazuroUI.Theme.Border
                ToggleButton.Text = ""
                ToggleButton.AutoButtonColor = false
                ToggleButton.Parent = ToggleFrame
                
                CreateCorner(ToggleButton, 10)
                
                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Name = "Indicator"
                ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
                ToggleIndicator.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleIndicator.Parent = ToggleButton
                
                CreateCorner(ToggleIndicator, 8)
                
                local toggled = default
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    TweenService:Create(ToggleButton, NazuroUI.Theme.MediumTween, {
                        BackgroundColor3 = toggled and NazuroUI.Theme.Primary or NazuroUI.Theme.Border
                    }):Play()
                    
                    TweenService:Create(ToggleIndicator, NazuroUI.Theme.MediumTween, {
                        Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }):Play()
                    
                    callback(toggled)
                end)
                
                UpdateSize()
                return ToggleFrame
            end
            
            UpdateSize()
            return SectionAPI
        end
        
        return Tab
    end
    
    return Window
end

return NazuroUI
