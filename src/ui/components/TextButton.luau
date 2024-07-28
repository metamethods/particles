local Button = require(script.Parent.Button)
local vide = require(script.Parent.Parent.Parent.packages.vide)
local Text = require(script.Parent.Text)

export type TextButtonProps = {
  text: string,
  textLayout: vide.vTextLabel?
} & Button.ButtonProps

local function TextButton(props: TextButtonProps): TextButton
  return Button {
    disabled = props.disabled,
    onClicked = props.onClicked,
    layout = props.layout,
    children = {
      Text {
        text = props.text,
        props.textLayout
      },

      props.children
    },
  }
end

return TextButton