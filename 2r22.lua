--!native
--!optimize 2

local Nazuro = {
    Themes = {
        Dark = {
            Main = Color3.fromRGB(20, 20, 30),
            Secondary = Color3.fromRGB(30, 30, 45),
            Accent = Color3.fromRGB(100, 70, 200),
            Text = Color3.fromRGB(240, 240, 250),
            SubText = Color3.fromRGB(180, 180, 190),
            Error = Color3.fromRGB(220, 80, 80),
            Success = Color3.fromRGB(80, 220, 120),
            Warning = Color3.fromRGB(220, 180, 80),
            Info = Color3.fromRGB(80, 180, 220)
        },
        Light = {
            Main = Color3.fromRGB(240, 240, 245),
            Secondary = Color3.fromRGB(220, 220, 230),
            Accent = Color3.fromRGB(120, 90, 220),
            Text = Color3.fromRGB(30, 30, 40),
            SubText = Color3.fromRGB(80, 80, 90),
            Error = Color3.fromRGB(200, 60, 60),
            Success = Color3.fromRGB(60, 200, 100),
            Warning = Color3.fromRGB(200, 160, 60),
            Info = Color3.fromRGB(60, 160, 200)
        }
    },
    Settings = {
        CurrentTheme = "Dark",
        Transparency = 0.1,
        TweenSpeed = 0.25,
        EasingStyle = Enum.EasingStyle.Quint
    }
}

-- Core services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Utility functions
local function Create(class, props)
    local obj = Instance.new(class)
    for prop, val in pairs(props) do
        if prop ~= "Parent" then
            obj[prop] = val
        end
    end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, props, duration)
    local tweenInfo = TweenInfo.new(
        duration or Nazuro.Settings.TweenSpeed,
        Nazuro.Settings.EasingStyle
    )
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

local function RippleEffect(button)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = button,
        ZIndex = 10
    })
    
    local corner = Create("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = ripple
    })
    
    Tween(ripple, {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    }):Play()
    
    spawn(function()
        wait(0.5)
        ripple:Destroy()
    end)
end

-- Main UI Container
local MainUI = Create("ScreenGui", {
    Name = "NazuroUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Global
})

local MainFrame = Create("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 500, 0, 600),
    Position = UDim2.new(0.5, -250, 0.5, -300),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Main,
    BackgroundTransparency = Nazuro.Settings.Transparency,
    Parent = MainUI,
    ClipsDescendants = true
})

Create("UICorner", {
    CornerRadius = UDim.new(0, 12),
    Parent = MainFrame
})

Create("UIStroke", {
    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
    Thickness = 1,
    Transparency = 0.7,
    Parent = MainFrame
})

-- Title Bar
local TitleBar = Create("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

local Title = Create("TextLabel", {
    Name = "Title",
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "Nazuro UI",
    TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    Parent = TitleBar
})

local CloseButton = Create("TextButton", {
    Name = "CloseButton",
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0.5, -15),
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundTransparency = 1,
    TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    Parent = TitleBar
})

CloseButton.MouseButton1Click:Connect(function()
    MainUI:Destroy()
end)

-- Sidebar
local Sidebar = Create("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 180, 1, -40),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Secondary,
    BackgroundTransparency = Nazuro.Settings.Transparency + 0.1,
    Parent = MainFrame
})

Create("UIStroke", {
    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
    Thickness = 1,
    Transparency = 0.7,
    Parent = Sidebar
})

local TabList = Create("ScrollingFrame", {
    Name = "TabList",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
    Parent = Sidebar
})

Create("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 5),
    Parent = TabList
})

Create("UIPadding", {
    PaddingTop = UDim.new(0, 10),
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    Parent = TabList
})

