for key, value in iterate(data_structure) do
    print(key, value)
end

local iterator, state, initial_key = iterate(data_structure)
local key, value = iterator(state, initial_key)
while key ~= nil do
    print(key, value)
    key, value = iterator(state, key)
end
