function copy (t)
    local new = {}
    for k, v in pairs(t) do new[k] = v end
    return new
end

function jortSort (array)
    local originalArray = copy(array)
    table.sort(array)
    for i = 1, #originalArray do
        if originalArray[i] ~= array[i] then return false end
    end
    return true
end
