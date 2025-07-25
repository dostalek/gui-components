local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = ReplicatedStorage:WaitForChild("Components")

local RadioGroup = require(Components:WaitForChild("RadioGroup"))

local radioFrame = script.Parent
local radioButtons = {radioFrame.PublicButton, radioFrame.PrivateButton}

local function selectFunction(button: TextButton)
	local uiStroke = button:FindFirstChildOfClass("UIStroke")
	
	button.BackgroundColor3 = Color3.fromHex("#615fff")
	button.BackgroundTransparency = 0
	button.TextColor3 = Color3.fromHex("#ffffff")
	uiStroke.Color = Color3.fromHex("#312c85")
end

local function deselectFunction(button: TextButton)
	local uiStroke = button:FindFirstChildOfClass("UIStroke")
	
	button.BackgroundTransparency = 1
	button.TextColor3 = Color3.fromHex("#e2e8f0")
	uiStroke.Color = Color3.fromHex("#0f172b")
end

local partyTypeRadio = RadioGroup.New(
	radioButtons,    -- The radio group buttons
	radioButtons[1], -- The default selected button
	selectFunction,  -- Function to set selected appearance of radio button
	deselectFunction -- Function to set deselected appearance of radio button
)

-- Access the currently selected button
local selected = partyTypeRadio.Selected