local List = require(script.Parent.List)
local vide = require(script.Parent.Parent.Parent.packages.vide)
local types = require(script.Parent.Parent.Parent.types)

export type FragmentProps = {
  padding: UDim?,
  direction: ("Vertical" | "Horizontal")?,
  layout: vide.vFrame?,
  listLayout: vide.vUIListLayout?,
  children: types.Components
}

local function Fragment(props: FragmentProps): Frame
  return vide.create "Frame" {
    Name = "Fragment",
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 0),
    AutomaticSize = Enum.AutomaticSize.Y,

    List {
      padding = props.padding,
      direction = props.direction or "Vertical",
      layout = props.listLayout
    },

    props.children,
    props.layout
  }
end

return Fragment