local MeshScan = {}

local RNG = Random.new()

local MeshParams = OverlapParams.new()
MeshParams.FilterType = Enum.RaycastFilterType.Whitelist

local function GetTouchDetector()
    local Part = Instance.new("Part")
    Part.Size = Vector3.one * 0.5
    Part.Shape = Enum.PartType.Ball
    Part.CanCollide = true
    Part.Transparency = 1
    Part.Anchored = true

    return Part
end

function MeshScan.IsPointInMesh(Mesh: MeshPart, Part: Part, Point: Vector3)
    MeshParams.FilterDescendantsInstances = {Part}

    Part.Position = Mesh.CFrame:PointToWorldSpace(Point)
    return #workspace:GetPartsInPart(Mesh, MeshParams) > 0
end

--// Same as in Scans.Part
function MeshScan.GetPointInCube(Size: Vector3)
    local X2, Y2, Z2 = Size.X, Size.Y, Size.Z
    local X, Y, Z = X2 * 0.5, Y2 * 0.5, Z2 * 0.5

    return Vector3.new(
        RNG:NextNumber(-X, X),
        RNG:NextNumber(-Y, Y),
        RNG:NextNumber(-Z, Z)
    ) --// Pretty simple.
end

function MeshScan.GetValidPoint(Mesh: MeshPart, Part: Part)
    local Candidate = MeshScan.GetPointInCube(Mesh.Size)

    --if true then return Candidate end
    if MeshScan.IsPointInMesh(Mesh, Part, Candidate) then
        return Candidate
    end
end

function MeshScan.ScanMesh(Mesh: MeshPart, Frequency: number)
    local Points = {}

    local Part = GetTouchDetector()
    Part.Parent = workspace

    for _ = 1, Frequency do
        local Tries = 0

        repeat
            local Candidate = MeshScan.GetValidPoint(Mesh, Part)
            if Candidate then
                table.insert(Points, Candidate)
                break
            end

            Tries += 1
        until Tries >= 3
    end

    Part:Destroy()

    local FailedPoints = Frequency - #Points
    if FailedPoints > 0 then
        warn("Failed to find " .. FailedPoints .. " points. Expected: " .. Frequency)
    end

    return Points
end

function MeshScan.Scan(Part: MeshPart, Frequency: number)
    return MeshScan.ScanMesh(Part, Frequency)
end

return MeshScan