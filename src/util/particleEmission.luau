local function particleEmission(particleEmitter: ParticleEmitter): number
  return (math.clamp(particleEmitter.Rate, 0, 500) * particleEmitter.TimeScale) * ((particleEmitter.Lifetime.Min + particleEmitter.Lifetime.Max) / 2)
end

return particleEmission