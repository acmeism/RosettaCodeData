function my_ipairs_stateful(list)
    local i = 0
    return function()
        i = i + 1
        local v = list[i]
        if v ~= nil then
            return i, v
        end
    end
end
