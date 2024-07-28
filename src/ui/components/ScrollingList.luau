local Fragment = require(script.Parent.Fragment)
local vide = require(script.Parent.Parent.Parent.packages.vide)
local types = require(script.Parent.Parent.Parent.types)

local function ScrollingPage(children: types.Components): ScrollingFrame
  return vide.create "ScrollingFrame" {
    Name = "ScrollingPage",
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    CanvasSize = UDim2.fromScale(0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,

    ScrollBarThickness = 0,

    ClipsDescendants = false,

    Fragment {
      padding = UDim.new(0, 8),
      children = children
    }
  }
end

return ScrollingPage