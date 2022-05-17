--// Fixing warnings
local Quark, FireParticle = {}, {}

local System = Quark.new()
local Parent = workspace.FirePlace

local emitter = System.Emitter.new()

emitter.Rate = 5
emitter.Lifetime = System.NumberRange.new(5)
emitter.Transparency = System.NumberRange.new() --// Basically just 0->1 transparency throughout the lifespan of each particle.

emitter:AttachBasePart(FireParticle) --// (1,1,1) sized cube that's red?? idk lol

--// TODO: Think how it would be easy to modify the spinning of a particle.

emitter.SpreadAngle = Vector2.new(10, 10)
emitter.Speed = System.NumberRange.new(5, 10)
emitter.CFrame = CFrame.new(Parent.Position) * CFrame.new(math.rad(90), 0, 0)

emitter:SetParent(Parent)

emitter.Enabled = true