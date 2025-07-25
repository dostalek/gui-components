local RadioGroup = {}
RadioGroup.__index = RadioGroup

-- Constructs a new RadioGroup object
function RadioGroup.New(
	buttons: {GuiButton}, 
	selected: GuiButton, 
	selectFunction: (GuiButton) -> (), 
	deselectFunction: (GuiButton) -> ()
)
	local newRadioGroup = setmetatable({}, RadioGroup)
	
	newRadioGroup.Buttons = buttons
	newRadioGroup.Selected = selected
	newRadioGroup.SelectFunction = selectFunction
	newRadioGroup.DeselectFunction = deselectFunction
	
	-- Normalize and connect buttons
	for _, button in buttons do
		newRadioGroup:_deselect(button)
		button.Activated:Connect(function()
			newRadioGroup:Select(button)
		end)
	end
	
	newRadioGroup:Select(selected)
			
	return newRadioGroup
end

-- Select a given GUI button
function RadioGroup:Select(button: GuiButton): boolean
	local selected = self.Selected
	
	if button == self.Selected then
		return false
	end
	if table.find(self.Buttons, button) == nil then
		warn("Attempted to select button, but it does not exist in group.")
		return false
	end
	
	if selected ~= nil then 
		self:_deselect(selected) 
	end
	self.Selected = button
	self.SelectFunction(button)
		
	return true
end

-- Deselect a given GUI button
function RadioGroup:_deselect(button: GuiButton)
	self.Selected = nil
	self.DeselectFunction(button)
end

return RadioGroup
