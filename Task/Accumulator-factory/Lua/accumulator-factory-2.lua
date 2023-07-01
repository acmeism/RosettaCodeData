do
    local accSum = 0;               -- accumulator factory 'upvalue'
    function acc(v)                 -- the accumulator factory
        accSum = accSum + (v or 0)  -- increment factory sum

        local closuredSum = accSum;               -- new 'upvalue' at each factory call
        return function (w)                       -- the produced accumulator function
            closuredSum = closuredSum + (w or 0)  -- increment product 'upvalue'
            return closuredSum                    -- return 'upvalue'
        end, accSum                               -- end of product closure

    end--acc
end--end of factory closure
