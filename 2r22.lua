--!native
--!optimize 2

local game = game
local GetService = game.GetService

cloneref = cloneref or function(...)
    return ...
end
isfile = isfile or function()
    return true
end
isfolder = isfolder or function()
    return true
end

local UserInputService = GetService(game, "UserInputService")
local TweenService = GetService(game, "TweenService")
local HttpService = GetService(game, "HttpService")
local RunService = GetService(game, "RunService")
local Players = GetService(game, "Players")
local CoreGui = cloneref(GetService(game, "CoreGui"))
local TextChatService = GetService(game, "TextChatService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local IsOnMobile = table.find({
    Enum.Platform.IOS,
    Enum.Platform.Android
}, UserInputService:GetPlatform())
local IsOnEmulator = IsOnMobile and UserInputService.KeyboardEnabled 

local Profile = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

local DefaultDuration = 5
local LibraryName = "Nazuro"
local Configurations = LibraryName .. "/Configurations/"
local Assets = LibraryName .. "/Assets/"

local Configuration = {
    Toggles = {},
    Dropdowns = {},
    Sliders = {},
    Inputs = {},
    Keybinds = {},
}

if RunService:IsStudio() then
    CoreGui = Players.LocalPlayer.PlayerGui
end

local function SafeMakeFolder(path)
    if not isfolder(path) then
        local success, err = pcall(makefolder, path)
        if not success then
            warn("Failed to create folder: " .. path .. " | Error: " .. tostring(err))
        end
    end
end

local function SafeWriteFile(filepath, content)
    local success, err = pcall(writefile, filepath, content)
    if not success then
        warn("Failed to write file: " .. filepath .. " | Error: " .. tostring(err))
    end
end

local function SafeReadFile(filepath)
    if isfile(filepath) then
        local success, content = pcall(readfile, filepath)
        if success then
            return content
        else
            warn("Failed to read file: " .. filepath .. " | Error: " .. tostring(content))
        end
    else
        warn("File does not exist: " .. filepath)
    end
    return nil
end

local function SafeHttpGet(url)
    local success, content = pcall(game.HttpGetAsync, game, url)
    if success then
        return content
    else
        warn("Failed to fetch URL: " .. url .. " | Error: " .. tostring(content))
    end
    return nil
end

SafeMakeFolder(LibraryName)
SafeMakeFolder(Configurations)

local GenerateString = function()
    local Charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local Result = ""
    for I = 1, 12 do
        local RandIndex = math.random(1, #Charset)
        Result = Result .. Charset:sub(RandIndex, RandIndex)
    end
    return Result
end

local ConfigFilePath = Configurations .. "UI.json"
if not isfile(ConfigFilePath) then
    SafeWriteFile(ConfigFilePath, HttpService:JSONEncode(Configuration))
else
    local Content = SafeReadFile(ConfigFilePath)
    if Content then
        local Success, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
        if Success then
            Configuration = Decoded

            if not Configuration.Keybinds then
                Configuration.Keybinds = {}
                SafeWriteFile(ConfigFilePath, HttpService:JSONEncode(Configuration))
            end
        end
    end
end

local function SaveConfiguration()
    SafeMakeFolder(Configurations)
    SafeWriteFile(Configurations .. "UI.json", HttpService:JSONEncode(Configuration))
end

local Nazuro = {
    Theme = {
        Dark = {
            TextColor = Color3.fromRGB(240, 240, 240),
            MainColor = Color3.fromRGB(16, 16, 16),
            SecondaryColor = Color3.fromRGB(22, 22, 22),
            NotificationActionsBackground = Color3.fromRGB(230, 230, 230),
            ImageColor = Color3.fromRGB(255, 255, 255),
            TabBackground = Color3.fromRGB(80, 80, 80),
            TabStroke = Color3.fromRGB(85, 85, 85),
            TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
            TabTextColor = Color3.fromRGB(240, 240, 240),
            SelectedTabTextColor = Color3.fromRGB(50, 50, 50),
            SliderColor = Color3.fromRGB(255, 255, 255),
            ToggleEnabled = Color3.fromRGB(255, 255, 255),
            ToggleDisabled = Color3.fromRGB(139, 139, 139),
            CardButton = Color3.fromRGB(230, 230, 230),
            TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint)
        }
    }
}

local RandomId = tostring(math.random(1, 100)) .. tostring(math.random(1, 50)) .. tostring(math.random(1, 100))

function Nazuro:DragFunc(Dragger, Target)
    Target = Target or Dragger
    local Dragging = false
    local DragInput, DragStart, StartPos
    
    Dragger.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPos = Target.Position
            
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    Dragger.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            DragInput = Input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Target.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
end

-- Import UI
local UIInstance 
if RunService:IsStudio() then
    UIInstance = CoreGui:WaitForChild("UI_Library")
else
    UIInstance = game:GetObjects("rbxassetid://129033108166316")[1] -- Replace with your own asset ID
end

UIInstance.Name = GenerateString()
UIInstance.Enabled = false
UIInstance.IgnoreGuiInset = false
UIInstance.Parent = CoreGui

if gethui then
    UIInstance.Parent = gethui()
elseif CoreGui:FindFirstChild("RobloxGui") then
    UIInstance.Parent = CoreGui:FindFirstChild("RobloxGui")
else
    UIInstance.Parent = CoreGui
end

function Nazuro:ToggleUI(State)
    UIInstance.Main.Visible = State or not UIInstance.Main.Visible
end

function Nazuro:GetUIInstance()
    return UIInstance
end

function Nazuro:CreateMobileButton()
    local Circle = UIInstance.MobileCircle
    Circle.Visible = true

    Circle.MouseButton1Click:Connect(function()
        Nazuro:ToggleUI()
    end)

    Nazuro:DragFunc(Circle, UIInstance.Main)
end

