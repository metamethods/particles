local vide = require(script.Parent.Parent.packages.vide)
local useStudioTheme = require(script.Parent.useStudioTheme)

type ColorModifier = "Disabled" | "Default" | "Hover" | "Pressed" | "Selected"

local theme = useStudioTheme()

local function useTheme(color: Enum.StudioStyleGuideColor, modifier: (ColorModifier | vide.Source<ColorModifier>)?)
	return function()
		local modifier = if modifier then vide.read(modifier) else nil
		return theme():GetColor(color, modifier)
	end
end

return useTheme