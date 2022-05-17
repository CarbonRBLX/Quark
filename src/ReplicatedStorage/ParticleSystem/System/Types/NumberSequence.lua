local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Signal = require(ReplicatedStorage.Source.Modules.Signal)
local Overload = require(ReplicatedStorage.Source.Modules.Overload)

local function Lerp(t, p0, p1)
    return (1 - t) * p0 + t * p1
end

local NumberSequence = {}
NumberSequence.__index = NumberSequence

function NumberSequence.new(...)
    local Values = {}

    Overload():AddOverload(function(Table)
        Values = Table
    end, {typeof(Values)}):AddOverload(function(Value)
        Values = {0, Value}
    end, {typeof(0)}):AddOverload(function(N0, N1)
        Values = {
            {0, N0},
            {1, N1}
        }
    end, {typeof(0), typeof(0)})(...)

    if #Values == 0 then
        return error("No value inputs in \"NumberSequence.new\".")
    end

    local Length = Values[#Values][1]

    local self = setmetatable({
        Number = 0,
        StepUpdated = Signal.new(),

        _finished = Signal.new(),

        _alpha = 0, --// 0 -> Length
        _length = Length,
        _values = Values,

        _baseIndex = 1,

        _base = 1,
        _lerp = if Values[2] then 2 else 1,
    }, NumberSequence)

    return self
end

function NumberSequence:GetIndexAt(Timestamp: number)
    local Index = 1

    for i = 1, #self._values do
        if Timestamp < self._values[i][1] then
            Index = i - 1
            break
        end
    end

    return Index
end

function NumberSequence:GetValueAt(Timestamp: number)
    local Index = self:GetIndexAt(Timestamp)

    if Index == #self._values then
        return self._values[Index][2]
    end

    local Base = self._values[Index]
    local Target = self._values[Index + 1]

    return Lerp((Timestamp - Base[1]) / (Target[1] - Base[1]), Base[2], Target[2])
end

function NumberSequence:Start(Callback)
    self:Reset()

    self._connection = RunService.Heartbeat:Connect(function(dt)
        if self._alpha >= self._length then
            self._finished:Fire()
            return self._connection:Disconnect()
        end

        self:_update(dt)

        if Callback then
            Callback(self.Number)
        end
    end)

    return self._finished
end

function NumberSequence:Reset()
    if self._connection then
        self._connection:Disconnect()
    end

    self._alpha = 0
    self.Number = 0
end

function NumberSequence:Destroy()
    if self._connection then
        self._connection:Destroy()
    end

    setmetatable(self, nil)

    self = nil
end

function NumberSequence:_update(dt)
    self._alpha = math.min(self._alpha + dt, self._length)

    local Alpha = self._alpha
    local Base, Target = self._values[self._base], self._values[self._lerp]

    if Alpha >= Target[1] then
        self._baseIndex += 1

        self._base = self._lerp
        self._lerp = math.clamp(self._baseIndex + 1, 1, #self._values)

        Base, Target = self._values[self._base], self._values[self._lerp]
        self.Number = Target[2]

        self.StepUpdated:Fire(Base, Target)
    end

    local BaseValue, TargetValue = Base[2], Target[2]
    local BaseTime, TargetTime = Base[1], Target[1]

    if BaseValue == TargetValue then
        --// No lerp necessary, already at destination. Just wait out the duration.
        return
    end

    self.Number = Lerp((self._alpha - BaseTime) / (TargetTime - BaseTime), BaseValue, TargetValue)
end

return NumberSequence