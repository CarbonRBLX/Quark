--[=[
    @class Asset

    Holds information about an assets. Used by the Renderer to create & draw particles.
]=]
local Asset = {}
Asset.__index = Asset

export type Asset = typeof(Asset)

Asset.Types = {
    Decal = 0,
    Texture = 1,
    Mesh = 2,
    Sound = 3,
    Empty = 4,
}

--[=[
    @return Asset

    @param Type number --- The type of the asset (see Asset.Types).
    @param Value string --- The asset id.
    @param Texture string --- The texture of the asset.

    Creates a new Asset.
]=]
function Asset.new(Type: number, Value: string?, Texture: string?)
    local self = {
        Type = Type or Asset.Types.Empty,
        Value = Value, --// WARNING: This *could* be nil
        Texture = Texture, --// This will be nil in all cases except for Asset.Types.Mesh
    }

    setmetatable(self, Asset)

    return self
end

--[=[
    @return Asset

    Creates a new Asset from a Serialized string.
]=]
function Asset.fromSerialized(Serialized: string): Asset
    local Data = string.split(Serialized, ":")

    local Type = Asset.Types[Data[1]]
    local Name = Data[2]
    local Texture = Data[3]

    return Asset.new(tonumber(Type), Name, Texture)
end

--[=[
    @return string

    Serializes an Asset into a string, to be replicated.
]=]
function Asset:Serialize()
    return string.format("%d:%s:%s", self.Type, self.Value, self.Texture)
end

return Asset