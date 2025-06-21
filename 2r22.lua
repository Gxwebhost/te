--!native
--!optimize 2

local game = game
local GetService = game.GetService

-- Roblox services
local UserInputService = GetService(game, "UserInputService")
local TweenService = GetService(game, "TweenService")
local HttpService = GetService(game, "HttpService")
local RunService = GetService(game, "RunService")
local Players = GetService(game, "Players")
local CoreGui = cloneref and cloneref(GetService(game, "CoreGui")) or GetService(game, "CoreGui")
local InsertService = GetService(game, "InsertService")

-- Player and input
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local IsOnMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, UserInputService:GetPlatform())
local IsOnEmulator = IsOnMobile and UserInputService.KeyboardEnabled

-- File handling stubs
local isfile = isfile or function() return true end
local isfolder = isfolder or function() return true end
local makefolder = makefolder or function() end
local writefile = writefile or function() end
local readfile = readfile or function() return nil end

-- Constants and configuration
local CONFIG_DIR = "Nazuro/Configurations/"
local ASSETS_DIR = "Nazuro/Assets/"
local DEFAULT_DURATION = 5
local Profile = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

-- Default configuration
local Configuration = {
	Toggles = {},
	Dropdowns = {},
	Sliders = {},
	Inputs = {},
	Keybinds = {},
}

-- File handling functions
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
	warn("File does not exist: " .. filepath)
	return nil
end

local function SafeHttpGet(url)
	local success, content = pcall(game.HttpGetAsync, game, url)
	if success then return content end
	warn("Failed to fetch URL: " .. url .. " | Error: " .. tostring(content))
	return nil
end

SafeMakeFolder("Nazuro")
SafeMakeFolder(CONFIG_DIR)
SafeMakeFolder(ASSETS_DIR)

-- Load or initialize configuration
local configFilePath = CONFIG_DIR .. "UI.json"
if not isfile(configFilePath) then
	SafeWriteFile(configFilePath, HttpService:JSONEncode(Configuration))
else
	local content = SafeReadFile(configFilePath)
	if content then
		local success, decoded = pcall(HttpService.JSONDecode, HttpService, content)
		if success then
			Configuration = decoded
			if not Configuration.Keybinds then
				Configuration.Keybinds = {}
				SafeWriteFile(configFilePath, HttpService:JSONEncode(Configuration))
			end
		end
	end
end

-- Save configuration
local function SaveConfiguration()
	SafeMakeFolder(CONFIG_DIR)
	SafeWriteFile(configFilePath, HttpService:JSONEncode(Configuration))
end

-- Generate random string
local function GenerateString()
	local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	local result = ""
	for _ = 1, 12 do
		local randIndex = math.random(1, #charset)
		result = result .. charset:sub(randIndex, randIndex)
	end
	return result
end

-- Theme configuration
local Nazuro = {
	Theme = {
		Dark = {
			TextColor = Color3.fromRGB(240, 240, 240),
			MainColor = Color3.fromRGB(16, 16, 16),
			SecondaryColor = Color3.fromRGB(22, 22, 22),
			NotificationBackground = Color3.fromRGB(230, 230, 230),
			ImageColor = Color3.fromRGB(255, 255, 255),
			TabBackground = Color3.fromRGB(80, 80, 80),
			TabStroke = Color3.fromRGB(85, 85, 85),
			TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
			TabTextColor = Color3.fromRGB(240, 240, 240),
			SelectedTabTextColor = Color3.fromRGB(50, 50, 50),
			SliderColor = Color3.fromRGB(255, 255, 255),
			ToggleEnabled = Color3.fromRGB(255, 255, 255),
			ToggleDisabled = Color3.fromRGB(139, 139, 139),
			TweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint)
		}
	}
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

-- Dragging functionality
function Nazuro:DragFunc(frame, target)
	target = target or frame
	local dragging = false
	local dragInput, dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if enter code hereinput.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Lua
Y)
		end
	end)
end

