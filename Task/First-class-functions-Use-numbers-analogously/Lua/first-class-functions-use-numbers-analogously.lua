-- This function returns another function that
-- keeps n1 and n2 in scope, ie. a closure.
function multiplier (n1, n2)
    return  function (m)
                return n1 * n2 * m
            end
end

-- Multiple assignment a-go-go
local x, xi, y, yi  = 2.0, 0.5, 4.0, 0.25
local z, zi = x + y, 1.0 / ( x + y )
local nums, invs = {x, y, z}, {xi, yi, zi}

-- 'new_function' stores the closure and then has the 0.5 applied to it
-- (this 0.5 isn't in the task description but everyone else used it)
for k, v in pairs(nums) do
    new_function = multiplier(v, invs[k])
    print(v .. " * " .. invs[k] .. " * 0.5 = " .. new_function(0.5))
end