function Nazuro:Notify(Title, NotificationData)
    task.spawn(function()
        local Duration = NotificationData.Duration or DefaultDuration
        local Notification = UIInstance.Notifications[Title]:Clone()
        Notification.Parent = UIInstance.Notifications
        Notification.Name = NotificationData.Title or "Unknown Title"
        Notification.Parent = UIInstance.Notifications
        Notification.Visible = true
        Notification.Actions.ButtonTemplate.Visible = false
        
        if NotificationData.Actions then
            for ActionName, ActionData in next, NotificationData.Actions do
                local ActionButton = Notification.Actions.ButtonTemplate:Clone()
                ActionButton.Name = ActionData.Name
                ActionButton.Visible = true
                ActionButton.Parent = Notification.Actions
                ActionButton.Text = ActionData.Name
                ActionButton.Size = UDim2.new(0, ActionButton.TextBounds.X + 27, 1, 0)
                ActionButton.MouseButton1Click:Connect(function()
                    local Success, Error = pcall(ActionData.Callback)
                    Duration = 0
                end)
            end
        end
        
        Notification.Title.Text = NotificationData.Title or "Unknown"
        Notification.Description.Text = NotificationData.Content or "Unknown"
        
        if NotificationData.Image then
            Notification.Icon.Image = NotificationData.Image
        end
        
        while Duration >= 0 do
            Notification.Duration.Text = Duration
            task.wait(1)
            Duration = Duration - 1
        end
        Notification:Destroy()
    end)
end

