local Selection = game:GetService("Selection")

local constants = require(script.Parent.Parent.constants)
local vide = require(script.Parent.Parent.packages.vide)
local cleanup = require(script.Parent.Parent.util.cleanup)
local particleEmission = require(script.Parent.Parent.util.particleEmission)
local ParticleEmitter = require(script.Parent.ParticleEmitter)
local Fragment = require(script.Parent.components.Fragment)
local HeaderText = require(script.Parent.components.HeaderText)
local Padding = require(script.Parent.components.Padding)
local ScrollingList = require(script.Parent.components.ScrollingList)
local Text = require(script.Parent.components.Text)
local Toolbar = require(script.Parent.studio.Toolbar)
local ToolbarButton = require(script.Parent.studio.ToolbarButton)
local Widget = require(script.Parent.studio.Widget)

export type AppProps = {
  plugin: Plugin
}

local function App(props: AppProps)
  local enabled = vide.source(false)
  local selectedInstance: vide.Source<Instance?> = vide.source(Selection:Get()[1])
  local totalParticleEmission = vide.source(0)
  
  local selected = function(): boolean
    return selectedInstance() ~= nil
  end

  local particleEmitters = function(): {ParticleEmitter}
    if not selected() then return {} end

    local particleEmitters = {}
    for _, instance in (selectedInstance() :: Instance):GetDescendants() do
      if not instance:IsA("ParticleEmitter") then continue end
      table.insert(particleEmitters, instance)
    end
    return particleEmitters
  end

  local updateTotalParticleEmission = function()
    local total = 0
    for _, particleEmitter in particleEmitters() do
      if not particleEmitter.Enabled then continue end
      total += math.round(particleEmission(particleEmitter))
    end
    totalParticleEmission(total)
  end

  updateTotalParticleEmission()

  local toolbar = Toolbar {
    plugin = props.plugin,
    name = constants.PLUGIN_NAME
  }

  local open = ToolbarButton {
    toolbar = toolbar,
    id = "open",
    text = constants.PLUGIN_NAME,
    tooltip = `Click to toggle the {constants.PLUGIN_NAME} window`,
    icon = constants.PLUGIN_ICON_ID,
    active = enabled,
    onClick = function()
      enabled(not enabled())
    end
  }

  local widget = Widget {
    plugin = props.plugin,
    id = "main",
    title = constants.PLUGIN_NAME,
    dockState = Enum.InitialDockState.Float,
    enabled = enabled,
    floatSize = Vector2.new(400, 300),
    minSize = Vector2.new(200, 200),
    zIndexBehavior = Enum.ZIndexBehavior.Sibling,
    onClose = function()
      enabled(false)
    end,
    children = {
      Fragment {
        children = {
          vide.switch(selected) {
            [true] = function()
              return Fragment {
                children = {
                  ScrollingList {
                    Fragment {
                      children = {
                        Text {
                          text = function()
                            return `Currently selected instance: <b>{(selectedInstance() :: Instance):GetFullName()}</b>`
                          end
                        },
    
                        Text {
                          text = function()
                            return `Total particle/s: <b>{totalParticleEmission()}</b>`
                          end 
                        },
                      }
                    },

                    Fragment {
                      padding = UDim.new(0, 8),
                      children = vide.indexes(particleEmitters, function(particleEmitter)
                        return ParticleEmitter {
                          particleEmitter = particleEmitter,
                          updateTotalParticleEmission = updateTotalParticleEmission
                        }
                      end)
                    }
                  },
            
                  Padding { UDim.new(0, 8) }
                }
              }
            end,
            [false] = function() 
              return vide.create "Frame" {
                Name = "Background",
                Size = UDim2.fromScale(1, 1),

                vide.create "UIGradient" {
                  Color = ColorSequence.new(Color3.new(0, 0, 0)),
                  Transparency = NumberSequence.new(1, .5),
                  Rotation = 90
                },
                
                Text { 
                  text = "Please select an instance to view all of it's particles!" ,
                  layout = {
                    Size = UDim2.fromScale(1, 1),
                    TextXAlignment = Enum.TextXAlignment.Center,
                  }
                },

                Padding { UDim.new(0, 32) }
              }
            end
          }
        }
      }
    }
  }

  vide.cleanup(Selection.SelectionChanged:Connect(function()
    local instance = Selection:Get()[1]
    if not instance or instance:IsA("ParticleEmitter") then return end
    selectedInstance(instance)
  end))

  cleanup(toolbar, open, widget)
end

return App