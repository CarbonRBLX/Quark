local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ParticleSystem = ReplicatedStorage.Source.ParticleSystem

local SystemTester = require(ParticleSystem.SystemTester)
local System = require(ParticleSystem.System)

local Runtime = {}

function Runtime.Start()
    if #SystemTester.Tests > 0 then
        SystemTester.LoadTests()
        SystemTester.RunTests()

        return
    end


end

return Runtime