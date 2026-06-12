local function my_ipairs_iterate(list, index)
    index = index + 1
    local value = list[index]
    if value ~= nil then
        return index, value
    end
end

function my_ipairs(list)
    return my_ipairs_iterate, list, 0
end
