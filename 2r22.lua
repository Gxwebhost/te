--!native
--!optimize 2

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local NexusUI = {}

-- Custom color scheme
NexusUI.Theme = {
    Primary = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(35, 35, 45),
    Accent = Color3.fromRGB(100, 150, 255),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(180, 180, 180),
    TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint)
}

-- Custom rounded corner function
local function RoundedCorners(instance, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(cornerRadius, 0)
    corner.Parent = instance
    return corner
end

-- Custom stroke function
local function AddStroke(instance, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Transparency = transparency
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = instance
    return stroke
end

function NexusUI:CreateWindow(title, icon)
    local NexusWindow = Instance.new("ScreenGui")
    NexusWindow.Name = "NexusUI_"..tick()
    NexusWindow.ResetOnSpawn = false
    NexusWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global
    NexusWindow.Parent = game:GetService("CoreGui")

    -- Main container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, 500, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = NexusUI.Theme.Primary
    MainFrame.ClipsDescendants = true
    RoundedCorners(MainFrame, 0.1)
    AddStroke(MainFrame, 2, 0.8)
    MainFrame.Parent = NexusWindow

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = NexusUI.Theme.Secondary
    TitleBar.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 40, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title or "Nexus UI"
    TitleLabel.TextColor3 = NexusUI.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    -- Tab system
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    -- Tab buttons container
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, 150, 1, 0)
    TabButtons.BackgroundColor3 = NexusUI.Theme.Secondary
    TabButtons.Parent = TabContainer

    -- Content container
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -150, 1, 0)
    ContentFrame.Position = UDim2.new(0, 150, 0, 0)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = TabContainer

    -- Active tab indicator
    local ActiveTabIndicator = Instance.new("Frame")
    ActiveTabIndicator.Name = "ActiveTabIndicator"
    ActiveTabIndicator.Size = UDim2.new(0, 4, 0, 30)
    ActiveTabIndicator.Position = UDim2.new(1, 0, 0, 0)
    ActiveTabIndicator.AnchorPoint = Vector2.new(1, 0)
    ActiveTabIndicator.BackgroundColor3 = NexusUI.Theme.Accent
    ActiveTabIndicator.Parent = TabButtons

    -- Drag functionality
    local dragging
    local dragInput
    local dragStart
    local startPos

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
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local Window = {}
    
    function Window:CreateTab(name, icon)
        -- Tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Position = UDim2.new(0, 5, 0, 5 + (#TabButtons:GetChildren() - 1) * 45)
        TabButton.BackgroundColor3 = NexusUI.Theme.Secondary
        TabButton.Text = name
        TabButton.TextColor3 = NexusUI.Theme.SubText
        TabButton.TextSize = 14
        TabButton.Font = Enum.Font.Gotham
        TabButton.AutoButtonColor = false
        RoundedCorners(TabButton, 0.1)
        TabButton.Parent = TabButtons

        -- Tab content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 5
        TabContent.ScrollBarImageColor3 = NexusUI.Theme.Accent
        TabContent.Visible = false
        TabContent.Parent = ContentFrame

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent

        -- Tab selection logic
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in ipairs(ContentFrame:GetChildren()) do
                if tab:IsA("ScrollingFrame") then
                    tab.Visible = false
                end
            end
            
            TabContent.Visible = true
            
            -- Update active tab indicator
            TweenService:Create(ActiveTabIndicator, NexusUI.Theme.TweenInfo, {
                Position = UDim2.new(1, 0, 0, TabButton.Position.Y.Offset + 5)
            }):Play()
            
            -- Update tab button appearance
            for _, button in ipairs(TabButtons:GetChildren()) do
                if button:IsA("TextButton") then
                    TweenService:Create(button, NexusUI.Theme.TweenInfo, {
                        BackgroundColor3 = button == TabButton and NexusUI.Theme.Primary or NexusUI.Theme.Secondary,
                        TextColor3 = button == TabButton and NexusUI.Theme.Text or NexusUI.Theme.SubText
                    }):Play()
                end
            end
        end)

        -- Auto-select first tab
        if #TabButtons:GetChildren() == 1 then
            TabButton.MouseButton1Click:Wait()
        end

        local Tab = {}
        
        function Tab:CreateSection(title)
            local Section = Instance.new("Frame")
            Section.Name = title
            Section.Size = UDim2.new(1, -20, 0, 0)
            Section.Position = UDim2.new(0, 10, 0, 10)
            Section.BackgroundTransparency = 1
            Section.Parent = TabContent

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Size = UDim2.new(1, 0, 0, 30)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = title
            SectionTitle.TextColor3 = NexusUI.Theme.Text
            SectionTitle.TextSize = 16
            SectionTitle.Font = Enum.Font.GothamSemibold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Padding = UDim.new(0, 10)
            SectionLayout.Parent = Section

            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingTop = UDim.new(0, 30)
            SectionPadding.Parent = Section

            local function UpdateSize()
                Section.Size = UDim2.new(1, -20, 0, SectionLayout.AbsoluteContentSize.Y + 30)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end

            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
            UpdateSize()

            local SectionFunctions = {}
            
            function SectionFunctions:CreateButton(settings)
                -- Button implementation here
            end
            
            function SectionFunctions:CreateToggle(settings)
                -- Toggle implementation here
            end
            
            -- Add more element creation functions as needed
            
            return SectionFunctions
        end
        
        return Tab
    end
    
    return Window
end

return NexusUI
