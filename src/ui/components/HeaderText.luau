local Text = require(script.Parent.Text)

local function HeaderText(props: Text.TextProps): TextLabel
  return Text {
    text = props.text,
    layout = {
      TextSize = 24,
      FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold),

      props.layout
    }
  }
end

return HeaderText