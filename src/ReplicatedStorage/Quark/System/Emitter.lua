local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local REPLICATED = {
    "Asset",
    "Lifetime",
    "Size",
    "Drag",
    "Rate",
    "Transparency",

    "Color",

    "Rotation",
    "RotationDirection",
    "RotationSpeed",

    "Velocity",
    "Acceleration",
    "SpawnOffset",

    "Enabled",
}

local EmitterCache = workspace.Terrain:FindFirstChild("EmitterCache")

local Quark = require(ReplicatedStorage.Source.Quark)

--[=[
    @class Emitter

    The Emitter class handles the server-side logic & replication for a particle emitter.
]=]

local Emitter = {}
Emitter.__index = Emitter

export type Emitter = typeof(Emitter)

Emitter.Types = {
    Box = 0,
    Sphere = 1,
    Mesh = 2,
}

--[=[
    @return Emitter

    Creates a new Emitter.
]=]
function Emitter.new(): Emitter
    local self: Emitter = {
        Origin = Vector3.zero,

        EmitterType = Emitter.Types.Box,

        Asset = Quark.GetType("Asset").new(),
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

        _parent = nil,
        _particles = {},
        _cache = nil,
        _attachment = nil,
        _connection = nil,
    }

    setmetatable(self, Emitter)

    if RunService:IsServer() then
        self:Replicate()
    end

    self._connection = RunService.Heartbeat:Connect(function(dt)
        self:Update(dt)
    end)

    return self
end

--[=[
    Sets the parent of the Emitter.

    @param parent Instance -- The new parent of the Emitter
]=]
function Emitter:SetParent(Parent: Instance)
    self._parent = Parent
end

--[=[
    Attaches the Emitter to a BasePart.

    @param Part BasePart -- The BasePart to attach to
]=]
function Emitter:AttachToPart(Part: BasePart)
    self._attachment = Part
end

--[=[
    Creates a cache folder for the Emitter.
]=]
function Emitter:ReplicateFirst()
    local Cache = Instance.new("Folder")
    Cache.Parent = EmitterCache
    self._cache = Cache
end

--[=[
    Replicates the Emitter to the client.
]=]
function Emitter:Replicate()
    if not self._cache then
        self:ReplicateFirst()
    end

    local Cache = self._cache

    for _, Key in ipairs(REPLICATED) do
        local Value = self[Key]

        if type(Value) == "table" then
            Value = Value:Serialize()
        end

        Cache:SetAttribute(Key, Value)
    end
end

--[=[
    Updates the Emitter.
    This is an internal method, do not call this directly.

    @param dt number -- The time since the last update
]=]
function Emitter:Update(dt)
    if not self.Enabled then
        return --// Don't update, better for performance
    end

    local ChangedEmitter = false

    local AttachmentPosition = if self._attachment then self._attachment.Position else nil

    if AttachmentPosition and self.Origin ~= AttachmentPosition then
        self.Origin = AttachmentPosition
        ChangedEmitter = true
    end

    if ChangedEmitter then
        self:Replicate()
    end
end

return Emitter