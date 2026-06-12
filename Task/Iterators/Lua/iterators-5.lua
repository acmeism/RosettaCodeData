-- iters.lua
---@param n integer
---@param iterator function
local function nth(n, iterator, state, initial_key)
    local key, value = iterator(state, initial_key)
    for _ = n - 1, 1, -1 do
        key, value = iterator(state, key)
        if key == nil then return end
    end
    return key, value
end

---@param n integer
---@param iterator function
local function nth_last(n, iterator, state, initial_key)
    local values = {}
    for _, value in iterator, state, initial_key do
        table.insert(values, 1, value)
        if #values > n then
            table.remove(values)
        end
    end
    return values[n]
end
return { nth = nth, nth_last = nth_last }
