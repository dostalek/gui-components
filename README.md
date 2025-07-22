# GUI Components

A collection of Roblox GUI components.

## How to Use

To use a component, place its `ModuleScript` into your game (e.g., inside `ReplicatedStorage`) and `require` it from a `LocalScript`.

All components follow a similar constructor pattern:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MyComponent = require(ReplicatedStorage:WaitForChild("MyComponent"))

local newComponent = MyComponent.New(...)
```

## Available Components

### Modal

Creates a pop-up GUI element from an existing `GuiObject` that tweens into view while blurring the background.

### Example:

```lua
-- Create a modal instance
local myModal = Modal.New(
    referenceToGuiObject, -- The GuiObject to act as the modal (e.g., a Frame)
    TweenInfo.new(0.25),  -- (Optional) The TweenInfo for the modal animation (default (0.15))
    16,                   -- (Optional) The background blur intensity (default 24)
    false                 -- (Optional) Whether the modal starts open (default false)
)
    -- (Optional) Connect GUI buttons to open, close, or toggle the modal
    :SetButtons(nil, referenceToCloseButton, referenceToToggleButton)
    -- (Optional) Bind user input type(s) to toggle the modal
    :SetContext({Enum.KeyCode.E})
```

**Note:** Creating a new `Modal` instance parents the given `GuiObject` to a `CanvasGroup`, changing its hierarchy. Be mindful of this when referencing it later.
