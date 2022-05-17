local PartScan = {}

local RNG = Random.new()

function PartScan.GetPointInSphere(Radius: number)
    local X = RNG:NextNumber(-Radius, Radius)
    local Y = RNG:NextNumber(-Radius, Radius)
    local Z = RNG:NextNumber(-Radius, Radius)

    local Vector = Vector3.new(X, Y, Z)
    return Vector.Unit * RNG:NextNumber() * Radius
end

function PartScan.GetPointInCube(Size: Vector3)
    local X2, Y2, Z2 = Size.X, Size.Y, Size.Z
    local X, Y, Z = X2 * 0.5, Y2 * 0.5, Z2 * 0.5

    return Vector3.new(
        RNG:NextNumber(-X, X),
        RNG:NextNumber(-Y, Y),
        RNG:NextNumber(-Z, Z)
    ) --// Pretty simple.
end

function PartScan.ScanSphere(Sphere: Part, Frequency: number)
    local Points = {}

    local Radius = Sphere.Size.X * 0.5

    for _ = 1, Frequency do
        table.insert(Points, PartScan.GetPointInSphere(Radius))
    end

    return Points
end

function PartScan.ScanCube(Cube: Part, Frequency: number)
    local Points = {}

    for _ = 1, Frequency do
        table.insert(Points, PartScan.GetPointInCube(Cube.Size))
    end

    return Points
end

function PartScan.Scan(Part: Part, Frequency: number)
    local Method = if Part.Shape == Enum.PartType.Ball then PartScan.ScanSphere else PartScan.ScanCube

    return Method(Part, Frequency)
end

return PartScan