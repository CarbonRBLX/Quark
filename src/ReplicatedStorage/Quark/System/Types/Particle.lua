local Particle = {}
Particle.__index = Particle

function Particle.new(Emitter)
    local self = {
        Emitter = Emitter,
        Position = Vector3.new(),
    }

    setmetatable(self, Particle)

    return self
end

return Particle