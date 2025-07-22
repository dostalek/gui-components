local Modal = {}
Modal.__index = Modal

local ContextActionService = game:GetService("ContextActionService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- The open and closed positions of the canvas group
local OPEN_POSITION = UDim2.new(0, 0, 0, 0)
local CLOSED_POSITION = UDim2.new(0, 0, 0.05, 0)

export type Modal = {
	GuiObject: GuiObject,
	TweenInfo: TweenInfo,
	BlurSize: number,
	IsOpen: boolean,
	OpenButton: GuiButton?,
	CloseButton: GuiButton?,
	ToggleButton: GuiButton?,
	InputObjects: {InputObject}?,
	
	SetButtons: (
		self: Modal, 
		openButton: GuiButton?, 
		closeButton: GuiButton?, 
		toggleButton: GuiButton?) 
	-> Modal,
	SetContext: (self: Modal, inputObjects: {InputObject}) -> Modal,
	
	Open: (self: Modal) -> (),
	Close: (self: Modal) -> (),
	Toggle: (self: Modal) -> (),
	Destroy: (self: Modal) -> (),
	
	_canvasGroup: CanvasGroup,
	_isAnimating: boolean,
	_actionName: string,
	_blurEffect: BlurEffect,
	_connections: {RBXScriptConnection}?
}

-- Helper function to wrap a given GUI object in a canvas group
local function wrapInCanvasGroup(guiObject: GuiObject) : CanvasGroup
	local canvasGroup = Instance.new("CanvasGroup")
	canvasGroup.BackgroundTransparency = 1
	canvasGroup.Size = UDim2.new(1, 0, 1, 0)
	canvasGroup.Parent = guiObject.Parent
	guiObject.Parent = canvasGroup
	return canvasGroup
end

-- Constructs a new modal object
function Modal.New(guiObject: GuiObject, tweenInfo: TweenInfo?, blurSize: number?, isOpen: boolean?): Modal
	local newModal: Modal = {}
	
	newModal.GuiObject = guiObject
	newModal.TweenInfo = if tweenInfo ~= nil then tweenInfo else TweenInfo.new(0.15)
	newModal.BlurSize = if blurSize ~= nil then blurSize else 24
	newModal.IsOpen = if isOpen ~= nil then isOpen else false
	
	newModal._canvasGroup = wrapInCanvasGroup(guiObject)
	newModal._actionName = tostring(newModal)
	
	local newBlurEffect = Instance.new("BlurEffect")
	newBlurEffect.Size = if newModal.IsOpen then newModal.BlurSize else 0
	newBlurEffect.Parent = Lighting
	newModal._blurEffect = newBlurEffect
	
	-- Set initial state
	newModal._isAnimating = false
	newModal._canvasGroup.GroupTransparency = if newModal.IsOpen then 0 else 1
	newModal._canvasGroup.Position = if newModal.IsOpen then OPEN_POSITION else CLOSED_POSITION
	newModal._canvasGroup.Visible = newModal.IsOpen
		
	setmetatable(newModal, Modal)
	return newModal
end

-- Helper function for cleaning up connections
local function cleanUpConnections(modal: Modal)
	local connections = modal._connections

	if connections then
		for _, connection in connections do
			connection:Disconnect()
		end
		modal._connections = {}
	end
end

-- Set GUI buttons for opening, closing, and toggling the modal
function Modal:SetButtons(openButton: GuiButton?, closeButton: GuiButton?, toggleButton: GuiButton?)
	self.OpenButton = openButton
	self.CloseButton = closeButton
	self.ToggleButton = toggleButton
	
	cleanUpConnections(self)
	self._connections = {}
	
	if openButton then
		local connection = openButton.Activated:Connect(function()
			self:Open()
		end)
		table.insert(self._connections, connection)
	end
	
	if closeButton then
		local connection = closeButton.Activated:Connect(function()
			self:Close()
		end)
		table.insert(self._connections, connection)
	end
	
	if toggleButton then
		local connection = toggleButton.Activated:Connect(function()
			self:Toggle()
		end)
		table.insert(self._connections, connection)
	end
	
	return self
end

-- Set context for toggling the modal
function Modal:SetContext(inputObjects: {InputObject})
	self.InputObjects = inputObjects
	
	local function handleToggle(_actionName, inputState: Enum.UserInputState, _inputObject)
		if inputState == Enum.UserInputState.Begin then
			self:Toggle()
		end
	end
	
	ContextActionService:BindAction(self._actionName, handleToggle, false, table.unpack(inputObjects))
	
	return self
end

-- Open the modal
function Modal:Open()
	if self.IsOpen or self._isAnimating then return end
	
	self.IsOpen = true
	self._isAnimating = true
	self._canvasGroup.Visible = true
	
	local openGoal = {
		GroupTransparency = 0,
		Position = OPEN_POSITION
	}
	local openTween = TweenService:Create(self._canvasGroup, self.TweenInfo, openGoal)
	
	local blurGoal = {
		Size = self.BlurSize
	}
	local blurTween = TweenService:Create(self._blurEffect, self.TweenInfo, blurGoal)
	
	openTween:Play()
	blurTween:Play()
	
	openTween.Completed:Once(function()
		self._isAnimating = false		
	end)
end

-- Close the modal
function Modal:Close()
	if not self.IsOpen or self._isAnimating then return end

	self.IsOpen = false
	self._isAnimating = true

	local closeGoal = {
		GroupTransparency = 1,
		Position = CLOSED_POSITION
	}
	local closeTween = TweenService:Create(self._canvasGroup, self.TweenInfo, closeGoal)
	
	local blurGoal = {
		Size = 0
	}
	local blurTween = TweenService:Create(self._blurEffect, self.TweenInfo, blurGoal)
	
	closeTween:Play()
	blurTween:Play()
	
	closeTween.Completed:Once(function()
		self._canvasGroup.Visible = false
		self._isAnimating = false
	end)
end

-- Toggle the modal state between open and closed
function Modal:Toggle()
	if self.IsOpen then
		self:Close()
	else
		self:Open()
	end
end

-- Destroys the modal and cleans up connections
function Modal:Destroy()
	cleanUpConnections(self)
	ContextActionService:UnbindAction(self._actionName)
	self._blurEffect:Destroy()
	self._canvasGroup:Destroy()
end

return Modal