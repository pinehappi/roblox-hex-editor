--!strict

-- These are the default forms you can provide as the forms dependency.
-- This script is meant to be modified.

local UserInputService = game:GetService("UserInputService")

local HexEditor = require(script.Parent.HexEditor)

local FormProvider = {}

--[[ Settings ]]

local BACKGROUND_COLOR = Color3.fromRGB(60, 60, 60)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

local BUTTON_BACKGROUND_COLOR = Color3.fromRGB(40, 40, 40)
local BUTTON_TEXT_COLOR = Color3.fromRGB(255, 255, 255)

local HEADER_BACKGROUND_COLOR = Color3.fromRGB(220, 220, 220)
local HEADER_TEXT_COLOR = Color3.fromRGB(0, 0, 0)

local FONT = Font.fromEnum(Enum.Font.Code)

local HEX_EDITOR_THEME = {
	cell = {
		background = Color3.fromRGB(80, 80, 80),
		text = Color3.fromRGB(255, 255, 255),

		hover = Color3.fromRGB(120, 120, 120),
		hoverText = Color3.fromRGB(255, 255, 255),

		select = Color3.fromRGB(50, 50, 120),
		selectText = Color3.fromRGB(255, 255, 255),

		cursorActive = Color3.fromRGB(80, 80, 160),
		cursorActiveText = Color3.fromRGB(255, 255, 255),

		cursor = Color3.fromRGB(86, 135, 225),
	},
	modifiedCell = {
		background = Color3.fromRGB(100, 80, 60),
		text = Color3.fromRGB(255, 255, 255),

		hover = Color3.fromRGB(120, 100, 100),
		hoverText = Color3.fromRGB(255, 255, 255),

		select = Color3.fromRGB(80, 120, 120),
		selectText = Color3.fromRGB(255, 255, 255),

		cursorActive = Color3.fromRGB(150, 110, 80),
		cursorActiveText = Color3.fromRGB(255, 255, 255),

		cursor = Color3.fromRGB(239, 166, 101),
	},
	addCell = {
		background = Color3.fromRGB(70, 100, 70),
		text = Color3.fromRGB(255, 255, 255),

		hover = Color3.fromRGB(100, 120, 100),
		hoverText = Color3.fromRGB(255, 255, 255),

		select = Color3.fromRGB(100, 120, 150),
		selectText = Color3.fromRGB(255, 255, 255),

		cursorActive = Color3.fromRGB(100, 150, 100),
		cursorActiveText = Color3.fromRGB(255, 255, 255),

		cursor = Color3.fromRGB(125, 209, 127),
	},

	headerText = Color3.fromRGB(120, 120, 130),
	headerActiveText = Color3.fromRGB(180, 180, 180),
	headerBackground = Color3.fromRGB(80, 80, 80),

	gutterText = Color3.fromRGB(120, 120, 130),
	gutterActiveText = Color3.fromRGB(180, 180, 180),
	gutterBackground = Color3.fromRGB(27, 26, 26),

	font = Font.fromEnum(Enum.Font.Code),
	textSize = 16,

	sectionGap = 6,
	cellPadding = 2,
	halfCellPadding = 0,
}

--[[ Main stuff ]]

local function makeFlexBox(direction: Enum.FillDirection, padding: UDim?)
	local frame = Instance.new("Frame")
	frame.BorderSizePixel = 0
	
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = direction
	uiListLayout.Padding = padding or UDim.new(0, 0)
	uiListLayout.Wraps = true
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = frame
	
	return frame, uiListLayout
end

local function makeScrim()
	local scrim = Instance.new("TextButton")
	scrim.AutoButtonColor = false
	scrim.Text = ""
	scrim.BorderSizePixel = 0
	scrim.Size = UDim2.fromScale(1, 1)
	scrim.BackgroundTransparency = 0.65
	scrim.BackgroundColor3 = Color3.new(0, 0, 0)
	
	return scrim
end

local function applyPadding(object: GuiObject, horizontal: number, vertical: number?)
	vertical = vertical or horizontal
	
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, vertical)
	padding.PaddingBottom = UDim.new(0, vertical)
	padding.PaddingLeft = UDim.new(0, horizontal)
	padding.PaddingRight = UDim.new(0, horizontal)
	
	padding.Parent = object
	return padding
