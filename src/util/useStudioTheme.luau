local vide = require(script.Parent.Parent.packages.vide)
local studio = settings():GetService("Studio")

local theme = vide.source(studio.Theme)

studio.ThemeChanged:Connect(function()
  theme(studio.Theme)
end)

local function useStudioTheme(): vide.Source<StudioTheme>
  return theme
end

return useStudioTheme