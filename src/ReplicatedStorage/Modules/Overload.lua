local Overload = {}
Overload.__index = Overload

type Overload = typeof(Overload.new())


function Overload.new(): Overload
    local self = setmetatable({_callbacks = {}}, Overload)
    return self
end

function Overload:__call(...)
    assert(self._callbacks[1], "Overload doesnt have a valid overload")
    local args = {...} --Only used to be able to access, not passed into callback (satisfy complier smh)
    local cbp

    for cbk, cbv in pairs(self._callbacks) do --cb[k/v] - Overload Table key/value
        if #cbv['args'] == #args and #args ~= 0 then
            local correct = 0
            for  oargk, oargv in pairs(cbv['args']) do --oarg[k/v] - Overload Argument key/value
                if oargv == typeof(args[oargk]) then
                    correct += 1
                end
            end
            if correct == #args then
                cbp = cbk
            end
        elseif #cbv['args'] == 0 and #args == 0 then --Faster to use 2 zeros rather than counting a table
            cbv['cb'](...)
        end
    end

    assert(cbp, "Provided variables dont have a valid overload")

    return self._callbacks[cbp]['cb'](...)
end

function Overload:AddOverload(Callback, args: any): nil
    assert(typeof(Callback) == "function", "Provide a valid callback") -- Have to do this check since luau doesn't allow a function as a typecheck even though a type for it exists :shrug:

    self._callbacks[#self._callbacks + 1] = {
        ['cb'] = Callback;
        ['args'] = args;
    }

    return self
end

return function()
    return Overload.new()
end