local NebulaUI = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Constants
local SCREEN_GUI = Instance.new("ScreenGui")
SCREEN_GUI.Name = "NebulaUI"
SCREEN_GUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
SCREEN_GUI.IgnoreGuiInset = true

local DEFAULT_THEME = {
    Background = Color3.fromRGB(20, 20, 30),
    Sidebar = Color3.fromRGB(40, 40, 60),
    Accent = Color3.fromRGB(100, 60, 120),
    Text = Color3.fromRGB(200, 200, 200),
    ToggleOn = Color3.fromRGB(100, 60, 120),
    ToggleOff = Color3.fromRGB(60, 60, 80)
}

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(instance, time, properties)
    return TweenService:Create(instance, TweenInfo.new(time), properties):Play()
end

-- UI Creation
function NebulaUI:Init()
    local ui = {
        ScreenGui = SCREEN_GUI,
        MainFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 300, 0, 400),
            Position = UDim2.new(0.5, -150, 0.5, -200),
            BackgroundColor3 = DEFAULT_THEME.Background,
            BorderSizePixel = 0,
            Parent = SCREEN_GUI
        }),
        Sidebar = CreateInstance("Frame", {
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = DEFAULT_THEME.Sidebar,
            BorderSizePixel = 0,
            Parent = ui.MainFrame
        }),
        Content = CreateInstance("Frame", {
            Size = UDim2.new(0, 200, 1, 0),
            Position = UDim2.new(0, 100, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Parent = ui.MainFrame
        })
    }

    -- Title
    CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Text = "Nebula UI - Modern Edition",
        TextColor3 = DEFAULT_THEME.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = ui.MainFrame
    })

    -- Sidebar Navigation
    local sidebarLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = ui.Sidebar
    })

    local sections = {
        {Icon = "⚙️", Name = "General"},
        {Icon = "🎨", Name = "Style"},
        {Icon = "⚡", Name = "Performance"},
        {Icon = "💻", Name = "Lua"},
        {Icon = "💾", Name = "Code"}
    }

    local currentSection = "Performance"
    for _, section in ipairs(sections) do
        local button = CreateInstance("TextButton", {
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundColor3 = DEFAULT_THEME.Sidebar,
            Text = section.Icon .. " " .. section.Name,
            TextColor3 = DEFAULT_THEME.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            Parent = ui.Sidebar
        })
        button.MouseButton1Click:Connect(function()
            currentSection = section.Name
            ui.Content:ClearAllChildren()
            NebulaUI:BuildContent(ui.Content, currentSection)
        end)
        if section.Name == currentSection then
            button.BackgroundColor3 = DEFAULT_THEME.Accent
        end
    end

    -- Initial Content
    NebulaUI:BuildContent(ui.Content, currentSection)

    -- Corner
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = ui.MainFrame
    })

    return ui
end