-- Load UI instance
local UI
if RunService:IsStudio() then
	UI = Player.PlayerGui:WaitForChild("UI_Library")
else
	UI = game:GetObjects("rbxassetid://129033108166316")[1] -- Replace with your asset ID
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

UI.Name = GenerateString()
UI.Enabled = false
UI.IgnoreGuiInset = false
UI.Parent = CoreGui

if gethui then
	UI.Parent = gethui()
elseif CoreGui:FindFirstChild("RobloxGui") then
	UI.Parent = CoreGui:FindFirstChild("RobloxGui")
else
	UI.Parent = CoreGui
local function Tween(obj, props, duration)
    local tweenInfo = TweenInfo.new(
        duration or Nazuro.Settings.TweenSpeed,
        Nazuro.Settings.EasingStyle
    )
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

-- Toggle UI visibility
function Nazuro:ToggleUI(state)
	UI.Main.Visible = state or not UI.Main.Visible
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

function Nazuro:GetUIInstance()
	return UI
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

-- Mobile button support
function Nazuro:CreateMobileButton()
	local circle = UI.MobileCircle
	circle.Visible = true
	circle.MouseButton1Click:Connect(function()
		Nazuro:ToggleUI()
	end)
	Nazuro:DragFunc(circle, UI.Main)
end

-- Notification system
function Nazuro:Notify(title, options)
	task.spawn(function()
		local duration = options.Duration or DEFAULT_DURATION
		local notification = UI.Notifications[title]:Clone()
		notification.Name = options.Title or "Unknown"
		notification.Parent = UI.Notifications
		notification.Visible = true
		notification.Actions.ButtonTemplate.Visible = false

		if options.Actions then
			for _, action in pairs(options.Actions) do
				local button = notification.Actions.ButtonTemplate:Clone()
				button.Name = action.Name
				button.Visible = true
				button.Parent = notification.Actions
				button.Text = action.Name
				button.Size = UDim2.new(0, button.TextBounds.X + 27, 1, 0)
				button.MouseButton1Click:Connect(function()
					local success, err = pcall(action.Callback)
					duration = 0
				end)
			end
		end

		notification.Title.Text = options.Title or "Unknown"
		notification.Description.Text = options.Content or "Unknown"
		if options.Image then
			notification.Icon.Image = options.Image
		end

		while duration >= 0 do
			notification.Duration.Text = duration
			task.wait(1)
			duration -= 1
		end
		notification:Destroy()
	end)
end

