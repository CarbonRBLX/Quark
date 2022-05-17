--// Scans Instances to get "particle points" pp :)

local ScanTypes = script.Parent.Scans

local Scanner = {
    _scannerTypes = {
        Mesh = require(ScanTypes.Mesh),
        Part = require(ScanTypes.Part)
    }
}

function Scanner.Scan(Part: BasePart, Frequency: number)
    if Part:IsA("MeshPart") then
        return Scanner._scannerTypes.Mesh.Scan(Part, Frequency)
    end

    return Scanner._scannerTypes.Part.Scan(Part, Frequency)
end

return Scanner