-- Content Area
local ContentArea = Create("Frame", {
    Name = "ContentArea",
    Size = UDim2.new(1, -180, 1, -40),
    Position = UDim2.new(0, 180, 0, 40),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

local TabContent = Create("Frame", {
    Name = "TabContent",
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Parent = ContentArea
})

Create("UIPadding", {
    PaddingTop = UDim.new(0, 15),
    PaddingLeft = UDim.new(0, 15),
    PaddingRight = UDim.new(0, 15),
    PaddingBottom = UDim.new(0, 15),
    Parent = TabContent
})

-- Drag functionality
local dragging
local dragInput
local dragStart
local startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X,
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
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
        UpdateInput(input)
    end
end)

-- Library functions
function Nazuro:CreateWindow(options)
    local window = {
        Tabs = {},
        CurrentTab = nil
    }
    
    MainUI.Parent = CoreGui
    Title.Text = options.Name or "Nazuro UI"
    
    if options.Theme then
        Nazuro.Settings.CurrentTheme = options.Theme
    end
    
    function window:CreateTab(options)
        local tab = {
            Name = options.Name,
            Icon = options.Icon or "rbxassetid://10734922324",
            Sections = {}
        }
        
        local tabButton = Create("TextButton", {
            Name = options.Name,
            Size = UDim2.new(1, -10, 0, 40),
            BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Secondary,
            BackgroundTransparency = Nazuro.Settings.Transparency,
            Text = "",
            Parent = TabList
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = tabButton
        })
        
        local tabIcon = Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 10, 0.5, -10),
            BackgroundTransparency = 1,
            Image = tab.Icon,
            ImageColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
            Parent = tabButton
        })
        
        local tabTitle = Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 40, 0, 0),
            BackgroundTransparency = 1,
            Text = tab.Name,
            TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = tabButton
        })
        
        local tabContent = Create("ScrollingFrame", {
            Name = tab.Name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
            Parent = TabContent
        })
        
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 15),
            Parent = tabContent
        })
        
        tabButton.MouseButton1Click:Connect(function()
            RippleEffect(tabButton)
            if window.CurrentTab then
                window.CurrentTab.Content.Visible = false
            end
            window.CurrentTab = tab
            tabContent.Visible = true
        end)
        
        tab.Content = tabContent
        table.insert(window.Tabs, tab)
        
        if #window.Tabs == 1 then
            window.CurrentTab = tab
            tabContent.Visible = true
        end
        
        function tab:CreateSection(options)
            local section = {
                Name = options.Name,
                Content = nil
            }
            
            local sectionFrame = Create("Frame", {
                Name = options.Name,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = tab.Content
            })
            
            local sectionTitle = Create("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = section.Name,
                TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamBold,
                TextSize = 16,
                Parent = sectionFrame
            })
            
            local sectionContent = Create("Frame", {
                Name = "Content",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })
            
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = sectionContent
            })
            
            section.Content = sectionContent
            table.insert(tab.Sections, section)
            
            function section:UpdateSize()
                local contentSize = sectionContent.UIListLayout.AbsoluteContentSize
                sectionContent.Size = UDim2.new(1, 0, 0, contentSize.Y)
                sectionFrame.Size = UDim2.new(1, 0, 0, 30 + contentSize.Y)
            end
            
            function section:CreateButton(options)
                local button = Create("TextButton", {
                    Name = options.Name,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    BackgroundTransparency = 0.5,
                    Text = options.Name,
                    TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = section.Content
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = button
                })
                
                Create("UIStroke", {
                    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = button
                })
                
                button.MouseButton1Click:Connect(function()
                    RippleEffect(button)
                    pcall(options.Callback)
                end)
                
                section:UpdateSize()
                
                return {
                    SetText = function(text)
                        button.Text = text
                    end,
                    SetCallback = function(callback)
                        options.Callback = callback
                    end
                }
            end
            
            function section:CreateToggle(options)
                local toggle = {
                    Value = options.Default or false,
                    Callback = options.Callback
                }
                
                local toggleFrame = Create("Frame", {
                    Name = options.Name,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Secondary,
                    BackgroundTransparency = Nazuro.Settings.Transparency,
                    Parent = section.Content
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = toggleFrame
                })
                
                Create("UIStroke", {
                    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = toggleFrame
                })
                
                local toggleTitle = Create("TextLabel", {
                    Name = "Title",
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = options.Name,
                    TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = toggleFrame
                })
                
                local toggleSwitch = Create("Frame", {
                    Name = "Switch",
                    Size = UDim2.new(0, 50, 0, 25),
                    Position = UDim2.new(1, -15, 0.5, -12.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Secondary,
                    BackgroundTransparency = Nazuro.Settings.Transparency,
                    Parent = toggleFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleSwitch
                })
                
                Create("UIStroke", {
                    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = toggleSwitch
                })
                
                local toggleIndicator = Create("Frame", {
                    Name = "Indicator",
                    Size = UDim2.new(0, 21, 0, 21),
                    Position = toggle.Value and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Parent = toggleSwitch
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleIndicator
                })
                
                local function UpdateToggle()
                    Tween(toggleIndicator, {
                        Position = toggle.Value and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5),
                        BackgroundColor3 = toggle.Value and Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent or Nazuro.Themes[Nazuro.Settings.CurrentTheme].SubText
                    })
                    
                    pcall(toggle.Callback, toggle.Value)
                end
                
                toggleFrame.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    UpdateToggle()
                end)
                
                section:UpdateSize()
                
                return {
                    SetValue = function(value)
                        toggle.Value = value
                        UpdateToggle()
                    end,
                    GetValue = function()
                        return toggle.Value
                    end,
                    SetCallback = function(callback)
                        toggle.Callback = callback
                    end
                }
            end
            
            function section:CreateSlider(options)
                local slider = {
                    Value = options.Default or options.Min,
                    Min = options.Min or 0,
                    Max = options.Max or 100,
                    Callback = options.Callback
                }
                
                local sliderFrame = Create("Frame", {
                    Name = options.Name,
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundTransparency = 1,
                    Parent = section.Content
                })
                
                local sliderTitle = Create("TextLabel", {
                    Name = "Title",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = options.Name,
                    TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = sliderFrame
                })
                
                local sliderValue = Create("TextLabel", {
                    Name = "Value",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = tostring(slider.Value),
                    TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].SubText,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = sliderFrame
                })
                
                local sliderBar = Create("Frame", {
                    Name = "Bar",
                    Size = UDim2.new(1, 0, 0, 5),
                    Position = UDim2.new(0, 0, 1, -15),
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Secondary,
                    BackgroundTransparency = Nazuro.Settings.Transparency,
                    Parent = sliderFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderBar
                })
                
                Create("UIStroke", {
                    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = sliderBar
                })
                
                local sliderFill = Create("Frame", {
                    Name = "Fill",
                    Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Parent = sliderBar
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderFill
                })
                
                local sliderHandle = Create("Frame", {
                    Name = "Handle",
                    Size = UDim2.new(0, 15, 0, 15),
                    Position = UDim2.new(sliderFill.Size.X.Scale, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Parent = sliderBar
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderHandle
                })
                
                Create("UIStroke", {
                    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
                    Thickness = 2,
                    Parent = sliderHandle
                })
                
                local dragging = false
                
                local function UpdateSlider(value)
                    value = math.clamp(value, slider.Min, slider.Max)
                    slider.Value = value
                    sliderValue.Text = tostring(math.floor(value * 100) / 100)
                    
                    Tween(sliderFill, {
                        Size = UDim2.new((value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
                    })
                    
                    Tween(sliderHandle, {
                        Position = UDim2.new(sliderFill.Size.X.Scale, 0, 0.5, 0)
                    })
                    
                    pcall(slider.Callback, value)
                end
                
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                        UpdateSlider(slider.Min + percent * (slider.Max - slider.Min))
                    end
                end)
                
                sliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X
                        UpdateSlider(slider.Min + percent * (slider.Max - slider.Min))
                    end
                end)
                
                section:UpdateSize()
                
                return {
                    SetValue = function(value)
                        UpdateSlider(value)
                    end,
                    GetValue = function()
                        return slider.Value
                    end,
                    SetCallback = function(callback)
                        slider.Callback = callback
                    end
                }
            end
            
            function section:CreateDropdown(options)
                local dropdown = {
                    Options = options.Options or {},
                    Value = options.Default or options.Options[1],
                    Callback = options.Callback,
                    Open = false
                }
                
                local dropdownFrame = Create("Frame", {
                    Name = options.Name,
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Secondary,
                    BackgroundTransparency = Nazuro.Settings.Transparency,
                    Parent = section.Content
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = dropdownFrame
                })
                
                Create("UIStroke", {
                    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = dropdownFrame
                })
                
                local dropdownTitle = Create("TextLabel", {
                    Name = "Title",
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = options.Name,
                    TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = dropdownFrame
                })
                
                local dropdownValue = Create("TextLabel", {
                    Name = "Value",
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(dropdown.Value),
                    TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].SubText,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = dropdownFrame
                })
                
                local dropdownArrow = Create("ImageLabel", {
                    Name = "Arrow",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -15, 0.5, -10),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://10734922324",
                    ImageColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
                    Rotation = 180,
                    Parent = dropdownFrame
                })
                
                local dropdownList = Create("Frame", {
                    Name = "List",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 5),
                    BackgroundColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Secondary,
                    BackgroundTransparency = Nazuro.Settings.Transparency,
                    Visible = false,
                    Parent = dropdownFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = dropdownList
                })
                
                Create("UIStroke", {
                    Color = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = dropdownList
                })
                
                Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = dropdownList
                })
                
                local function UpdateDropdown()
                    if dropdown.Open then
                        dropdownList.Visible = true
                        Tween(dropdownArrow, {Rotation = 0})
                        Tween(dropdownList, {Size = UDim2.new(1, 0, 0, #dropdown.Options * 35)})
                    else
                        Tween(dropdownArrow, {Rotation = 180})
                        Tween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, function()
                            dropdownList.Visible = false
                        end)
                    end
                end
                
                local function CreateOption(option)
                    local optionButton = Create("TextButton", {
                        Name = tostring(option),
                        Size = UDim2.new(1, 0, 0, 35),
                        BackgroundTransparency = 1,
                        Text = "",
                        Parent = dropdownList
                    })
                    
                    local optionText = Create("TextLabel", {
                        Name = "Text",
                        Size = UDim2.new(1, -20, 1, 0),
                        Position = UDim2.new(0, 10, 0, 0),
                        BackgroundTransparency = 1,
                        Text = tostring(option),
                        TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Font = Enum.Font.Gotham,
                        TextSize = 14,
                        Parent = optionButton
                    })
                    
                    optionButton.MouseButton1Click:Connect(function()
                        dropdown.Value = option
                        dropdownValue.Text = tostring(option)
                        dropdown.Open = false
                        UpdateDropdown()
                        pcall(dropdown.Callback, option)
                    end)
                    
                    optionButton.MouseEnter:Connect(function()
                        Tween(optionText, {
                            TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Accent
                        })
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        Tween(optionText, {
                            TextColor3 = Nazuro.Themes[Nazuro.Settings.CurrentTheme].Text
                        })
                    end)
                end
                
                for _, option in ipairs(dropdown.Options) do
                    CreateOption(option)
                end
                
                dropdownFrame.MouseButton1Click:Connect(function()
                    dropdown.Open = not dropdown.Open
                    UpdateDropdown()
                end)
                
                section:UpdateSize()
                
                return {
                    SetValue = function(value)
                        dropdown.Value = value
                        dropdownValue.Text = tostring(value)
                        pcall(dropdown.Callback, value)
                    end,
                    GetValue = function()
                        return dropdown.Value
                    end,
                    SetOptions = function(options)
                        dropdown.Options = options
                        dropdownList:ClearAllChildren()
                        for _, option in ipairs(options) do
                            CreateOption(option)
                        end
                    end,
                    SetCallback = function(callback)
                        dropdown.Callback = callback
                    end
                }
            end
            
            return section
        end
        
        return tab
    end
    
    return window
end

return Nazuro
