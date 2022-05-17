local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ParticleSystem = require(ReplicatedStorage.Source.ParticleSystem)

local Emitter = {}
Emitter.__index = Emitter

Emitter.Types = {
    Box = 0,
    Sphere = 1,
    Mesh = 2,
}

function Emitter.new()
    local self = {
        EmitterType = Emitter.Types.Box,

        Asset = ParticleSystem.GetType("Asset").new(),
        Lifetime = 1,
        Size = 1,
        Drag = 0,
        Rate = 0,
        Transparency = 0,

        Color = Color3.new(1, 1, 1),

        Rotation = CFrame.new(),
        RotationDirection = Vector3.zero,
        RotationSpeed = 0,

        Velocity = Vector3.zero,
        Acceleration = Vector3.zero,
        SpawnOffset = Vector3.zero,

        Enabled = false,

        _particles = {},
    }

    setmetatable(self, Emitter)

    return self
end

return Emitter