function NebulaUI:BuildContent(contentFrame, section)
    contentFrame:ClearAllChildren()
    local layout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = contentFrame
    })

    if section == "Performance" then
        -- Hardware Acceleration Toggle
        local hwAccelFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = contentFrame
        })
        CreateInstance("TextLabel", {
            Size = UDim2.new(0, 150, 1, 0),
            BackgroundTransparency = 1,
            Text = "Hardware Acceleration",
            TextColor3 = DEFAULT_THEME.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = hwAccelFrame
        })
        local hwAccelToggle = CreateInstance("TextButton", {
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, -10),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = DEFAULT_THEME.ToggleOff,
            BorderSizePixel = 0,
            Parent = hwAccelFrame
        })
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = hwAccelToggle
        })
        local toggleDot = CreateInstance("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 1, 0.5, -9),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = DEFAULT_THEME.Text,
            BorderSizePixel = 0,
            Parent = hwAccelToggle
        })
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 9),
            Parent = toggleDot
        })
        local isOn = false
        hwAccelToggle.MouseButton1Click:Connect(function()
            isOn = not isOn
            Tween(toggleDot, 0.2, {Position = isOn and UDim2.new(0, 21, 0.5, -9) or UDim2.new(0, 1, 0.5, -9)})
            Tween(hwAccelToggle, 0.2, {BackgroundColor3 = isOn and DEFAULT_THEME.ToggleOn or DEFAULT_THEME.ToggleOff})
        end)

        -- Reduce Animations Toggle
        local reduceAnimFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = contentFrame
        })
        CreateInstance("TextLabel", {
            Size = UDim2.new(0, 150, 1, 0),
            BackgroundTransparency = 1,
            Text = "Reduce Animations",
            TextColor3 = DEFAULT_THEME.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = reduceAnimFrame
        })
        local reduceAnimToggle = CreateInstance("TextButton", {
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -50, 0.5, -10),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = DEFAULT_THEME.ToggleOff,
            BorderSizePixel = 0,
            Parent = reduceAnimFrame
        })
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = reduceAnimToggle
        })
        local reduceAnimDot = CreateInstance("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 1, 0.5, -9),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = DEFAULT_THEME.Text,
            BorderSizePixel = 0,
            Parent = reduceAnimToggle
        })
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 9),
            Parent = reduceAnimDot
        })
        local reduceAnimOn = false
        reduceAnimToggle.MouseButton1Click:Connect(function()
            reduceAnimOn = not reduceAnimOn
            Tween(reduceAnimDot, 0.2, {Position = reduceAnimOn and UDim2.new(0, 21, 0.5, -9) or UDim2.new(0, 1, 0.5, -9)})
            Tween(reduceAnimToggle, 0.2, {BackgroundColor3 = reduceAnimOn and DEFAULT_THEME.ToggleOn or DEFAULT_THEME.ToggleOff})
        end)

        -- FPS Limit Slider
        local fpsFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = contentFrame
        })
        CreateInstance("TextLabel", {
            Size = UDim2.new(0, 150, 1, 0),
            BackgroundTransparency = 1,
            Text = "FPS Limit",
            TextColor3 = DEFAULT_THEME.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = fpsFrame
        })
        local fpsValue = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 40, 1, 0),
            Position = UDim2.new(1, -50, 0, 0),
            BackgroundTransparency = 1,
            Text = "60",
            TextColor3 = DEFAULT_THEME.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = fpsFrame
        })
        local fpsSlider = CreateInstance("Frame", {
            Size = UDim2.new(0, 100, 0, 5),
            Position = UDim2.new(0, 160, 0.5, -2.5),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = DEFAULT_THEME.Accent,
            BorderSizePixel = 0,
            Parent = fpsFrame
        })
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 2.5),
            Parent = fpsSlider
        })
        local fpsThumb = CreateInstance("Frame", {
            Size = UDim2.new(0, 10, 0, 15),
            Position = UDim2.new(0, 0, 0.5, -7.5),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = DEFAULT_THEME.Text,
            BorderSizePixel = 0,
            Parent = fpsSlider
        })
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = fpsThumb
        })
        local fps = 60
        fpsThumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local dragging = true
                local startPos = fpsThumb.AbsolutePosition.X
                local startMouse = input.Position.X
                while dragging do
                    local delta = UserInputService:GetMouseLocation().X - startMouse
                    local newPos = math.clamp(startPos + delta, fpsSlider.AbsolutePosition.X, fpsSlider.AbsolutePosition.X + fpsSlider.AbsoluteSize.X - 10)
                    local percentage = (newPos - fpsSlider.AbsolutePosition.X) / (fpsSlider.AbsoluteSize.X - 10)
                    fps = math.floor(10 + percentage * 240) -- Range 10-250
                    fpsValue.Text = tostring(fps)
                    Tween(fpsThumb, 0.1, {Position = UDim2.new(0, newPos - fpsSlider.AbsolutePosition.X, 0.5, -7.5)})
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) == false then
                        dragging = false
                    end
                    wait()
                end
            end
        end)
    elseif section == "Code" then
        -- Memory Settings
        local cacheSizeFrame = CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = contentFrame
        })
        CreateInstance("TextLabel", {
            Size = UDim2.new(0, 150, 1, 0),
            BackgroundTransparency = 1,
            Text = "Cache Size (MB)",
            TextColor3 = DEFAULT_THEME.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            Parent = cacheSizeFrame
        })
        local cacheSizeValue = CreateInstance("TextBox", {
            Size = UDim2.new(0, 40, 1, 0),
            Position = UDim2.new(1, -50, 0, 0),
            BackgroundColor3 = DEFAULT_THEME.Accent,
            Text = "150",
            TextColor3 = DEFAULT_THEME.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            Parent = cacheSizeFrame
        })
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = cacheSizeValue
        })

        local clearCacheButton = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            Position = UDim2.new(0, 0, 0, 50),
            BackgroundColor3 = DEFAULT_THEME.Accent,
            Text = "Clear Cache",
            TextColor3 = DEFAULT_THEME.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            BorderSizePixel = 0,
            Parent = contentFrame
        })
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 5),
            Parent = clearCacheButton
        })
        clearCacheButton.MouseButton1Click:Connect(function()
            print("Cache cleared!")
            -- Add cache clearing logic here
        end)
    end
end

-- Initialize the UI
local ui = NebulaUI:Init()

return NebulaUI
