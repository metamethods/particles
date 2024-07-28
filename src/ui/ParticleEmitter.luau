local Selection = game:GetService("Selection")

local vide = require(script.Parent.Parent.packages.vide)
local useTheme = require(script.Parent.Parent.util.useTheme)
local Button = require(script.Parent.components.Button)
local Fragment = require(script.Parent.components.Fragment)
local HeaderText = require(script.Parent.components.HeaderText)
local Round = require(script.Parent.components.Round)
local Text = require(script.Parent.components.Text)

type ParticleInformation = {
  name: string,
  rate: number,
  timeScale: number,
  lifetime: NumberRange,
  enabled: boolean
}

export type ParticleEmitterProps = {
  particleEmitter: vide.Source<ParticleEmitter>,
  updateTotalParticleEmission: () -> ()
}

local function ParticleEmitter(props: ParticleEmitterProps): TextButton
  local particleInformation: vide.Source<ParticleInformation> = vide.source()

  local updateParticleInformation = function()
    local particleEmitter = props.particleEmitter()
    particleInformation({
      name = particleEmitter.Name,
      rate = particleEmitter.Rate,
      timeScale = particleEmitter.TimeScale,
      lifetime = particleEmitter.Lifetime,
      enabled = particleEmitter.Enabled
    })
    props.updateTotalParticleEmission()
  end

  local particleEmission = function()
    local particleInformation = particleInformation()
    return (math.clamp(particleInformation.rate, 0, 500) * particleInformation.timeScale) * 
      ((particleInformation.lifetime.Min + particleInformation.lifetime.Max) / 2)
  end

  updateParticleInformation()

  vide.cleanup(props.particleEmitter().Changed:Connect(updateParticleInformation))

  return Button {
    onClicked = function()
      Selection:Set({ props.particleEmitter() })
    end,

    layout = {
      Size = UDim2.fromScale(1, 0),
      AutomaticSize = Enum.AutomaticSize.Y,
      LayoutOrder = function() return -particleEmission() end,
    },
    children = {
      vide.create "ImageLabel" {
        Name = "Texture",
        Size = UDim2.fromOffset(100, 100),
        BackgroundColor3 = useTheme(Enum.StudioStyleGuideColor.MainBackground),

        Image = props.particleEmitter().Texture,

        Round {}
      },

      Fragment {
        layout = {
          Size = UDim2.new(1, -108, 1, 0),
          AnchorPoint = Vector2.new(1, 0),
          Position = UDim2.fromScale(1, 0)
        },
        children = {
          HeaderText {
            text = function()
              return `{particleInformation().name} {not particleInformation().enabled and "<font color='#ff5555'><b>[DISABLED]</b></font>" or ""}`
            end
          },
          Text {
            text = function()
              return `Particle/s: <b>{particleEmission()}</b>`
            end
          },
          Text {
            text = function()
              return `Rate: <b>{particleInformation().rate}</b>`
            end
          },
          Text {
            text = function()
              local lifetime = particleInformation().lifetime
              return `Lifetime: <b>{lifetime.Min}</b> - <b>{lifetime.Max}</b>`
            end
          }
        }
      }
    }
  }
end

return ParticleEmitter