local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Quark = ReplicatedStorage.Source.Quark

local SystemTester = require(Quark.SystemTester)
local System = require(Quark.System)

local Runtime = {}

function Runtime.Start()
    if #SystemTester.Tests > 0 then
        SystemTester.LoadTests()
        SystemTester.RunTests()

        return
    end


end

return Runtime