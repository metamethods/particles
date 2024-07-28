local vide = require(script.Parent.Parent.Parent.packages.vide)

export type ListProps = {
  layout: vide.vUIListLayout?,
  direction: ("Vertical" | "Horizontal")?,
  padding: UDim?,
}

local function List(props: ListProps): UIListLayout
  return vide.create "UIListLayout" {
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection[props.direction or "Vertical"],
    Padding = props.padding,

    props.layout
  }
end

return List