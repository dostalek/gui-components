# GUI Components

A collection of Roblox game-ready GUI components.

## How to Use

To use a component, place its `ModuleScript` into your project (e.g., inside `ReplicatedStorage`) and `require` it from a `LocalScript`.

All components follow a similar constructor pattern:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MyComponent = require(ReplicatedStorage:WaitForChild("MyComponent"))

local newComponent = MyComponent.New(...)
```

## Available Components

### Modal

Creates a pop-up GUI element that tweens into view while blurring the background.

### Example:

```lua
-- In a LocalScript

local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modal = require(ReplicatedStorage:WaitForChild("Modal"))

-- 1. Get your GUI elements
local myScreenGui = PlayerGui:WaitForChild("MyScreenGui")
local modalFrame = myScreenGui:WaitForChild("ModalFrame")
local toggleButton = myScreenGui:WaitForChild("ToggleButton")
-- local openButton = myScreenGui:WaitForChild("OpenButton")
-- local closeButton = myScreenGui:WaitForChild("CloseButton")

-- 2. Create the modal instance
local myModal = Modal.New(
    modalFrame,          -- Required: The GuiObject to act as the modal
    TweenInfo.new(0.15), -- Optional: The TweenInfo for the modal animation (default TweenInfo.new(0.25))
    16,                  -- Optional: The blur intensity (default 24)
    false                -- Optional: Whether the modal should start open (default false)
)

-- 3. Connect buttons to open, close, and toggle the modal
myModal:SetButtons(nil, nil, toggleButton)
-- myModal:SetButtons(openButton, closeButton, toggleButton)

-- 4. (Optional) Bind an action to toggle the modal
myModal:SetContextAction({Enum.KeyCode.E})
```
