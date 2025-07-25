local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = ReplicatedStorage:WaitForChild("Components")

local Modal = require(Components:WaitForChild("Modal"))

local playFrame = script.Parent.PlayFrame
local playFrameCloseButton = playFrame.CloseButton

-- Create a new modal instance with 0.15s animation time, 24 background blur,
-- and closed by default, that can be toggled by pressing "P".
myModal = Modal.New(
    playFrame,           -- The GuiObject to act as the modal
    TweenInfo.new(0.15), -- (Optional) The TweenInfo for the modal animation
    24,                  -- (Optional) The background blur intensity
    false                -- (Optional) Whteher the modal starts open
)
    -- (Optional) Connect GUIButtons to open, close, or toggle the modal
	:SetButtons(nil, playFrameCloseButton, nil)
    -- (Optional) Bind user input type(s) to togle the modal
	:SetContext({Enum.KeyCode.P})