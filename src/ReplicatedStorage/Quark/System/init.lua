local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SystemTester = require(ReplicatedStorage.Source.Quark.SystemTester)

local Quark = {}

function Quark.ServerStart()
    local EmitterCache = Instance.new("Folder")
    EmitterCache.Name = "EmitterCache"
    EmitterCache.Parent = workspace.Terrain

    if #SystemTester.Tests > 0 then
        SystemTester.LoadTests()
        SystemTester.RunTests()
    end
end

function Quark.GetType(Type: string)
    return require(script.Types:FindFirstChild(Type))
end

function Quark.GetClass(Class: string)
    return require(script:FindFirstChild(Class))
end

return Quark