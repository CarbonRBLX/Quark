local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Objects = workspace.Objects
local Information = ReplicatedStorage.Source.Quark.Information

local Scanner = require(Information.Scanner)

local function TestScan(ScanObject)
    local Points = Scanner.Scan(ScanObject, 1000)

    for _, Point in ipairs(Points) do
        local Attachment = Instance.new("Attachment")
        Attachment.Visible = true
        Attachment.Position = Point
        Attachment.Parent = ScanObject
    end

    return #Points > 0
end

local function ScansTest()
    return TestScan(Objects.Triangle) and TestScan(Objects.Part)
end

return ScansTest