-- Main library creation
function Nazuro:CreateLibrary(config, icon)
	local library = {
		Name = typeof(config) == "table" and config.Name or (typeof(config) == "string" and config or "Nazuro"),
		Icon = typeof(config) == "table" and config.Icon or icon
	}
	local sidebar = UI.Main.SideBar
	local buttons = sidebar.Buttons
	local tabContainer = UI.Main.TabContainer

	sidebar.NameText.Text = library.Name
	UI.Main.Profile.Image = Profile
	buttons.Template.Visible = false
	Nazuro:DragFunc(sidebar, UI.Main)
	Nazuro:DragFunc(UI.Main.Title, UI.Main)

	function Nazuro:SwitchTo(tabName)
		if tabContainer:FindFirstChild(tabName) then
			tabContainer.UIPageLayout:JumpTo(tabContainer:FindFirstChild(tabName))
		end
	end

	buttons.Parent.Minimize.MouseButton1Click:Connect(function()
		if tabContainer:FindFirstChild("Settings") then
			tabContainer.UIPageLayout:JumpTo(tabContainer:FindFirstChild("Settings"))
		end
	end)

	UI.Enabled = true

	local lib = {}
	function lib:Notify(title, content, duration, actions)
		Nazuro:Notify(title, {
			Title = typeof(title) == "table" and title.Title or title,
			Content = typeof(title) == "table" and title.Content or content,
			Duration = typeof(title) == "table" and title.Duration or duration or DEFAULT_DURATION,
			Actions = typeof(title) == "table" and title.Actions or actions
		})
	end

	function lib:CreateTab(tabConfig, icon)
		if not tabConfig then return end
		local tab
		local tabButton

		if tabConfig ~= "Settings" then
			tabButton = buttons.Template:Clone()
			tabButton.ImageLabel.Image = typeof(tabConfig) == "table" and tabConfig.Icon or icon or "rbxassetid://11432859220"
			tabButton.ImageLabel.BackgroundTransparency = 1
			tabButton.BackgroundTransparency = 1
			tabButton.TextLabel.Text = typeof(tabConfig) == "table" and tabConfig.Title or tabConfig or "Unknown"
			tabButton.Visible = true
			tabButton.Parent = buttons

			tab = tabContainer.Template:Clone()
			tabContainer.Template.Visible = false
			tab.Parent = tabContainer
			tab.Name = typeof(tabConfig) == "table" and tabConfig.Title or tabConfig or "Unknown"
			tab.Visible = true
			tab.LayoutOrder = #tabContainer:GetChildren()

			for _, child in pairs(tab:GetChildren()) do
				if child.ClassName == "Frame" then
					child:Destroy()
				end
			end

			tabButton.MouseButton1Click:Connect(function()
				if tabContainer.UIPageLayout.CurrentPage ~= tab then
					tabContainer.UIPageLayout:JumpTo(tab)
				end
			end)
		else
			tab = tabContainer.Template:Clone()
			tabContainer.Template.Visible = false
			tab.Parent = tabContainer
			tab.Name = typeof(tabConfig) == "table" and tabConfig.Title or tabConfig or "Unknown"
			tab.Visible = true
			tab.LayoutOrder = #tabContainer:GetChildren()

			for _, child in pairs(tab:GetChildren()) do
				if child.ClassName == "Frame" then
					child:Destroy()
				end
			end
		end

		if tabConfig == "Main" then
			tabContainer.UIPageLayout:JumpTo(tab)
		end

		local tabObj = {}
		function tabObj:CreateSection(name, type)
			local sectionObj = {}
			local section

			if type == "Normal" then
				section = tabContainer.Template.SectionTitle:Clone()
				section.Name = name
				section.Title.Text = name
				section.Visible = true
				section.Parent = tab
			elseif type == "Foldable" then
				section = tabContainer.Template.FoldableSectionTitle:Clone()
				section.Name = name
				section.Title.Text = name
				section.Visible = true
				section.Parent = tab
			end

			section.Title.TextTransparency = 1
			TweenService:Create(section.Title, TweenInfo.new(0.7, Enum.EasingStyle.Quint), { TextTransparency = 0 }):Play()

			local function updateSize()
				local contentSize = section.UIListLayout.AbsoluteContentSize
				local scale = section:FindFirstChild("UIScale") and section:FindFirstChild("UIScale").Scale or 1
				section.Size = UDim2.new(1, 0, 0, contentSize.Y * scale)
			end

			if type == "Foldable" then
				local isOpen = true
				section.Title.TextButton.MouseButton1Click:Connect(function()
					isOpen = not isOpen
					for _, child in pairs(section:GetChildren()) do
						if child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" and not child:IsA("TextLabel") then
							child.Visible = isOpen
						end
					end
					updateSize()
				end)
			end

			function sectionObj:SetName(newName)
				section.Title.Text = newName
			end

			function sectionObj:Remove()
				if section then
					section:Destroy()
					section = nil
				end
			end

			function sectionObj:CreateButton(config)
				local buttonObj = { Func = config.Callback }
				local button = tabContainer.Template.Button:Clone()
				button.Name = config.Name or "Undefined"
				button.Title.Text = config.Name or "Undefined"
				button.Icon.Image = config.Icon or "rbxassetid://3944703587"
				button.Visible = true
				button.Parent = section
				updateSize()

				button.Interact.MouseButton1Click:Connect(function()
					local success, err = pcall(buttonObj.Func)
					if not success then
						local originalSize = button.Size
						TweenService:Create(button, Nazuro.Theme.Dark.TweenInfo, { Size = UDim2.new(0.992, -10, 0, 35) }):Play()
						TweenService:Create(button, Nazuro.Theme.Dark.TweenInfo, { BackgroundColor3 = Color3.fromRGB(103, 0, 0) }):Play()
						button.Title.Text = "Something failed on our end"
						warn("[Nazuro]: An error occurred: " .. tostring(err))
						task.wait(0.5)
						button.Title.Text = config.Name
						TweenService:Create(button, Nazuro.Theme.Dark.TweenInfo, { Size = originalSize }):Play()
						TweenService:Create(button, Nazuro.Theme.Dark.TweenInfo, { BackgroundColor3 = Nazuro.Theme.Dark.SecondaryColor }):Play()
					else
						local originalSize = button.Size
						TweenService:Create(button, Nazuro.Theme.Dark.TweenInfo, { Size = UDim2.new(0.992, -10, 0, 35) }):Play()
						task.wait(0.2)
						TweenService:Create(button, Nazuro.Theme.Dark.TweenInfo, { Size = originalSize }):Play()
					end
				end)

				function buttonObj:SetCallback(newCallback)
					buttonObj.Func = newCallback
				end

				function buttonObj:Remove()
					button:Destroy()
					updateSize()
				end

				function buttonObj:SetName(newName)
					button.Title.Text = newName
					button.Name = newName
				end

				return buttonObj
			end

			function sectionObj:CreateToggle(type, config)
				local toggleObj = {}
				local toggle = (type == "Radio" and tabContainer.Template.Toggle_Radio or tabContainer.Template.Toggle):Clone()
				local interact = toggle.Interact
				local switch = toggle.Switch
				local indicator = switch.Indicator
				local flag = config.Flag
				local value = flag and Configuration.Toggles[flag] or config.CurrentValue

				if flag and not Configuration.Toggles[flag] then
					Configuration.Toggles[flag] = config.CurrentValue
					SaveConfiguration()
				end

				local function setToggle(newValue)
					if flag then
						Configuration.Toggles[flag] = newValue
						SaveConfiguration()
					end
					value = newValue

					if type == "Radio" then
						TweenService:Create(indicator, Nazuro.Theme.Dark.TweenInfo, { BackgroundTransparency = newValue and 0 or 1 }):Play()
					else
						TweenService:Create(indicator, Nazuro.Theme.Dark.TweenInfo, { BackgroundColor3 = newValue and Nazuro.Theme.Dark.ToggleEnabled or Nazuro.Theme.Dark.ToggleDisabled }):Play()
						TweenService:Create(indicator, Nazuro.Theme.Dark.TweenInfo, { Position = newValue and UDim2.new(0.537, 0, 0.5, 0) or UDim2.new(0.07, 0, 0.5, 0) }):Play()
					end

					local success, err = pcall(function() config.Callback(newValue) end)
					if not success then
						TweenService:Create(toggle, Nazuro.Theme.Dark.TweenInfo, { BackgroundColor3 = Color3.fromRGB(103, 0, 0) }):Play()
						toggle.Title.Text = "Something failed on our end"
						warn("[Nazuro]: An error occurred: " .. tostring(err))
						task.wait(0.5)
						toggle.Title.Text = config.Name
						TweenService:Create(toggle, Nazuro.Theme.Dark.TweenInfo, { BackgroundColor3 = Nazuro.Theme.Dark.SecondaryColor }):Play()
					end
				end

				toggle.Name = config.Name
				toggle.Title.Text = config.Name
				toggle.Visible = true
				toggle.Parent = section
				if value then setToggle(value) end
				updateSize()

				interact.MouseButton1Click:Connect(function()
					setToggle(not value)
				end)

				config.SetToggle = setToggle
				return config
			end

			function sectionObj:CreateSlider(config)
				local isDragging = false
				local slider = tabContainer.Template.Slider:Clone()
				local flag = config.Flag
				local currentValue = flag and Configuration.Sliders[flag] or config.CurrentValue

				if flag and Configuration.Sliders[flag] then
					pcall(function() config.Callback(currentValue) end)
				end

				slider.Name = config.Name
				slider.Title.Text = config.Name
				slider.Visible = true
				slider.Parent = section
				updateSize()

				slider.Main.Progress.Size = UDim2.new(0, math.max(slider.Main.AbsoluteSize.X * (currentValue - config.Value[1]) / (config.Value[2] - config.Value[1]), 5), 1, 0)
				slider.Main.Information.Text = config.Suffix and (currentValue .. " " .. config.Suffix) or tostring(currentValue)

				slider.Main.Interact.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isDragging = true
					end
				end)

				slider.Main.Interact.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isDragging = false
					end
				end)

				slider.Main.Interact.MouseButton1Down:Connect(function()
					local connection
					connection = RunService.Stepped:Connect(function()
						if not isDragging then
							connection:Disconnect()
							return
						end

						local mousePos = UserInputService:GetMouseLocation().X
						local progressPos = math.clamp(mousePos, slider.Main.AbsolutePosition.X, slider.Main.AbsolutePosition.X + slider.Main.AbsoluteSize.X)
						local value = config.Value[1] + (progressPos - slider.Main.AbsolutePosition.X) / slider.Main.AbsoluteSize.X * (config.Value[2] - config.Value[1])
						value = math.floor(value / config.Increment + 0.5) * config.Increment

						slider.Main.Progress.Size = UDim2.new(0, math.max(progressPos - slider.Main.AbsolutePosition.X, 5), 1, 0)
						slider.Main.Information.Text = config.Suffix and (value .. " " .. config.Suffix) or tostring(value)

						if currentValue ~= value then
							if flag then
								Configuration.Sliders[flag] = value
								SaveConfiguration()
							end
							local success, err = pcall(function() config.Callback(value) end)
							currentValue = value
						end
					end)
				end)

				function config:Set(value)
					slider.Main.Progress.Size = UDim2.new(0, math.max(slider.Main.AbsoluteSize.X * (value - config.Value[1]) / (config.Value[2] - config.Value[1]), 5), 1, 0)
					slider.Main.Information.Text = config.Suffix and (value .. " " .. config.Suffix) or tostring(value)
					local success, err = pcall(function() config.Callback(value) end)
					currentValue = value
					if flag then
						Configuration.Sliders[flag] = value
						SaveConfiguration()
					end
				end

				return config
			end

			function sectionObj:CreateDropdown(config)
				local dropdown = tabContainer.Template.Dropdown:Clone()
				local flag = config.Flag
				local currentOption = flag and Configuration.Dropdowns[flag] or config.CurrentOption
				local debounce = false

				if flag then
					task.spawn(function()
						local success, err = pcall(function()
							config.Callback(config.MultipleOptions and currentOption or currentOption[1])
						end)
					end)
				end

				dropdown.Name = config.Name
				dropdown.Title.Text = config.Name
				dropdown.Visible = true
				dropdown.Parent = section
				dropdown.Size = UDim2.new(1, 0, 0, 45)
				dropdown.Interact.Size = UDim2.new(0, 429, 0, 45)
				dropdown.Interact.Position = UDim2.new(0, 214, 0, 22)
				dropdown.List.Visible = false

				if typeof(currentOption) == "string" then
					currentOption = { currentOption }
				end
				if not config.MultipleOptions then
					currentOption = { currentOption[1] }
				end

				dropdown.Selected.Text = config.MultipleOptions and (#currentOption == 1 and currentOption[1] or #currentOption == 0 and "None" or #currentOption .. " item" .. (#currentOption > 1 and "s" or "")) or currentOption[1]

				TweenService:Create(dropdown, TweenInfo.new(0.7, Enum.EasingStyle.Quint), { BackgroundTransparency = 0.75 }):Play()
				TweenService:Create(dropdown.UIStroke, TweenInfo.new(0.7, Enum.EasingStyle.Quint), { Transparency = 0 }):Play()
				TweenService:Create(dropdown.Title, TweenInfo.new(0.7, Enum.EasingStyle.Quint), { TextTransparency = 0 }):Play()

				for _, child in pairs(dropdown.List:GetChildren()) do
					if child.ClassName == "Frame" and child.Name ~= "Placeholder" then
						child:Destroy()
					end
				end

				dropdown.Toggle.Rotation = 180
				dropdown.Interact.MouseButton1Click:Connect(function()
					if debounce then return end
					debounce = true

					if dropdown.List.Visible then
						local tween = TweenService:Create(dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint), { Size = UDim2.new(1, 0, 0, 45) })
						tween:Play()
						tween.Completed:Connect(function()
							dropdown.List.Visible = false
							debounce = false
						end)

						for _, child in pairs(dropdown.List:GetChildren()) do
							if child.ClassName == "Frame" and child.Name ~= "Placeholder" then
								TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { BackgroundTransparency = 1 }):Play()
								TweenService:Create(child.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Transparency = 1 }):Play()
								TweenService:Create(child.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { TextTransparency = 1 }):Play()
							end
						end
						TweenService:Create(dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { ScrollBarImageTransparency = 1 }):Play()
						TweenService:Create(dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Quint), { Rotation = 180 }):Play()
					else
						local tween = TweenService:Create(dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint), { Size = UDim2.new(1, 0, 0, 180) })
						tween:Play()
						dropdown.List.Visible = true
						TweenService:Create(dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { ScrollBarImageTransparency = 0.7 }):Play()
						TweenService:Create(dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Quint), { Rotation = 0 }):Play()

						for _, child in pairs(dropdown.List:GetChildren()) do
							if child.ClassName == "Frame" and child.Name ~= "Placeholder" then
								TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { BackgroundTransparency = 0 }):Play()
								TweenService:Create(child.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Transparency = 0 }):Play()
								TweenService:Create(child.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { TextTransparency = 0 }):Play()
							end
						end
						tween.Completed:Connect(function() debounce = false end)
					end
					updateSize()
				end)

				for _, option in pairs(config.Options) do
					local optionFrame = tabContainer.Template.Dropdown.List.Template:Clone()
					optionFrame.Name = option
					optionFrame.Title.Text = option
					optionFrame.Parent = dropdown.List
					optionFrame.Visible = true

					if table.find(currentOption, option) then
						optionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
					end

					optionFrame.MouseEnter:Connect(function()
						TweenService:Create(optionFrame, Nazuro.Theme.Dark.TweenInfo, { BackgroundColor3 = Color3.fromRGB(40, 40, 40) }):Play()
						TweenService:Create(optionFrame, Nazuro.Theme.Dark.TweenInfo, { Size = UDim2.new(0.921, 0, 0, 38) }):Play()
					end)

					optionFrame.MouseLeave:Connect(function()
						TweenService:Create(optionFrame, Nazuro.Theme.Dark.TweenInfo, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }):Play()
						TweenService:Create(optionFrame, Nazuro.Theme.Dark.TweenInfo, { Size = UDim2.new(0.921, 0, 0, 38) }):Play()
					end)

					optionFrame.Interact.MouseButton1Click:Connect(function()
						if not config.MultipleOptions and table.find(currentOption, option) then return end

						if table.find(currentOption, option) then
							table.remove(currentOption, table.find(currentOption, option))
						else
							if not config.MultipleOptions then table.clear(currentOption) end
							table.insert(currentOption, option)
						end

						dropdown.Selected.Text = config.MultipleOptions and (#currentOption == 1 and currentOption[1] or #currentOption == 0 and "None" or #currentOption .. " item" .. (#currentOption > 1 and "s" or "")) or currentOption[1]

						if flag then
							Configuration.Dropdowns[flag] = config.MultipleOptions and currentOption or currentOption[1]
							SaveConfiguration()
						end

						local success, err = pcall(function() config.Callback(config.MultipleOptions and currentOption or currentOption[1]) end)

						for _, child in pairs(dropdown.List:GetChildren()) do
							if child.ClassName == "Frame" and child.Name ~= "Placeholder" then
								child.BackgroundColor3 = table.find(currentOption, child.Name) and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
							end
						end

						if not config.MultipleOptions then
							debounce = true
							local tween = TweenService:Create(dropdown, TweenInfo.new(0.5, Enum.EasingStyle.Quint), { Size = UDim2.new(1, 0, 0, 45) })
							tween:Play()
							for _, child in pairs(dropdown.List:GetChildren()) do
								if child.ClassName == "Frame" and child.Name ~= "Placeholder" then
									TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { BackgroundTransparency = 1 }):Play()
									TweenService:Create(child.UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Transparency = 1 }):Play()
									TweenService:Create(child.Title, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { TextTransparency = 1 }):Play()
								end
							end
							TweenService:Create(dropdown.List, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { ScrollBarImageTransparency = 1 }):Play()
							TweenService:Create(dropdown.Toggle, TweenInfo.new(0.7, Enum.EasingStyle.Quint), { Rotation = 180 }):Play()
							tween.Completed:Connect(function()
								dropdown.List.Visible = false
								debounce = false
							end)
						end
					end)
				end

				function config:Set(newOption)
					currentOption = newOption
					if typeof(currentOption) == "string" then
						currentOption = { currentOption }
					end
					if not config.MultipleOptions then
						currentOption = { currentOption[1] }
					end

					dropdown.Selected.Text = config.MultipleOptions and (#currentOption == 1 and currentOption[1] or #currentOption == 0 and "None" or #currentOption .. " item" .. (#currentOption > 1 and "s" or "")) or currentOption[1]

					local success, err = pcall(function() config.Callback(config.MultipleOptions and currentOption or currentOption[1]) end)

					for _, child in pairs(dropdown.List:GetChildren()) do
						if child.ClassName == "Frame" and child.Name ~= "Placeholder" then
							child.BackgroundColor3 = table.find(currentOption, child.Name) and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(30, 30, 30)
						end
					end

					if flag then
						Configuration.Dropdowns[flag] = config.MultipleOptions and currentOption or currentOption[1]
						SaveConfiguration()
					end
				end

				return config
			end

			function sectionObj:CreateTextbox(config)
				local textbox = tabContainer.Template.Input:Clone()
				textbox.Name = config.Name
				textbox.Title.Text = config.Name
				textbox.Visible = true
				textbox.Parent = section
				local flag = config.Flag
				local currentValue = flag and Configuration.Inputs[flag]

				if flag and currentValue then
					textbox.InputFrame.InputBox.Text = currentValue
				end

				updateSize()
				textbox.InputFrame.InputBox.PlaceholderText = config.PlaceholderText
				textbox.InputFrame.Size = UDim2.new(0, textbox.InputFrame.InputBox.TextBounds.X + 24, 0, 30)

				textbox.InputFrame.InputBox.FocusLost:Connect(function()
					local inputText = textbox.InputFrame.InputBox.Text:gsub("%s+", "")
					if inputText == "" then return end

					local success, err = pcall(function() config.Callback(textbox.InputFrame.InputBox.Text) end)

					if flag then
						Configuration.Inputs[flag] = textbox.InputFrame.InputBox.Text
						SaveConfiguration()
					end

					textbox.InputFrame.Size = UDim2.new(0, textbox.InputFrame.InputBox.TextBounds.X + 24, 0, 30)
				end)

				textbox.InputFrame.InputBox:GetPropertyChangedSignal("Text"):Connect(function()
					TweenService:Create(textbox.InputFrame, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
						Size = UDim2.new(0, textbox.InputFrame.InputBox.TextBounds.X + 24, 0, 30)
					}):Play()
				end)

				function config:Set(newText)
					textbox.InputFrame.InputBox.Text = newText
					if flag then
						Configuration.Inputs[flag] = newText
						SaveConfiguration()
					end
				end

				return config
			end

			return sectionObj
		end

		return tabObj
	end

	if IsOnMobile and not IsOnEmulator then
		Nazuro:CreateMobileButton()
	end

	return lib
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
