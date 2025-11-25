--!strict

local Types = require(script.Parent.Types)
local Dropper = require(script.Components.Dropper)

local DropperOptionTemplate = script.Templates.DropperOptionTemplate

local pluginGlobalIndex: Types.pluginGlobalIndex = _G["AutoComplete+"]

local module = {}

function module.Setup(): ()
	local DockWidgetPluginGui = pluginGlobalIndex.plugin:CreateDockWidgetPluginGui(
		"StylePicker", 
		DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			false,
			true,
			200,
			150,
			200,
			150
		)
	)

	local UI = script.Frame
	local SuggestionCharacterTextBox = UI.SuggestionCharacter.TextBox
	
	SuggestionCharacterTextBox.Text = pluginGlobalIndex.SuggestionCharacter or ""
	
	table.insert(pluginGlobalIndex.Connections, UI.Title.Close.MouseButton1Click:Connect(function()
		DockWidgetPluginGui.Enabled = false
	end))
	
	table.insert(pluginGlobalIndex.Connections, SuggestionCharacterTextBox:GetPropertyChangedSignal("Text"):Connect(function()
		SuggestionCharacterTextBox.Text = string.sub(SuggestionCharacterTextBox.Text, #SuggestionCharacterTextBox.Text)

		local newSuggestionCharacter: string? = SuggestionCharacterTextBox.Text
		if newSuggestionCharacter == "" then
			newSuggestionCharacter = nil
		end

		pluginGlobalIndex.SuggestionCharacter = newSuggestionCharacter
		pluginGlobalIndex.plugin:SetSetting("SuggestionCharacter", newSuggestionCharacter)
	end))
	
	UI.ImportCasing.Service.TextLabel.Text = pluginGlobalIndex.ServiceImportStyle
	Dropper.setupDropper(UI.ImportCasing.Service.TextLabel.Dropper, DropperOptionTemplate, "ServiceImportStyle")
	
	UI.ImportCasing.Module.TextLabel.Text = pluginGlobalIndex.ModuleImportStyle
	Dropper.setupDropper(UI.ImportCasing.Module.TextLabel.Dropper, DropperOptionTemplate, "ModuleImportStyle")
	
	UI.ImportCasing.Instance.TextLabel.Text = pluginGlobalIndex.InstanceImportStyle
	Dropper.setupDropper(UI.ImportCasing.Instance.TextLabel.Dropper, DropperOptionTemplate, "InstanceImportStyle")

	DockWidgetPluginGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	UI.Parent = DockWidgetPluginGui

	local Button = pluginGlobalIndex.plugin:CreateToolbar("AutoComplete+"):CreateButton("AutoComplete+", "Open Menu", "rbxassetid://111947305844735")
	Button.Click:Connect(function()
		DockWidgetPluginGui.Enabled = not DockWidgetPluginGui.Enabled
	end)
end

return module