function Nazuro:CreateLibrary(LibraryData, Icon)
    local Library = {
        Name = typeof(LibraryData) == "table" and LibraryData.Name or (typeof(LibraryData) == "string" and LibraryData or "Nazuro"),
        Icon = typeof(LibraryData) == "table" and LibraryData.Icon or Icon
    }
    
    local SideBar = UIInstance.Main.SideBar
    local Buttons = SideBar.Buttons
    local TabContainer = UIInstance.Main.TabContainer
    
    SideBar.NameText.Text = Library.Name
    UIInstance.Main.Profile.Image = Profile
    Buttons.Template.Visible = false
    
    Nazuro:DragFunc(SideBar, UIInstance.Main)
    Nazuro:DragFunc(UIInstance.Main.Title, UIInstance.Main)

    function Nazuro:SwitchTo(Tab)
        if TabContainer:FindFirstChild(Tab) then
            TabContainer.UIPageLayout:JumpTo(TabContainer:FindFirstChild(Tab))
        end
    end

    Buttons.Parent.Minimize.MouseButton1Click:Connect(function()
        if TabContainer:FindFirstChild("Settings") then
            TabContainer.UIPageLayout:JumpTo(TabContainer:FindFirstChild("Settings"))
        end
    end)

    UIInstance.Enabled = true

    local LibraryFunctions = {}
    
    function LibraryFunctions:Notify(NotificationData, Content, Duration, Actions)
        task.spawn(function()
            UIInstance.Main.Notifications.Visible = true
            local Duration = typeof(NotificationData) == "table" and NotificationData.Duration or Duration or DefaultDuration
            local Notification = UIInstance.Main.Notifications.Template
            Notification.Parent = UIInstance.Notifications
            Notification.Duration.Text = Duration
            Notification.Parent = UIInstance.Main.Notifications
            Notification.Visible = true
            
            for _, Child in next, Notification.Actions:GetChildren() do
                if Child.Name ~= "ButtonTemplate" and not Child:IsA("UIListLayout") then
                    Child:Destroy()
                end
            end
            
            Notification.Actions.ButtonTemplate.Visible = false
            
            if typeof(NotificationData) == "table" and NotificationData.Actions or Actions then
                for ActionName, ActionData in next, (typeof(NotificationData) == "table" and NotificationData.Actions or Actions) do
                    local ActionButton = Notification.Actions.ButtonTemplate:Clone()
                    ActionButton.Name = ActionData.Name
                    ActionButton.Visible = true
                    ActionButton.Parent = Notification.Actions
                    ActionButton.Text = ActionData.Name
                    ActionButton.Size = UDim2.new(0, ActionButton.TextBounds.X + 27, 1, 0)
                    ActionButton.MouseButton1Click:Connect(function()
                        local Success, Error = pcall(ActionData.Callback)
                    end)
                end
            end
            
            Notification.Title.Text = typeof(NotificationData) == "table" and NotificationData.Title or NotificationData or "Unknown"
            Notification.Description.Text = typeof(NotificationData) == "table" and NotificationData.Content or Content or "Unknown"
            
            while Duration >= 0 do
                Notification.Duration.Text = Duration
                task.wait(1)
                Duration = Duration - 1
            end
            
            UIInstance.Main.Notifications.Visible = false
            for _, Child in next, Notification.Actions:GetChildren() do
                if Child.Name ~= "ButtonTemplate" and not Child:IsA("UIListLayout") then
                    Child:Destroy()
                end
            end
        end)
    end
    
    task.spawn(function()
        if IsOnMobile and not IsOnEmulator then
            local MobileButton = UIInstance.MobileCircle
            MobileButton.MouseButton1Click:Connect(function()
                Nazuro:ToggleUI()
            end)
            Nazuro:DragFunc(MobileButton)
            MobileButton.Visible = true
        end
    end)
    
    function LibraryFunctions:CreateTab(TabData, Icon)
        if not TabData then
            return
        end

        local TabInstance

        if TabData ~= "Settings" then
            local TabButton = Buttons.Template:Clone()
            TabButton.ImageLabel.Image = typeof(TabData) == "table" and TabData.Icon or Icon or "rbxassetid://11432859220"
            TabButton.ImageLabel.BackgroundTransparency = 1
            TabButton.BackgroundTransparency = 1
            TabButton.TextLabel.Text = typeof(TabData) == "table" and TabData.Title or TabData or "Unknown"
            TabButton.Visible = true
            TabButton.Parent = Buttons
            
            TabInstance = TabContainer.Template:Clone()
            TabContainer.Template.Visible = false
            TabInstance.Parent = TabContainer
            TabInstance.Name = typeof(TabData) == "table" and TabData.Title or TabData or "Unknown"
            TabInstance.Visible = true
            TabInstance.LayoutOrder = #TabContainer:GetChildren()
            
            for _, Child in next, TabInstance:GetChildren() do
                if Child.ClassName == "Frame" then
                    Child:Destroy()
                end
            end
            
            TabButton.MouseButton1Click:Connect(function()
                if TabContainer.UIPageLayout.CurrentPage ~= TabInstance then
                    TabContainer.UIPageLayout:JumpTo(TabInstance)
                end
            end)
        else
            TabInstance = TabContainer.Template:Clone()
            TabContainer.Template.Visible = false
            TabInstance.Parent = TabContainer
            TabInstance.Name = typeof(TabData) == "table" and TabData.Title or TabData or "Unknown"
            TabInstance.Visible = true
            TabInstance.LayoutOrder = #TabContainer:GetChildren()
            
            for _, Child in next, TabInstance:GetChildren() do
                if Child.ClassName == "Frame" then
                    Child:Destroy()
                end
            end
        end

        if TabData == "Main" then
            TabContainer.UIPageLayout:JumpTo(TabInstance)
        end

        local TabFunctions = {}
        
        function TabFunctions:CreateSection(SectionName, SectionType)
            local SectionFunctions = {}
            local SectionInstance
            
            if SectionType == "Normal" then
                SectionInstance = TabContainer.Template.SectionTitle:Clone()
                SectionInstance.Name = SectionName
                SectionInstance.Title.Text = SectionName
                SectionInstance.Visible = true
                SectionInstance.Parent = TabInstance
            elseif SectionType == "Foldable" then
                SectionInstance = TabContainer.Template.FoldableSectionTitle:Clone()
                SectionInstance.Name = SectionName
                SectionInstance.Title.Text = SectionName
                SectionInstance.Visible = true
                SectionInstance.Parent = TabInstance
            end
            
            SectionInstance.Title.TextTransparency = 1
            TweenService:Create(SectionInstance.Title, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
                TextTransparency = 0
            }):Play()
            
            function SectionFunctions:SetName(NewName)
                SectionInstance.Title.Text = NewName
            end
            
            local function UpdateSize()
                local ContentSize = SectionInstance.UIListLayout.AbsoluteContentSize
                local ScaleFactor = 1

                local UIScale = SectionInstance:FindFirstChild("UIScale")
                if UIScale then
                    ScaleFactor = UIScale.Scale
                end

                SectionInstance.Size = UDim2.new(1, 0, 0, ContentSize.Y * ScaleFactor)
            end
            
            if SectionType == "Foldable" then
                local IsExpanded = true
                SectionInstance.Title.TextButton.MouseButton1Click:Connect(function()
                    if IsExpanded then
                        IsExpanded = false
                        for _, Child in next, SectionInstance:GetChildren() do
                            if Child.Name ~= "UIListLayout" and Child.Name ~= "UIPadding" and not Child:IsA("TextLabel") then
                                Child.Visible = false
                            end
                        end
                    else
                        IsExpanded = true
                        for _, Child in next, SectionInstance:GetChildren() do
                            if Child.Name ~= "UIListLayout" and Child.Name ~= "UIPadding" and not Child:IsA("TextLabel") then
                                Child.Visible = true
                            end
                        end
                    end
                    UpdateSize()
                end)
            end

            function SectionFunctions:Remove()
                if SectionInstance then
                    SectionInstance:Destroy()
                    SectionInstance = nil
                end
            end

            function SectionFunctions:CreateButton(ButtonData)
                local ButtonFunctions = {
                    Callback = ButtonData.Callback
                }
                
                local ButtonInstance = TabContainer.Template.Button:Clone()
                ButtonInstance.Name = ButtonData.Name or "Undefined"
                ButtonInstance.Title.Text = ButtonData.Name or "Undefined"
                ButtonInstance.Icon.Image = ButtonData.Icon or "rbxassetid://3944703587"
                ButtonInstance.Visible = true
                ButtonInstance.Parent = SectionInstance

                UpdateSize()
                
                ButtonInstance.Interact.MouseButton1Click:Connect(function()
                    local Success, Error = pcall(ButtonFunctions.Callback)
                    if not Success then
                        local OriginalSize = ButtonInstance.Size
                        TweenService:Create(ButtonInstance, Nazuro.Theme.Dark.TweenInfo, {
                            Size = UDim2.new(0.992, -10, 0, 35)
                        }):Play()
                        TweenService:Create(ButtonInstance, Nazuro.Theme.Dark.TweenInfo, {
                            BackgroundColor3 = Color3.fromRGB(103, 0, 0)
                        }):Play()
                        ButtonInstance.Title.Text = "Something failed on our end"
                        warn("[Nazuro]: An error occurred: " .. tostring(Error))
                        task.wait(0.5)
                        ButtonInstance.Title.Text = ButtonData.Name
                        TweenService:Create(ButtonInstance, Nazuro.Theme.Dark.TweenInfo, {
                            Size = OriginalSize
                        }):Play()
                        TweenService:Create(ButtonInstance, Nazuro.Theme.Dark.TweenInfo, {
                            BackgroundColor3 = Nazuro.Theme.Dark.SecondaryColor
                        }):Play()
                    else
                        local OriginalSize = ButtonInstance.Size
                        TweenService:Create(ButtonInstance, Nazuro.Theme.Dark.TweenInfo, {
                            Size = UDim2.new(0.992, -10, 0, 35)
                        }):Play()
                        task.wait(0.2)
                        TweenService:Create(ButtonInstance, Nazuro.Theme.Dark.TweenInfo, {
                            Size = OriginalSize
                        }):Play()
                    end
                end)
                
                function ButtonFunctions:SetCallback(NewCallback)
                    ButtonFunctions.Callback = NewCallback
                end

                function ButtonFunctions:Remove()
                    ButtonInstance:Destroy()
                    UpdateSize()
                end

                function ButtonFunctions:SetName(NewName)
                    ButtonInstance.Title.Text = NewName
                    ButtonInstance.Name = NewName
                end
                
                return ButtonFunctions
            end

            function SectionFunctions:CreateToggle(ToggleType, ToggleData)
                local ToggleFunctions = {}
                local ToggleInstance = (ToggleType == "Radio" and TabContainer.Template.Toggle_Radio:Clone() or TabContainer.Template.Toggle:Clone())
                local ToggleInteract = ToggleInstance.Interact
                local ToggleSwitch = ToggleInstance.Switch
                local ToggleIndicator = ToggleSwitch.Indicator
                local Flag = ToggleData.Flag
                local CurrentValue = Flag and Configuration.Toggles[Flag] or ToggleData.CurrentValue

                if Flag and not Configuration.Toggles[Flag] then
                    Configuration.Toggles[Flag] = ToggleData.CurrentValue
                    SaveConfiguration()
                end

                local function SetToggle(Value)
                    if Flag then
                        Configuration.Toggles[Flag] = Value
                        SaveConfiguration()
                    end
                    CurrentValue = Value

                    if ToggleType == "Radio" then
                        TweenService:Create(ToggleIndicator, Nazuro.Theme.Dark.TweenInfo, {
                            BackgroundTransparency = Value and 0 or 1
                        }):Play()
                    elseif ToggleType == "Normal" then
                        TweenService:Create(ToggleIndicator, Nazuro.Theme.Dark.TweenInfo, {
                            BackgroundColor3 = Value and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(139, 139, 139)
                        }):Play()
                        TweenService:Create(ToggleIndicator, Nazuro.Theme.Dark.TweenInfo, {
                            Position = Value and UDim2.new(0.537, 0, 0.5, 0) or UDim2.new(0.07, 0, 0.5, 0)
                        }):Play()
                    end

                    local Success, Error = pcall(function()
                        task.spawn(function()
                            ToggleData.Callback(Value)
                        end)
                    end)
                    
                    if not Success then
                        TweenService:Create(ToggleInstance, Nazuro.Theme.Dark.TweenInfo, {
                            BackgroundColor3 = Color3.fromRGB(103, 0, 0)
                        }):Play()
                        ToggleInstance.Title.Text = "Something failed on our end"
                        warn("[Nazuro]: An error occurred: " .. tostring(Error))
                        task.wait(0.5)
                        ToggleInstance.Title.Text = ToggleData.Name
                        TweenService:Create(ToggleInstance, Nazuro.Theme.Dark.TweenInfo, {
                            BackgroundColor3 = Nazuro.Theme.Dark.SecondaryColor
                        }):Play()
                    end
                end

                if ToggleType == "Radio" then
                    ToggleIndicator.BackgroundTransparency = 1
                    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    ToggleInstance.Name = ToggleData.Name
                    ToggleInstance.Title.Text = ToggleData.Name
                    ToggleInstance.Visible = true
                    ToggleInstance.Parent = SectionInstance
                    if InitialValue then
                        SetToggle(InitialValue)
                    end
                    UpdateSize()
                    ToggleInstance.Interact.MouseButton1Click:Connect(function()
                        SetToggle(not CurrentValue)
                    end)
                    ToggleData.SetToggle = SetToggle
                    return ToggleData
                elseif ToggleType == "Normal" then
                    ToggleInstance.Name = ToggleData.Name
                    ToggleInstance.Title.Text = ToggleData.Name
                    ToggleInstance.Visible = true
                    ToggleInstance.Parent = SectionInstance
                    if InitialValue then
                        SetToggle(InitialValue)
                    end
                    UpdateSize()
                    ToggleInstance.Interact.MouseButton1Click:Connect(function()
                        SetToggle(not CurrentValue)
                    end)
                    ToggleData.SetToggle = SetToggle
                    return ToggleData
                end
            end

            function SectionFunctions:CreateKeybind(KeybindData)
                local Name = KeybindData.Name
                local Callback = KeybindData.Callback
                local Type = KeybindData.Type
                local Flag = KeybindData.Flag
                local CurrentKeybind = Flag and Configuration.Toggles[Flag] or KeybindData.Keybind or "..."

                local KeybindState = {
                    MouseDown = false,
                    Deciding = false,
                    Enabled = false,
                }

                if Flag and not Configuration.Keybinds[Flag] then
                    Configuration.Keybinds[Flag] = KeybindData.Flag
                    SaveConfiguration()
                end

                local KeybindInstance = TabContainer.Template.Keybind:Clone()
                KeybindInstance.Name = Name 
                KeybindInstance.Title.Text = Name
                KeybindInstance.KeybindFrame.KeybindBox.Text = CurrentKeybind 

                KeybindInstance.KeybindFrame.KeybindBox.MouseButton1Click:Connect(function()
                    KeybindState.MouseDown = true
                    KeybindState.Deciding = true
                    KeybindInstance.KeybindFrame.KeybindBox.Text = "..."

                    local EndedInput
                    repeat
                        EndedInput = UserInputService.InputEnded:Wait()
                    until EndedInput.UserInputType == Enum.UserInputType.Keyboard or EndedInput.UserInputType == Enum.UserInputType.Touch

                    if KeybindState.MouseDown then
                        KeybindState.Deciding = false
                        KeybindState.Hover = false
                        KeybindState.MouseDown = false

                        if EndedInput.UserInputType == Enum.UserInputType.MouseButton1 or EndedInput.UserInputType == Enum.UserInputType.Touch then
                            KeybindInstance.KeybindFrame.KeybindBox.Text = CurrentKeybind
                        else
                            CurrentKeybind = EndedInput.KeyCode.Name
                            KeybindInstance.KeybindFrame.KeybindBox.Text = CurrentKeybind
                        end

                        if Flag then
                            Configuration.Keybinds[Flag] = CurrentKeybind
                            SaveConfiguration()
                        end
                    end
                end)

                if Type == "Press" then
                    UserInputService.InputBegan:Connect(function(Input)
                        if CurrentKeybind == "..." then return end
                        if Input.KeyCode == Enum.KeyCode[CurrentKeybind] then
                            KeybindState.Enabled = not KeybindState.Enabled

                            task.spawn(function()
                                Callback(KeybindState.Enabled)
                            end)
                        end
                    end)
                end

                if Type == "Hold" then
                    UserInputService.InputBegan:Connect(function(Input)
                        if CurrentKeybind == "..." then return end
                        if Input.KeyCode == Enum.KeyCode[CurrentKeybind] then
                            KeybindState.Enabled = true
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(Input)
                        if CurrentKeybind == "..." then return end
                        if Input.KeyCode == Enum.KeyCode[CurrentKeybind] then
                            KeybindState.Enabled = false
                        end
                    end)

                    RunService.RenderStepped:Connect(function()
                        if KeybindState.Enabled then
                            task.spawn(function()
                                Callback(true)
                            end)
                        end
                    end)
                end

                KeybindInstance.Visible = true
                KeybindInstance.Parent = SectionInstance
                UpdateSize()
            end

            function SectionFunctions:CreateSlider(SliderData)
                local Sliding = false
                local SliderInstance = TabContainer.Template.Slider:Clone()
                local Flag = SliderData.Flag
                local CurrentValue = Flag and Configuration.Sliders[Flag] or SliderData.CurrentValue

                if Flag and Configuration.Sliders[Flag] then
                    pcall(function()
                        SliderData.Callback(CurrentValue)
                    end)
                end

                SliderInstance.Name = SliderData.Name
                SliderInstance.Title.Text = SliderData.Name
                SliderInstance.Title.TextScaled = false
                SliderInstance.Visible = true
                SliderInstance.Parent = SectionInstance
                UpdateSize()
                
                SliderInstance.Main.Progress.Size = UDim2.new(0, SliderInstance.Main.AbsoluteSize.X * (CurrentValue + SliderData.Value[1]) / (SliderData.Value[2] - SliderData.Value[1]) > 5 and SliderInstance.Main.AbsoluteSize.X * CurrentValue / (SliderData.Value[2] - SliderData.Value[1]) or 5, 1, 0)
                
                if not SliderData.Suffix then
                    SliderInstance.Main.Information.Text = tostring(CurrentValue)
                else
                    SliderInstance.Main.Information.Text = tostring(CurrentValue) .. " " .. SliderData.Suffix
                end
                
                SliderInstance.Main.Interact.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = true
                    end
                end)
                
                SliderInstance.Main.Interact.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Sliding = false
                    end
                end)
                
                SliderInstance.Main.Interact.MouseButton1Down:Connect(function()
                    local ProgressStart = SliderInstance.Main.Progress.AbsolutePosition.X + SliderInstance.Main.Progress.AbsoluteSize.X
                    local ProgressEnd = ProgressStart
                    local MouseX = Mouse.X
                    local Connection
                    
                    Connection = RunService.Stepped:Connect(function()
                        if Sliding then
                            MouseX = UserInputService:GetMouseLocation().X
                            ProgressEnd = MouseX
                            
                            if MouseX < SliderInstance.Main.AbsolutePosition.X then
                                MouseX = SliderInstance.Main.AbsolutePosition.X
                            elseif MouseX > SliderInstance.Main.AbsolutePosition.X + SliderInstance.Main.AbsoluteSize.X then
                                MouseX = SliderInstance.Main.AbsolutePosition.X + SliderInstance.Main.AbsoluteSize.X
                            end
                            
                            if ProgressEnd < SliderInstance.Main.AbsolutePosition.X + 5 then
                                ProgressEnd = SliderInstance.Main.AbsolutePosition.X + 5
                            elseif ProgressEnd > SliderInstance.Main.AbsolutePosition.X + SliderInstance.Main.AbsoluteSize.X then
                                ProgressEnd = SliderInstance.Main.AbsolutePosition.X + SliderInstance.Main.AbsoluteSize.X
                            end
                            
                            if ProgressEnd <= MouseX and MouseX - ProgressStart < 0 then
                                ProgressStart = MouseX
                            elseif ProgressEnd >= MouseX and MouseX - ProgressStart > 0 then
                                ProgressStart = MouseX
                            end
                            
                            SliderInstance.Main.Progress.Size = UDim2.new(0, ProgressEnd - SliderInstance.Main.AbsolutePosition.X, 1, 0)
                            
                            local Value = SliderData.Value[1] + (MouseX - SliderInstance.Main.AbsolutePosition.X) / SliderInstance.Main.AbsoluteSize.X * (SliderData.Value[2] - SliderData.Value[1])
                            Value = math.floor(Value / SliderData.Increment + 0.5) * SliderData.Increment * 10000000 / 10000000
                            
                            if not SliderData.Suffix then
                                SliderInstance.Main.Information.Text = tostring(Value)
                            else
                                SliderInstance.Main.Information.Text = tostring(Value) .. " " .. SliderData.Suffix
                            end
                            
                            if CurrentValue ~= Value then
                                if Flag then
                                    Configuration.Sliders[Flag] = Value
                                    SaveConfiguration()
                                end
                                
                                local Success, Error = pcall(function()
                                    SliderData.Callback(Value)
                                end)
                                CurrentValue = Value
                            end
                        else
                            SliderInstance.Main.Progress.Size = UDim2.new(0, MouseX - SliderInstance.Main.AbsolutePosition.X > 5 and MouseX - SliderInstance.Main.AbsolutePosition.X or 5, 1, 0)
                            Connection:Disconnect()
                        end
                    end)
                end)
                
                function SliderData:Set(Value)
                    SliderInstance.Main.Progress.Size = UDim2.new(0, SliderInstance.Main.AbsoluteSize.X * (Value + SliderData.Value[1]) / (SliderData.Value[2] - SliderData.Value[1]) > 5 and SliderInstance.Main.AbsoluteSize.X * Value / (SliderData.Value[2] - SliderData.Value[1]) or 5, 1, 0)
                    SliderInstance.Main.Information.Text = tostring(Value) .. " " .. SliderData.Suffix
                    local Success, Error = pcall(function()
                        SliderData.Callback(Value)
                    end)
                    CurrentValue = Value
                    if Flag then
                        Configuration.Sliders[Flag] = CurrentValue
                        SaveConfiguration()
                    end
                end
                
                return SliderData
            end

            function SectionFunctions:CreateDropdown(DropdownData)
                local DropdownInstance = TabContainer.Template.Dropdown:Clone()
                local Flag = DropdownData.Flag
                local CurrentOption = Flag and Configuration.Dropdowns[Flag] or DropdownData.CurrentOption

                if Flag then
                    task.spawn(function()
                        local Success, Error = pcall(function()
                            DropdownData.Callback(DropdownData.MultipleOptions == false and CurrentOption[1] or CurrentOption)
                        end)    
                    end)
                end

                if string.find(DropdownData.Name, "closed") then
                    DropdownInstance.Name = "Dropdown"
                else
                    DropdownInstance.Name = DropdownData.Name
                end
                
                DropdownInstance.Title.Text = DropdownData.Name
                DropdownInstance.Visible = true
                DropdownInstance.Parent = SectionInstance
                DropdownInstance.Size = UDim2.new(1, 0, 0, 45)
                DropdownInstance.Interact.Size = UDim2.new(0, 429, 0, 45)
                DropdownInstance.Interact.Position = UDim2.new(0, 214, 0, 22)
                DropdownInstance.List.Visible = false
                
                if typeof(CurrentOption) == "string" then
                    CurrentOption = { CurrentOption }
                end
                
                if not DropdownData.MultipleOptions then
                    CurrentOption = { CurrentOption[1] }
                end
                
                if DropdownData.MultipleOptions then
                    if #CurrentOption == 1 then
                        DropdownInstance.Selected.Text = CurrentOption[1]
                    elseif #CurrentOption == 0 then
                        DropdownInstance.Selected.Text = "None"
                    else
                        DropdownInstance.Selected.Text = #CurrentOption .. " item" .. (#CurrentOption > 1 and "s" or "")
                    end
                else
                    DropdownInstance.Selected.Text = CurrentOption[1]
                end

                DropdownInstance.BackgroundTransparency = 1
                DropdownInstance.UIStroke.Transparency = 1
                DropdownInstance.Title.TextTransparency = 1
                DropdownInstance.Size = UDim2.new(1, 0, 0, 45)
                UpdateSize()
                
                TweenService:Create(DropdownInstance, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
                    BackgroundTransparency = 0.75
                }):Play()
                TweenService:Create(DropdownInstance.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
                    Transparency = 0
                }):Play()
                TweenService:Create(DropdownInstance.Title, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
                    TextTransparency = 0
                }):Play()
                
                for _, Child in next, DropdownInstance.List:GetChildren() do
                    if Child.ClassName == "Frame" and Child.Name ~= "Placeholder" then
                        Child:Destroy()
                    end
                end
                
                DropdownInstance.Toggle.Rotation = 180
                local Debounce = false
                
                DropdownInstance.Interact.MouseButton1Click:Connect(function()
                    TweenService:Create(DropdownInstance.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
                        Transparency = 1
                    }):Play()
                    task.wait(0.1)
                    TweenService:Create(DropdownInstance.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {
                        Transparency = 0
                    }):Play()
                    
                    if Debounce then
                        return
                    end
                    
                    if DropdownInstance.List.Visible then
                        Debounce = true
                        local Tween = TweenService:Create(DropdownInstance, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                            Size = UDim2.new(1, 0, 0, 45)
                        })
                        
                        local Success = pcall(function()
                            Tween:Play()
                        end)
                        
                        local Updating = false
                        if Success then
                            Updating = true
                        end
                        
                        task.spawn(function()
                            while Updating do
                                UpdateSize()
                                task.wait()
                            end
                        end)
                        
                        Tween.Completed:Connect(function()
                            Updating = false
                        end)
                        
                        for _, Option in next, DropdownInstance.List:GetChildren() do
                            if Option.ClassName == "Frame" and Option.Name ~= "Placeholder" and not Option:IsA("TextLabel") then
                                TweenService:Create(Option, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                    BackgroundTransparency = 1
                                }):Play()
                                TweenService:Create(Option.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                    Transparency = 1
                                }):Play()
                                TweenService:Create(Option.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                    TextTransparency = 1
                                }):Play()
                            end
                        end
                        
                        TweenService:Create(DropdownInstance.List, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                            ScrollBarImageTransparency = 1
                        }):Play()
                        TweenService:Create(DropdownInstance.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
                            Rotation = 180
                        }):Play()
                        
                        task.wait(0.35)
                        DropdownInstance.List.Visible = false
                        Debounce = false
                    else
                        local Tween = TweenService:Create(DropdownInstance, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                            Size = UDim2.new(1, 0, 0, 180)
                        })
                        
                        local Success = pcall(function()
                            Tween:Play()
                        end)
                        
                        local Updating = false
                        if Success then
                            Updating = true
                        end
                        
                        task.spawn(function()
                            while Updating do
                                UpdateSize()
                                task.wait()
                            end
                        end)
                        
                        Tween.Completed:Connect(function()
                            Updating = false
                        end)
                        
                        DropdownInstance.List.Visible = true
                        TweenService:Create(DropdownInstance.List, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                            ScrollBarImageTransparency = 0.7
                        }):Play()
                        TweenService:Create(DropdownInstance.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
                            Rotation = 0
                        }):Play()
                        
                        for _, Option in next, DropdownInstance.List:GetChildren() do
                            if Option.ClassName == "Frame" and Option.Name ~= "Placeholder" and not Option:IsA("TextLabel") then
                                TweenService:Create(Option, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                    BackgroundTransparency = 0
                                }):Play()
                                TweenService:Create(Option.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                    Transparency = 0
                                }):Play()
                                TweenService:Create(Option.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                    TextTransparency = 0
                                }):Play()
                            end
                        end
                    end
                end)
                
                for _, Option in next, DropdownData.Options do
                    local OptionInstance = TabContainer.Template.Dropdown.List.Template:Clone()
                    OptionInstance.Name = Option
                    OptionInstance.Title.Text = Option
                    OptionInstance.Parent = DropdownInstance.List
                    OptionInstance.Visible = true

                    if CurrentOption == Option then
                        OptionInstance.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    end
                    
                    OptionInstance.MouseEnter:Connect(function()
                        TweenService:Create(OptionInstance, Nazuro.Theme.Dark.TweenInfo, {
                            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        }):Play()
                        TweenService:Create(OptionInstance, Nazuro.Theme.Dark.TweenInfo, {
                            Size = UDim2.new(0.921, 0, 0, 38)
                        }):Play()
                    end)
                    
                    OptionInstance.MouseLeave:Connect(function()
                        TweenService:Create(OptionInstance, Nazuro.Theme.Dark.TweenInfo, {
                            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        }):Play()
                        TweenService:Create(OptionInstance, Nazuro.Theme.Dark.TweenInfo, {
                            Size = UDim2.new(0.921, 0, 0, 38)
                        }):Play()
                    end)
                    
                    OptionInstance.Interact.ZIndex = 50
                    OptionInstance.Interact.MouseButton1Click:Connect(function()
                        if not DropdownData.MultipleOptions and table.find(CurrentOption, Option) then
                            return
                        end
                        
                        if table.find(CurrentOption, Option) then
                            table.remove(CurrentOption, table.find(CurrentOption, Option))
                            if DropdownData.MultipleOptions then
                                if #CurrentOption == 1 then
                                    DropdownInstance.Selected.Text = CurrentOption[1]
                                elseif #CurrentOption == 0 then
                                    DropdownInstance.Selected.Text = "None"
                                else
                                    DropdownInstance.Selected.Text = #CurrentOption .. " item" .. (#CurrentOption > 1 and "s" or "")
                                end
                            else
                                DropdownInstance.Selected.Text = CurrentOption[1]
                            end
                        else
                            if not DropdownData.MultipleOptions then
                                table.clear(CurrentOption)
                            end
                            table.insert(CurrentOption, Option)
                            if DropdownData.MultipleOptions then
                                if #CurrentOption == 1 then
                                    DropdownInstance.Selected.Text = CurrentOption[1]
                                elseif #CurrentOption == 0 then
                                    DropdownInstance.Selected.Text = "None"
                                else
                                    DropdownInstance.Selected.Text = #CurrentOption .. " item" .. (#CurrentOption > 1 and "s" or "")
                                end
                            else
                                DropdownInstance.Selected.Text = CurrentOption[1]
                            end

                            local OriginalSize = OptionInstance.Size
                            TweenService:Create(OptionInstance, Nazuro.Theme.Dark.TweenInfo, {
                                Size = UDim2.new(0.875, 0, 0, 38)
                            }):Play()
                            TweenService:Create(OptionInstance, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                            }):Play()
                            Debounce = true
                            task.wait(0.2)
                            TweenService:Create(OptionInstance, Nazuro.Theme.Dark.TweenInfo, {
                                Size = OriginalSize
                            }):Play()
                        end

                        if Flag then
                            Configuration.Dropdowns[Flag] = DropdownData.MultipleOptions == false and CurrentOption[1] or CurrentOption
                            SaveConfiguration()    
                        end

                        local Success, Error = pcall(function()
                            DropdownData.Callback(DropdownData.MultipleOptions == false and CurrentOption[1] or CurrentOption)
                        end)
                        
                        for _, OtherOption in next, DropdownInstance.List:GetChildren() do
                            if OtherOption.ClassName == "Frame" and OtherOption.Name ~= "Placeholder" and not table.find(CurrentOption, OtherOption.Name) then
                                TweenService:Create(OtherOption, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                                }):Play()
                            end
                        end
                        
                        if not DropdownData.MultipleOptions then
                            task.wait(0.1)
                            local Tween = TweenService:Create(DropdownInstance, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {
                                Size = UDim2.new(1, 0, 0, 45)
                            })
                            
                            local Success = pcall(function()
                                Tween:Play()
                            end)
                            
                            local Updating = false
                            if Success then
                                Updating = true
                            end
                            
                            task.spawn(function()
                                while Updating do
                                    UpdateSize()
                                    task.wait()
                                end
                            end)
                            
                            Tween.Completed:Connect(function()
                                Updating = false
                            end)
                            
                            for _, Option in next, DropdownInstance.List:GetChildren() do
                                if Option.ClassName == "Frame" and Option.Name ~= "Placeholder" then
                                    TweenService:Create(Option, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                        BackgroundTransparency = 1
                                    }):Play()
                                    TweenService:Create(Option.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                        Transparency = 1
                                    }):Play()
                                    TweenService:Create(Option.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                        TextTransparency = 1
                                    }):Play()
                                end
                            end
                            
                            TweenService:Create(DropdownInstance.List, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                                ScrollBarImageTransparency = 1
                            }):Play()
                            TweenService:Create(DropdownInstance.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {
                                Rotation = 180
                            }):Play()
                            
                            task.wait(0.35)
                            DropdownInstance.List.Visible = false
                        end
                        Debounce = false
                    end)
                end
                
                for _, Option in next, DropdownInstance.List:GetChildren() do
                    if Option.ClassName == "Frame" and Option.Name ~= "Placeholder" then
                        if not table.find(CurrentOption, Option.Name) then
                            Option.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        else
                            Option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        end
                    end
                end
                
                function DropdownData:Set(NewOption)
                    CurrentOption = NewOption
                    if typeof(CurrentOption) == "string" then
                        CurrentOption = { CurrentOption }
                    end
                    
                    if not DropdownData.MultipleOptions then
                        CurrentOption = { CurrentOption[1] }
                    end
                    
                    if DropdownData.MultipleOptions then
                        if #CurrentOption == 1 then
                            DropdownInstance.Selected.Text = CurrentOption[1]
                        elseif #CurrentOption == 0 then
                            DropdownInstance.Selected.Text = "None"
                        else
                            DropdownInstance.Selected.Text = #CurrentOption .. " item" .. (#CurrentOption > 1 and "s" or "")
                        end
                    else
                        DropdownInstance.Selected.Text = CurrentOption[1]
                    end

                    local Success, Error = pcall(function()
                        DropdownData.Callback(NewOption)
                    end)
                    
                    for _, Option in next, DropdownInstance.List:GetChildren() do
                        if Option.ClassName == "Frame" and Option.Name ~= "Placeholder" then
                            if not table.find(CurrentOption, Option.Name) then
                                Option.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                            else
                                Option.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                            end
                        end
                    end

                    if Flag then
                        DropdownInstance.Selected.Text = CurrentOption[1]
                        Configuration.Dropdowns[Flag] = DropdownData.MultipleOptions == false and CurrentOption[1] or CurrentOption
                        local Success, Error = pcall(function()
                            DropdownData.Callback(DropdownData.MultipleOptions == false and CurrentOption[1] or CurrentOption)
                        end)
                    end
                end
                
                return DropdownData
            end

            function SectionFunctions:CreateTextbox(TextboxData)
                local TextboxInstance = TabContainer.Template.Input:Clone()
                TextboxInstance.Name = TextboxData.Name
                TextboxInstance.Title.Text = TextboxData.Name
                TextboxInstance.Visible = true
                TextboxInstance.Parent = SectionInstance

                local Flag = TextboxData.Flag
                local CurrentValue = Flag and Configuration.Inputs[Flag]

                if Flag and CurrentValue then
                    TextboxInstance.InputFrame.InputBox.Text = CurrentValue
                end

                UpdateSize()
                TextboxInstance.InputFrame.InputBox.PlaceholderText = TextboxData.PlaceholderText
                TextboxInstance.InputFrame.Size = UDim2.new(0, TextboxInstance.InputFrame.InputBox.TextBounds.X + 24, 0, 30)
                
                TextboxInstance.InputFrame.InputBox.FocusLost:Connect(function()
                    local Success, Error = pcall(function()
                        TextboxData.Callback(TextboxInstance.InputFrame.InputBox.Text)
                    end)

                    local InputText = TextboxInstance.InputFrame.InputBox.Text:gsub("%s+", "")
                    if InputText == "" then
                        return
                    end

                    if Flag then
                        Configuration.Inputs[Flag] = TextboxInstance.InputFrame.InputBox.Text
                        SaveConfiguration()
                    end

                    TextboxInstance.InputFrame.Size = UDim2.new(0, TextboxInstance.InputFrame.InputBox.TextBounds.X + 24, 0, 30)
                end)

                TextboxInstance.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    TweenService:Create(TextboxInstance.InputFrame, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, TextboxInstance.InputFrame.InputBox.TextBounds.X + 24, 0, 30)
                    }):Play()
                end)
                
                local TextboxFunctions = {}
                function TextboxFunctions:Set(Value)
                    TextboxInstance.InputFrame.InputBox.Text = Value

                    if Flag then
                        Configuration.Inputs[Flag] = Value
                        SaveConfiguration()
                    end
                end
                
                return TextboxFunctions
            end

            function SectionFunctions:CreateParagraph(ParagraphData)
                local ParagraphFunctions = {}

                local ParagraphInstance = TabContainer.Template.Paragraph:Clone()
                ParagraphInstance.Name = ParagraphData.Title

                ParagraphInstance.Paragraph.Title.RichText = true
                ParagraphInstance.Paragraph.Content.RichText = true

                ParagraphInstance.Paragraph.Title.Text = ParagraphData.Title
                ParagraphInstance.Paragraph.Content.Text = ParagraphData.Description

                ParagraphInstance.Visible = true
                ParagraphInstance.Parent = SectionInstance

                function ParagraphFunctions:ChangeText(Title, Content)
                    ParagraphInstance.Paragraph.Title.Text = Title
                    ParagraphInstance.Paragraph.Content.Text = Content
                    UpdateSize()
                end
                
                UpdateSize()
                return ParagraphFunctions
            end

            function SectionFunctions:CreateLabel(LabelData)
                local LabelInstance = TabContainer.Template.Label:Clone()
                LabelInstance.Name = LabelData.Description
                LabelInstance.Title.Text = LabelData.Description
                LabelInstance.ElementIndicator.Image = LabelData.Icon or LabelInstance.ElementIndicator.Image
                LabelInstance.Visible = true
                LabelInstance.Parent = SectionInstance

                local LabelFunctions = {}

                function LabelFunctions:ChangeText(Text)
                    LabelInstance.Title.Text = Text
                end

                UpdateSize()
                return LabelFunctions
            end

            function SectionFunctions:CreateDivider()
                local DividerInstance = TabContainer.Template.Divider:Clone()
                DividerInstance.Visible = true
                DividerInstance.Parent = SectionInstance
                UpdateSize()
            end

            return SectionFunctions
        end
        
        return TabFunctions
    end
    
    return LibraryFunctions
end

return Nazuro
