local vide = require(script.Parent.Parent.Parent.packages.vide)
local types = require(script.Parent.Parent.Parent.types)
local useTheme = require(script.Parent.Parent.Parent.util.useTheme)

export type TextProps = {
  text: types.SourcedAs<string>,
  layout: vide.vTextLabel?
}

local function Text(props: TextProps): TextLabel
  return vide.create "TextLabel" {
    Name = "Text",
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 0),
    AutomaticSize = Enum.AutomaticSize.XY,

    Text = props.text,
    RichText = true,
    TextColor3 = useTheme(Enum.StudioStyleGuideColor.MainText),
    TextSize = 16,
    FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium),
    TextXAlignment = Enum.TextXAlignment.Left,
    TextWrapped = true,

    props.layout
  }
end

return Text