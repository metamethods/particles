local vide = require(script.Parent.Parent.Parent.packages.vide)
local types = require(script.Parent.Parent.Parent.types)
local useTheme = require(script.Parent.Parent.Parent.util.useTheme)
local Padding = require(script.Parent.Padding)
local Round = require(script.Parent.Round)

export type ButtonProps = {
  disabled: vide.Source<boolean>?,
  onClicked: () -> ()?,
  layout: vide.vTextButton?,
  children: types.Components?
}

local function Button(props: ButtonProps): TextButton
  local pressed = vide.source(false)
  local hovered = vide.source(false)
  local disabled = props.disabled or vide.source(false)

  local overlayButtonTransparency = function()
    return if hovered() or pressed() or disabled() then .5 else 1
  end

  local overlayButtonColor = function()
    if disabled() then
      return useTheme(Enum.StudioStyleGuideColor.Button, "Disabled")()
    end

    if pressed() then
      return useTheme(Enum.StudioStyleGuideColor.Button, "Pressed")()
    end

    return useTheme(Enum.StudioStyleGuideColor.Button, "Hover")()
  end

  return vide.create "TextButton" {
    Name = "Button",
    BackgroundColor3 = useTheme(Enum.StudioStyleGuideColor.Button),
    AutomaticSize = Enum.AutomaticSize.XY,

    vide.create "Frame" {
      Name = "Overlay",
      BackgroundColor3 = vide.spring(overlayButtonColor, .15),
      Transparency = vide.spring(overlayButtonTransparency, .15),
      Size = UDim2.new(1, 16, 1, 16),
      Position = UDim2.new(0, -8, 0, -8),

      ZIndex = 999,

      Round {}
    },

    MouseEnter = function()
      hovered(true)
    end,

    MouseLeave = function()
      hovered(false)
      pressed(false)
    end,

    MouseButton1Down = function()
      pressed(true)
    end,

    MouseButton1Up = function()
      pressed(false)
    end,

    Activated = function()
      if disabled() or not props.onClicked then return end
      props.onClicked()
    end,

    Round {},
    Padding { UDim.new(0, 8) },

    props.layout,
    props.children
  }
end

return Button