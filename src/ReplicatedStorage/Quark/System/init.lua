local Quark = {}

function Quark.GetType(Type: string)
    return require(script.Types:FindFirstChild(Type))
end

function Quark.GetClass(Class: string)
    return require(script:FindFirstChild(Class))
end

return Quark