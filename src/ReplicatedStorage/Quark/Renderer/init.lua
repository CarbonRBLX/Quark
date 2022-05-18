
local EmitterCache = workspace.Terrain:WaitForChild("EmitterCache")

local Renderer = {}
Renderer.__index = Renderer

function Renderer.new(Emitter)
    local self = {

    }

    setmetatable(self, Renderer)

    return self
end

return Renderer