end

local function makeLabel(text)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.TextColor3 = TEXT_COLOR
	label.FontFace = FONT
	label.TextSize = 16
	label.Text = text
	label.AutomaticSize = Enum.AutomaticSize.XY
	applyPadding(label, 4, 0)
	
	return label
end

local function makeButton(text)
	local button = Instance.new("TextButton")
	button.Text = text
	button.TextColor3 = BUTTON_TEXT_COLOR
	button.AutomaticSize = Enum.AutomaticSize.XY
	button.BackgroundColor3 = BUTTON_BACKGROUND_COLOR
	button.BorderSizePixel = 0
	button.TextSize = 16
	button.FontFace = FONT
	applyPadding(button, 4)
	
	return button
end

local function makePopupWithButtons(title: string, buttonTexts: {string}, addContent: (Frame) -> ()): (Frame, {[string]: TextButton})
	local frame = makeFlexBox(Enum.FillDirection.Vertical, UDim.new(0, 6))
	frame.BackgroundColor3 = BACKGROUND_COLOR
	frame.ZIndex = 100

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, 0, 0, 20)
	header.BackgroundColor3 = HEADER_BACKGROUND_COLOR
	header.TextColor3 = HEADER_TEXT_COLOR
	header.Text = title
	header.TextSize = 16
	header.FontFace = Font.new(FONT.Family, Enum.FontWeight.Bold, FONT.Style)
	applyPadding(header, 4, 0)
	header.Parent = frame
	
	addContent(frame)
	
	local buttonContainer = makeFlexBox(Enum.FillDirection.Horizontal, UDim.new(0, 4))
	applyPadding(buttonContainer, 4, 0)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Size = UDim2.fromScale(1, 0)
	buttonContainer.AutomaticSize = Enum.AutomaticSize.Y
	buttonContainer.Parent = frame
	
	local buttons = {}
	for _, text in buttonTexts do
		local button = makeButton(text)
		button.Parent = buttonContainer
		buttons[text] = button
	end
	
	return frame, buttons
end

