local Asset = {}
Asset.__index = Asset

Asset.Types = {
    Decal = 0,
    Texture = 1,
    Mesh = 2,
    Sound = 3,
    Empty = 4,
}

function Asset.new(Type: number, Value: any)
    local self = {
        Type = Type or Asset.Types.Empty,
        Value = Value, --// WARNING: This *could* be nil.
    }

    setmetatable(self, Asset)

    return self
end

return Asset