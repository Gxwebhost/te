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
end

-- Toggle UI visibility
function Nazuro:ToggleUI(state)
	UI.Main.Visible = state or not UI.Main.Visible
end

function Nazuro:GetUIInstance()
	return UI
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
end

return Nazuro
