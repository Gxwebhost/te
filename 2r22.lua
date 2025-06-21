-- Nazuro UI Library - Transparent Purple-Blue Theme
-- github.com/Gxwebhost/te/main/2r22.lua

local Nazuro = {}
Nazuro.__index = Nazuro

-- Custom Transparent Purple-Blue Theme
local Themes = {
    PurpleBlue = {
        Background = Color3.fromRGB(30, 20, 50),
        Foreground = Color3.fromRGB(40, 30, 70),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(120, 80, 200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Border = Color3.fromRGB(90, 70, 150),
        Transparency = 0.5
    }
}

-- Utility functions
local function Create(class, props)
    local instance = Instance.new(class)
    for prop, value in pairs(props) do
        if prop == "Parent" then
            instance.Parent = value
        else
            instance[prop] = value
        end
    end
    return instance
end

local function Tween(object, properties, duration, style)
    game:GetService("TweenService"):Create(
        object,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad),
        properties
    ):Play()
end

-- Window creation with drag functionality
function Nazuro:CreateWindow(config)
    local Window = {}
    Window.Theme = Themes.PurpleBlue -- Force the purple-blue theme
    Window.Name = config.Name or "Nazuro UI"
    
    -- Main GUI
    local ScreenGui = Create("ScreenGui", {
        Name = Window.Name,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    })
    
    -- Main frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Window.Theme.Background,
        BackgroundTransparency = Window.Theme.Transparency,
        Parent = ScreenGui
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame
    })
    
    Create("UIStroke", {
        Color = Window.Theme.Border,
        Thickness = 1,
        Transparency = 0.7,
        Parent = MainFrame
    })
    
    -- Title bar with drag functionality
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Window.Theme.Foreground,
        BackgroundTransparency = Window.Theme.Transparency,
        Parent = MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8, 0, 0),
        Parent = TitleBar
    })
    
    Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = Window.Name,
        TextColor3 = Window.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamSemibold,
        TextSize = 16,
        Parent = TitleBar
    })
    
    -- Make window draggable
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function Update(input)
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
            Update(input)
        end
    end)
    
    -- Tab container
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 100, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = Window.Theme.Foreground,
        BackgroundTransparency = Window.Theme.Transparency,
        Parent = MainFrame
    })
    
    Create("UIStroke", {
        Color = Window.Theme.Border,
        Thickness = 1,
        Transparency = 0.7,
        Parent = TabContainer
    })
    
    local TabContent = Create("Frame", {
        Name = "TabContent",
        Size = UDim2.new(1, -100, 1, -30),
        Position = UDim2.new(0, 100, 0, 30),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local TabListLayout = Create("UIListLayout", {
        Name = "TabListLayout",
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabContainer
    })
    
    local TabPadding = Create("UIPadding", {
        Name = "TabPadding",
        PaddingTop = UDim.new(0, 5),
        Parent = TabContainer
    })
    
    -- Window methods
    function Window:CreateTab(config)
        local Tab = {}
        Tab.Name = config.Name or "Tab"
        Tab.Icon = config.Icon or ""
        
        local TabButton = Create("TextButton", {
            Name = "TabButton_"..Tab.Name,
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundColor3 = Window.Theme.Foreground,
            BackgroundTransparency = Window.Theme.Transparency,
            Text = Tab.Name,
            TextColor3 = Window.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            LayoutOrder = #TabContainer:GetChildren(),
            Parent = TabContainer
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = TabButton
        })
        
        Create("UIStroke", {
            Color = Window.Theme.Border,
            Thickness = 1,
            Transparency = 0.7,
            Parent = TabButton
        })
        
        local TabFrame = Create("ScrollingFrame", {
            Name = "TabFrame_"..Tab.Name,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 5,
            Visible = false,
            Parent = TabContent
        })
        
        Create("UIListLayout", {
            Name = "TabLayout",
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = TabFrame
        })
        
        Create("UIPadding", {
            Name = "TabPadding",
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            Parent = TabFrame
        })
        
        -- Set first tab as visible
        if #TabContainer:GetChildren() == 1 then
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Window.Theme.Accent
            TabButton.BackgroundTransparency = Window.Theme.Transparency - 0.2
        end
        
        -- Tab button click event
        TabButton.MouseButton1Click:Connect(function()
            for _, child in ipairs(TabContent:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            
            for _, child in ipairs(TabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    Tween(child, {BackgroundColor3 = Window.Theme.Foreground, BackgroundTransparency = Window.Theme.Transparency})
                end
            end
            
            TabFrame.Visible = true
            Tween(TabButton, {BackgroundColor3 = Window.Theme.Accent, BackgroundTransparency = Window.Theme.Transparency - 0.2})
        end)
        
        -- Tab methods
        function Tab:CreateSection(config)
            local Section = {}
            Section.Name = config.Name or "Section"
            
            local SectionFrame = Create("Frame", {
                Name = "Section_"..Section.Name,
                Size = UDim2.new(1, -20, 0, 0),
                BackgroundColor3 = Window.Theme.Foreground,
                BackgroundTransparency = Window.Theme.Transparency,
                LayoutOrder = #TabFrame:GetChildren(),
                Parent = TabFrame
            })
            
            Create("UICorner", {
                CornerRadius = UDim.new(0, 5),
                Parent = SectionFrame
            })
            
            Create("UIStroke", {
                Color = Window.Theme.Border,
                Thickness = 1,
                Transparency = 0.7,
                Parent = SectionFrame
            })
            
            local SectionTitle = Create("TextLabel", {
                Name = "SectionTitle",
                Size = UDim2.new(1, -10, 0, 25),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = Section.Name,
                TextColor3 = Window.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                Parent = SectionFrame
            })
            
            local SectionContent = Create("Frame", {
                Name = "SectionContent",
                Size = UDim2.new(1, -10, 0, 0),
                Position = UDim2.new(0, 5, 0, 30),
                BackgroundTransparency = 1,
                Parent = SectionFrame
            })
            
            local SectionListLayout = Create("UIListLayout", {
                Name = "SectionListLayout",
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 5),
                Parent = SectionContent
            })
            
            SectionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, -10, 0, SectionListLayout.AbsoluteContentSize.Y)
                SectionFrame.Size = UDim2.new(1, -20, 0, SectionListLayout.AbsoluteContentSize.Y + 35)
            end)
            
            -- Section methods
            function Section:CreateToggle(config)
                local Toggle = {}
                Toggle.Name = config.Name or "Toggle"
                Toggle.Default = config.Default or false
                Toggle.Callback = config.Callback or function() end
                Toggle.Value = Toggle.Default
                
                local ToggleFrame = Create("Frame", {
                    Name = "Toggle_"..Toggle.Name,
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundTransparency = 1,
                    LayoutOrder = #SectionContent:GetChildren(),
                    Parent = SectionContent
                })
                
                local ToggleLabel = Create("TextLabel", {
                    Name = "ToggleLabel",
                    Size = UDim2.new(0.7, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = Toggle.Name,
                    TextColor3 = Window.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = ToggleFrame
                })
                
                local ToggleButton = Create("TextButton", {
                    Name = "ToggleButton",
                    Size = UDim2.new(0, 50, 0, 25),
                    Position = UDim2.new(1, -50, 0, 0),
                    BackgroundColor3 = Window.Theme.Foreground,
                    BackgroundTransparency = Window.Theme.Transparency,
                    Text = "",
                    Parent = ToggleFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = ToggleButton
                })
                
                Create("UIStroke", {
                    Color = Window.Theme.Border,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = ToggleButton
                })
                
                local ToggleCircle = Create("Frame", {
                    Name = "ToggleCircle",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 3, 0.5, -10),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(220, 220, 255),
                    Parent = ToggleButton
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = ToggleCircle
                })
                
                local function UpdateToggle()
                    if Toggle.Value then
                        Tween(ToggleCircle, {Position = UDim2.new(1, -23, 0.5, -10)})
                        Tween(ToggleButton, {BackgroundColor3 = Window.Theme.Accent, BackgroundTransparency = Window.Theme.Transparency - 0.2})
                    else
                        Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -10)})
                        Tween(ToggleButton, {BackgroundColor3 = Window.Theme.Foreground, BackgroundTransparency = Window.Theme.Transparency})
                    end
                    Toggle.Callback(Toggle.Value)
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    Toggle.Value = not Toggle.Value
                    UpdateToggle()
                end)
                
                -- Initialize
                UpdateToggle()
                
                -- Toggle methods
                function Toggle:Set(value)
                    Toggle.Value = value
                    UpdateToggle()
                end
                
                function Toggle:Get()
                    return Toggle.Value
                end
                
                return Toggle
            end
            
            function Section:CreateSlider(config)
                local Slider = {}
                Slider.Name = config.Name or "Slider"
                Slider.Min = config.Min or 0
                Slider.Max = config.Max or 100
                Slider.Default = config.Default or Slider.Min
                Slider.Callback = config.Callback or function() end
                Slider.Value = Slider.Default
                
                local SliderFrame = Create("Frame", {
                    Name = "Slider_"..Slider.Name,
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1,
                    LayoutOrder = #SectionContent:GetChildren(),
                    Parent = SectionContent
                })
                
                local SliderLabel = Create("TextLabel", {
                    Name = "SliderLabel",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = Slider.Name,
                    TextColor3 = Window.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = SliderFrame
                })
                
                local SliderValue = Create("TextLabel", {
                    Name = "SliderValue",
                    Size = UDim2.new(0, 50, 0, 20),
                    Position = UDim2.new(1, -50, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(Slider.Default),
                    TextColor3 = Window.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = SliderFrame
                })
                
                local SliderTrack = Create("Frame", {
                    Name = "SliderTrack",
                    Size = UDim2.new(1, 0, 0, 5),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundColor3 = Window.Theme.Foreground,
                    BackgroundTransparency = Window.Theme.Transparency,
                    Parent = SliderFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = SliderTrack
                })
                
                local SliderFill = Create("Frame", {
                    Name = "SliderFill",
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = Window.Theme.Accent,
                    BackgroundTransparency = Window.Theme.Transparency - 0.2,
                    Parent = SliderTrack
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = SliderFill
                })
                
                local SliderThumb = Create("TextButton", {
                    Name = "SliderThumb",
                    Size = UDim2.new(0, 15, 0, 15),
                    Position = UDim2.new(0, 0, 0.5, -7.5),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(220, 220, 255),
                    AutoButtonColor = false,
                    Parent = SliderTrack
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 7.5),
                    Parent = SliderThumb
                })
                
                Create("UIStroke", {
                    Color = Window.Theme.Border,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = SliderThumb
                })
                
                local function UpdateSlider()
                    local ratio = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
                    SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
                    SliderThumb.Position = UDim2.new(ratio, 0, 0.5, 0)
                    SliderValue.Text = tostring(math.floor(Slider.Value * 10) / 10)
                    Slider.Callback(Slider.Value)
                end
                
                local dragging = false
                
                SliderThumb.MouseButton1Down:Connect(function()
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
                        local absolutePos = SliderTrack.AbsolutePosition.X
                        local absoluteSize = SliderTrack.AbsoluteSize.X
                        
                        local relativePos = math.clamp(mousePos - absolutePos, 0, absoluteSize)
                        local ratio = relativePos / absoluteSize
                        Slider.Value = math.floor((Slider.Min + (Slider.Max - Slider.Min) * ratio) * 10) / 10
                        
                        UpdateSlider()
                    end
                end)
                
                -- Initialize
                UpdateSlider()
                
                -- Slider methods
                function Slider:Set(value)
                    Slider.Value = math.clamp(value, Slider.Min, Slider.Max)
                    UpdateSlider()
                end
                
                function Slider:Get()
                    return Slider.Value
                end
                
                return Slider
            end
            
            function Section:CreateDropdown(config)
                local Dropdown = {}
                Dropdown.Name = config.Name or "Dropdown"
                Dropdown.Options = config.Options or {}
                Dropdown.Default = config.Default or Dropdown.Options[1]
                Dropdown.Callback = config.Callback or function() end
                Dropdown.Value = Dropdown.Default
                Dropdown.Open = false
                
                local DropdownFrame = Create("Frame", {
                    Name = "Dropdown_"..Dropdown.Name,
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundTransparency = 1,
                    LayoutOrder = #SectionContent:GetChildren(),
                    Parent = SectionContent
                })
                
                local DropdownButton = Create("TextButton", {
                    Name = "DropdownButton",
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Window.Theme.Foreground,
                    BackgroundTransparency = Window.Theme.Transparency,
                    Text = Dropdown.Name .. ": " .. Dropdown.Value,
                    TextColor3 = Window.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = DropdownFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = DropdownButton
                })
                
                Create("UIStroke", {
                    Color = Window.Theme.Border,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = DropdownButton
                })
                
                local DropdownIcon = Create("ImageLabel", {
                    Name = "DropdownIcon",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -25, 0.5, -10),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://10709790948",
                    ImageColor3 = Window.Theme.Text,
                    Parent = DropdownButton
                })
                
                local DropdownList = Create("Frame", {
                    Name = "DropdownList",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundColor3 = Window.Theme.Foreground,
                    BackgroundTransparency = Window.Theme.Transparency,
                    Visible = false,
                    Parent = DropdownFrame
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = DropdownList
                })
                
                Create("UIStroke", {
                    Color = Window.Theme.Border,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = DropdownList
                })
                
                local DropdownListLayout = Create("UIListLayout", {
                    Name = "DropdownListLayout",
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = DropdownList
                })
                
                DropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    DropdownList.Size = UDim2.new(1, 0, 0, DropdownListLayout.AbsoluteContentSize.Y)
                end)
                
                local function UpdateDropdown()
                    DropdownButton.Text = Dropdown.Name .. ": " .. Dropdown.Value
                    Dropdown.Callback(Dropdown.Value)
                end
                
                local function ToggleDropdown()
                    Dropdown.Open = not Dropdown.Open
                    DropdownList.Visible = Dropdown.Open
                    
                    if Dropdown.Open then
                        Tween(DropdownIcon, {Rotation = 180})
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, DropdownListLayout.AbsoluteContentSize.Y)})
                    else
                        Tween(DropdownIcon, {Rotation = 0})
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)})
                    end
                end
                
                DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
                
                -- Create option buttons
                for _, option in ipairs(Dropdown.Options) do
                    local OptionButton = Create("TextButton", {
                        Name = "Option_"..option,
                        Size = UDim2.new(1, -10, 0, 25),
                        Position = UDim2.new(0, 5, 0, 0),
                        BackgroundColor3 = Window.Theme.Foreground,
                        BackgroundTransparency = Window.Theme.Transparency,
                        Text = option,
                        TextColor3 = Window.Theme.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 14,
                        Parent = DropdownList
                    })
                    
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 5),
                        Parent = OptionButton
                    })
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Dropdown.Value = option
                        UpdateDropdown()
                        ToggleDropdown()
                    end)
                end
                
                -- Initialize
                UpdateDropdown()
                
                -- Dropdown methods
                function Dropdown:Set(value)
                    if table.find(Dropdown.Options, value) then
                        Dropdown.Value = value
                        UpdateDropdown()
                    end
                end
                
                function Dropdown:Get()
                    return Dropdown.Value
                end
                
                function Dropdown:Refresh(options)
                    Dropdown.Options = options or Dropdown.Options
                    Dropdown.Value = Dropdown.Default
                    
                    -- Clear existing options
                    for _, child in ipairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Create new options
                    for _, option in ipairs(Dropdown.Options) do
                        local OptionButton = Create("TextButton", {
                            Name = "Option_"..option,
                            Size = UDim2.new(1, -10, 0, 25),
                            Position = UDim2.new(0, 5, 0, 0),
                            BackgroundColor3 = Window.Theme.Foreground,
                            BackgroundTransparency = Window.Theme.Transparency,
                            Text = option,
                            TextColor3 = Window.Theme.Text,
                            Font = Enum.Font.Gotham,
                            TextSize = 14,
                            Parent = DropdownList
                        })
                        
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 5),
                            Parent = OptionButton
                        })
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            Dropdown.Value = option
                            UpdateDropdown()
                            ToggleDropdown()
                        end)
                    end
                    
                    UpdateDropdown()
                end
                
                return Dropdown
            end
            
            function Section:CreateButton(config)
                local Button = {}
                Button.Name = config.Name or "Button"
                Button.Callback = config.Callback or function() end
                
                local ButtonFrame = Create("TextButton", {
                    Name = "Button_"..Button.Name,
                    Size = UDim2.new(1, 0, 0, 25),
                    BackgroundColor3 = Window.Theme.Foreground,
                    BackgroundTransparency = Window.Theme.Transparency,
                    Text = Button.Name,
                    TextColor3 = Window.Theme.Text,
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    LayoutOrder = #SectionContent:GetChildren(),
                    Parent = SectionContent
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = ButtonFrame
                })
                
                Create("UIStroke", {
                    Color = Window.Theme.Border,
                    Thickness = 1,
                    Transparency = 0.7,
                    Parent = ButtonFrame
                })
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Window.Theme.Accent, BackgroundTransparency = Window.Theme.Transparency - 0.3})
                    Button.Callback()
                    task.wait(0.1)
                    Tween(ButtonFrame, {BackgroundColor3 = Window.Theme.Foreground, BackgroundTransparency = Window.Theme.Transparency})
                end)
                
                return Button
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

return Nazuro
