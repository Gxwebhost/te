--[[
    SimpleUI Library
    A lightweight UI library inspired by WindUI
]]

local SimpleUI = {
    Themes = {
        Dark = {
            Background = Color3.fromRGB(25, 25, 30),
            Primary = Color3.fromRGB(45, 45, 50),
            Secondary = Color3.fromRGB(35, 35, 40),
            Text = Color3.fromRGB(240, 240, 240),
            Accent = Color3.fromRGB(100, 150, 255)
        },
        Light = {
            Background = Color3.fromRGB(240, 240, 245),
            Primary = Color3.fromRGB(220, 220, 225),
            Secondary = Color3.fromRGB(200, 200, 210),
            Text = Color3.fromRGB(30, 30, 35),
            Accent = Color3.fromRGB(80, 130, 235)
        }
    },
    CurrentTheme = "Dark",
    Elements = {},
    Services = {
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        TweenService = game:GetService("TweenService")
    }
}

-- Utility functions
function SimpleUI:Create(className, properties, children)
    local instance = Instance.new(className)
    
    for property, value in pairs(properties) do
        instance[property] = value
    end
    
    if children then
        for _, child in ipairs(children) do
            child.Parent = instance
        end
    end
    
    return instance
end

function SimpleUI:Tween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = self.Services.TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Window creation
function SimpleUI:CreateWindow(options)
    options = options or {}
    local window = {
        Title = options.Title or "SimpleUI Window",
        Size = options.Size or UDim2.new(0, 500, 0, 400),
        Position = options.Position or UDim2.new(0.5, 0, 0.5, 0),
        Theme = options.Theme or self.CurrentTheme,
        Elements = {}
    }
    
    -- Main window frame
    window.MainFrame = self:Create("Frame", {
        Name = "SimpleUIWindow",
        Size = window.Size,
        Position = window.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Themes[window.Theme].Background,
        ClipsDescendants = true
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("UIStroke", {
            Color = self.Themes[window.Theme].Accent,
            Thickness = 1
        })
    })
    
    -- Title bar
    window.TitleBar = self:Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Themes[window.Theme].Primary,
        BorderSizePixel = 0
    }, {
        self:Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        self:Create("TextLabel", {
            Text = window.Title,
            TextColor3 = self.Themes[window.Theme].Text,
            Font = Enum.Font.SemiBold,
            TextSize = 16,
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        }),
        self:Create("TextButton", {
            Name = "CloseButton",
            Text = "X",
            TextColor3 = self.Themes[window.Theme].Text,
            Font = Enum.Font.SemiBold,
            TextSize = 16,
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(1, -30, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 60, 60),
            AutoButtonColor = false
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 8)})
        })
    })
    
    window.TitleBar.Parent = window.MainFrame
    
    -- Content frame
    window.ContentFrame = self:Create("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -20, 1, -50),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1
    })
    window.ContentFrame.Parent = window.MainFrame
    
    -- Dragging functionality
    local dragging = false
    local dragInput, dragStart, startPos
    
    window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    window.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    self.Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            window.MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Close button functionality
    window.TitleBar.CloseButton.MouseButton1Click:Connect(function()
        window.MainFrame:Destroy()
    end)
    
    -- Tab system
    function window:CreateTab(name)
        local tab = {
            Name = name,
            Buttons = {},
            Elements = {}
        }
        
        -- Tab button
        tab.Button = self:Create("TextButton", {
            Text = name,
            Size = UDim2.new(0, 100, 0, 30),
            Position = UDim2.new(0, 10 + (#window.Elements * 110), 0, 5),
            BackgroundColor3 = self.Themes[window.Theme].Secondary,
            TextColor3 = self.Themes[window.Theme].Text,
            Font = Enum.Font.SemiBold,
            TextSize = 14
        }, {
            self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
        tab.Button.Parent = window.TitleBar
        
        -- Tab content
        tab.Content = self:Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 5,
            Visible = #window.Elements == 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        }, {
            self:Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            self:Create("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            })
        })
        tab.Content.Parent = window.ContentFrame
        
        -- Tab switching
        tab.Button.MouseButton1Click:Connect(function()
            for _, otherTab in ipairs(window.Elements) do
                otherTab.Content.Visible = false
                self:Tween(otherTab.Button, {BackgroundColor3 = self.Themes[window.Theme].Secondary})
            end
            
            tab.Content.Visible = true
            self:Tween(tab.Button, {BackgroundColor3 = self.Themes[window.Theme].Accent})
        end)
        
        -- Add elements to tab
        function tab:AddLabel(text)
            local label = self:Create("TextLabel", {
                Text = text,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 20),
                LayoutOrder = #tab.Elements + 1
            })
            label.Parent = tab.Content
            table.insert(tab.Elements, label)
            return label
        end
        
        function tab:AddButton(text, callback)
            local button = self:Create("TextButton", {
                Text = text,
                Size = UDim2.new(1, -20, 0, 30),
                BackgroundColor3 = self.Themes[window.Theme].Secondary,
                TextColor3 = self.Themes[window.Theme].Text,
                Font = Enum.Font.SemiBold,
                TextSize = 14,
                LayoutOrder = #tab.Elements + 1,
                AutoButtonColor = false
            }, {
                self:Create("UICorner", {CornerRadius = UDim.new(0, 6)})
            })
            
            button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            button.MouseEnter:Connect(function()
                self:Tween(button, {BackgroundColor3 = self.Themes[window.Theme].Primary})
            end)
            
            button.MouseLeave:Connect(function()
                self:Tween(button, {BackgroundColor3 = self.Themes[window.Theme].Secondary})
            end)
            
            button.Parent = tab.Content
            table.insert(tab.Elements, button)
            return button
        end
        
        function tab:AddToggle(text, default, callback)
            local toggle = {
                Value = default or false,
                Callback = callback
            }
            
            local frame = self:Create("Frame", {
                Size = UDim2.new(1, -20, 0, 30),
                BackgroundTransparency = 1,
                LayoutOrder = #tab.Elements + 1
            })
            
            local label = self:Create("TextLabel", {
                Text = text,
                TextColor3 = self.Themes[window.Theme].Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.7, 0, 1, 0)
            })
            label.Parent = frame
            
            local toggleButton = self:Create("TextButton", {
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -50, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = default and self.Themes[window.Theme].Accent or self.Themes[window.Theme].Secondary,
                Text = "",
                AutoButtonColor = false
            }, {
                self:Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
                self:Create("Frame", {
                    Size = UDim2.new(0, 21, 0, 21),
                    Position = default and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1)
                }, {
                    self:Create("UICorner", {CornerRadius = UDim.new(1, 0)})
                })
            })
            toggleButton.Parent = frame
            
            toggleButton.MouseButton1Click:Connect(function()
                toggle.Value = not toggle.Value
                self:Tween(toggleButton, {
                    BackgroundColor3 = toggle.Value and self.Themes[window.Theme].Accent or self.Themes[window.Theme].Secondary
                })
                
                self:Tween(toggleButton:FindFirstChildOfClass("Frame"), {
                    Position = toggle.Value and UDim2.new(1, -23, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                })
                
                if toggle.Callback then toggle.Callback(toggle.Value) end
            end)
            
            frame.Parent = tab.Content
            table.insert(tab.Elements, toggle)
            return toggle
        end
        
        table.insert(window.Elements, tab)
        return tab
    end
    
    -- Make first tab active if it exists
    if #window.Elements > 0 then
        window.Elements[1].Content.Visible = true
        self:Tween(window.Elements[1].Button, {BackgroundColor3 = self.Themes[window.Theme].Accent})
    end
    
    window.MainFrame.Parent = options.Parent or game:GetService("CoreGui")
    table.insert(self.Elements, window)
    return window
end

-- Theme management
function SimpleUI:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = themeName
        for _, window in ipairs(self.Elements) do
            -- Update all window elements with new theme
            -- This would need to be expanded to update all UI elements
            window.MainFrame.BackgroundColor3 = self.Themes[themeName].Background
            window.TitleBar.BackgroundColor3 = self.Themes[themeName].Primary
            window.TitleBar.TextLabel.TextColor3 = self.Themes[themeName].Text
            window.TitleBar.CloseButton.TextColor3 = self.Themes[themeName].Text
            window.UIStroke.Color = self.Themes[themeName].Accent
        end
    end
end

return SimpleUI
