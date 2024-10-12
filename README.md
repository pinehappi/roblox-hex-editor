# roblox-hex-editor
Embeddable hex editor for Roblox.

## Embedding
Copy and paste the HexEditor.luau into your project. The other two scripts are optional. Here is some starter code for embedding:
```luau
local UserInputService = game:GetService("UserInputService")
local HexEditor = require(script.Parent.HexEditor)
local DataInspector = require(script.Parent.DataInspector)
local SampleFormProvider = require(script.Parent.SampleFormProvider)

local editor = HexEditor.new(
	buffer.fromstring("Hello, world!"),

	-- Options
	{
		container = script.Parent.Frame,
		sizing = "fillContainerY",
	},

	-- Dependencies
	{
		-- This can also be a GuiObject if you are embedding into a plugin widget.
		inputReceiver = UserInputService,

		-- This dependency is optional if you want the right click menu and everything that comes with it.
		forms = SampleFormProvider.generate(script.Parent.Frame, UserInputService)
	}
)

local inspector = DataInspector.new(
	editor,
	{
		container = script.Parent.Frame,
		sizing = "fillContainerY",
	}
)
```

## Contributing

Contributions are welcome. If you want to contribute to the plugin, you can just send me a patch like they did in the old days. The source for the plugin is available here: [https://create.roblox.com/dashboard/creations/experiences/6658155515/overview](https://www.roblox.com/games/124668216784032/hex-editor-demo).
