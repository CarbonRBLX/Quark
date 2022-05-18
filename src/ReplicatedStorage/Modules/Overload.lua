--[=[
    @class Overload

    Overloads a function with a new implementation.
]=]
local Overload = {}
Overload.__index = Overload

type Overload = typeof(Overload.new())

--[=[
    @return Overload

    Creates a new Overload.
]=]
function Overload.new(): Overload
    local self = setmetatable({
        _callbacks = {}
    }, Overload)

    return self
end

function Overload:__call(...)
    assert(self._callbacks[1], "Overload doesnt have a valid overload")

    local args = {...}
    local cbp

    for cbk, cbv in pairs(self._callbacks) do
        local _callback, _args = cbv.callback, cbv.args
        if #_args == #args and #args ~= 0 then
            local correct = 0
            for  oargk, oargv in pairs(_args) do
                if oargv == typeof(args[oargk]) then
                    correct += 1
                end
            end
            if correct == #args then
                cbp = cbk
            end
        elseif #_args == 0 and #args == 0 then
            _callback(...)
        end
    end

    assert(cbp, "Provided variables dont have a valid overload")

    return self._callbacks[cbp]['cb'](...)
end

--[=[
    Registers a callback to the overload

    @param Callback function -- The callback to register
    @param Args table -- The types to check against
    @return Overload -- The overload itself for chaining

    ```lua
    local addNumbers = Overload.new()

    addNumbers:Register(function(a, b)
        return a + b
    end, { typeof(1), typeof(2) })

    addNumbers:Register(function(a, b, c)
        return a + b + c
    end, { typeof(1), typeof(2), typeof(3) })

    addNumbers(1, 2) -- 3
    addNumbers(1, 2, 3) -- 6
    ```
]=]
function Overload:Register(Callback: () -> (), Args: table): nil
    assert(typeof(Callback) == "function", "Provide a valid callback")

    table.insert(self._callbacks, {
        callback = Callback,
        args = Args
    })

    return self
end

return function()
    return Overload.new()
end