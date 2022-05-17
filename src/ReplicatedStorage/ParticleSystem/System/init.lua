local ParticleSystem = {}

function ParticleSystem.GetType(Type: string)
    return require(script.Types:FindFirstChild(Type))
end

function ParticleSystem.GetClass(Class: string)
    return require(script:FindFirstChild(Class))
end

return ParticleSystem