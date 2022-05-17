local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Quark = require(ReplicatedStorage.Source.Quark)

local function NumberSequenceTest()
    local Sequence = Quark.GetType("NumberSequence").new({
        {0, 0},
        {0.2, .8},
        {0.7, .8},
        {1, 1}
    })

    local Part = workspace.Tests.NumberSequence
    local Start = Part.Position
    local End = Part.Position + Vector3.new(-20, 0, 10)

    local StartColor = Part.Color
    local EndColor = Color3.new(0, 1, 0)

    Sequence:Start(function(Number)
        Part.Color = StartColor:Lerp(EndColor, Number)
        Part.Position = Start:Lerp(End, Number)
    end):ConnectOnce(function()
        print("Sequence finished")
    end)

    return true
end

return NumberSequenceTest