function FormProvider.generate(container: GuiObject, inputReceiver: UserInputService | GuiObject)
	return {
		promptContextMenu = function(input: InputObject, options: {string})
			local contextMenu = makeFlexBox(Enum.FillDirection.Vertical)
			contextMenu.BackgroundColor3 = BUTTON_BACKGROUND_COLOR
			contextMenu.Size = UDim2.fromOffset(150 ,0)
			contextMenu.AutomaticSize = Enum.AutomaticSize.Y
			contextMenu.ZIndex = 100
			contextMenu.Position = UDim2.fromOffset(
				input.Position.X - container.AbsolutePosition.X,
				input.Position.Y - container.AbsolutePosition.Y
			)
			contextMenu.Parent = container
			
			local resultEvent = Instance.new("BindableEvent")

			for _, option in options do
				local button = Instance.new("TextButton")
				button.BorderSizePixel = 0
				button.BackgroundColor3 = BUTTON_BACKGROUND_COLOR
				button.TextColor3 = BUTTON_TEXT_COLOR
				button.AutomaticSize = Enum.AutomaticSize.Y
				button.Size = UDim2.fromScale(1, 0)
				button.TextSize = 12
				button.Text = option
				
				applyPadding(button, 4)
				
				button.Parent = contextMenu
				button.Activated:Connect(function()
					resultEvent:Fire(option)
				end)
			end
			
			local scrim = makeScrim()
			scrim.ZIndex = 99
			
			scrim.Activated:Connect(function()
				resultEvent:Fire(nil)
			end)
			scrim.MouseButton2Click:Connect(function()
				resultEvent:Fire(nil)
			end)

			scrim.Parent = container
			
			local result = resultEvent.Event:Wait()
			
			contextMenu:Destroy()
			scrim:Destroy()
			
			return result
		end,
		
		promptFillWith = function(input: InputObject)
			local scrim = makeScrim()
			scrim.ZIndex = 99
			scrim.Parent = container
			
			local editor: HexEditor.HexEditor
			local popup, buttons = makePopupWithButtons(
				"FILL WITH", {"FILL", "CANCEL"},
				function(frame)
					makeLabel("PATTERN").Parent = frame
					
					local editorContainer = Instance.new("Frame")
					editorContainer.BackgroundTransparency = 1
					editorContainer.Size = UDim2.new(1, 0, 0, 2*HEX_EDITOR_THEME.textSize + 12)
					editorContainer.Parent = frame

					editor = HexEditor.new(buffer.create(1), {
						container = editorContainer,
						theme = HEX_EDITOR_THEME,
						layout = {
							columns = 12,
							showHeader = false,
							showGutter = false,
							showDecodedText = false,
						},
					}, {
						inputReceiver = inputReceiver,
					})
				end
			)
			popup.ZIndex = 100
			popup.Size = UDim2.fromOffset(300, 128)
			popup.Position = UDim2.fromOffset(
				input.Position.X - container.AbsolutePosition.X,
				input.Position.Y - container.AbsolutePosition.Y
			)
			popup.Parent = container
			
			local resultEvent = Instance.new("BindableEvent")
			
			buttons.FILL.Activated:Connect(function()
				resultEvent:Fire("fill")
			end)
			
			buttons.CANCEL.Activated:Connect(function()
				resultEvent:Fire(nil)
			end)
			
			scrim.Activated:Connect(function()
				resultEvent:Fire(nil)
			end)
			
			local result: any = resultEvent.Event:Wait()
			
			if result == "fill" then
				result = editor:getBuffer()
			end
			
			editor:destroy()
			scrim:Destroy()
			popup:Destroy()
			return result
		end,
		
		promptInsertNullBytes = function(input: InputObject)
			local textBox: TextBox
			local popup, buttons = makePopupWithButtons(
				"INSERT NULL BYTES", {"INSERT", "CANCEL"},
				function(frame)
					makeLabel("AMOUNT").Parent = frame
					
					local container = makeFlexBox(Enum.FillDirection.Horizontal)
					applyPadding(container, 4, 0)
					container.AutomaticSize = Enum.AutomaticSize.XY
					container.BackgroundTransparency = 1
					container.Parent = frame
					
					textBox = Instance.new("TextBox")
					textBox.ClearTextOnFocus = false
					textBox.Text = "4"
					textBox.PlaceholderText = "# of bytes"
					textBox.TextColor3 = BUTTON_TEXT_COLOR
					textBox.AutomaticSize = Enum.AutomaticSize.XY
					textBox.BackgroundColor3 = BUTTON_BACKGROUND_COLOR
					textBox.BorderSizePixel = 0
					textBox.TextSize = 16
					textBox.FontFace = FONT
					textBox.Size = UDim2.fromOffset(60, 20)
					textBox.Parent = container
				end
			)
			popup.ZIndex = 100
			popup.Size = UDim2.fromOffset(200, 100)
			popup.Position = UDim2.fromOffset(
				input.Position.X - container.AbsolutePosition.X,
				input.Position.Y - container.AbsolutePosition.Y
			)
			popup.Parent = container
			
			local result = tonumber(textBox.Text)
			textBox:GetPropertyChangedSignal("Text"):Connect(function()
				result = tonumber(textBox.Text)
				if not result then
					buttons.INSERT.BackgroundTransparency = 0.5
					buttons.INSERT.AutoButtonColor = false
				else
					buttons.INSERT.BackgroundTransparency = 0
					buttons.INSERT.AutoButtonColor = true
				end
			end)

			local scrim = makeScrim()
			scrim.ZIndex = 99
			scrim.Parent = container

			local resultEvent = Instance.new("BindableEvent")
			
			buttons.INSERT.Activated:Connect(function()
				resultEvent:Fire(true)
			end)
			
			buttons.CANCEL.Activated:Connect(function()
				resultEvent:Fire(false)
			end)
			
			scrim.Activated:Connect(function()
				resultEvent:Fire(false)
			end)
			
			local shouldSubmit = resultEvent.Event:Wait()
			
			popup:Destroy()
			scrim:Destroy()
			
			if shouldSubmit then
				return if result > 0 then result else nil
			else
				return nil
			end
		end,
	}
end

return FormProvider