function twoSum (numbers, sum)
    local i, j, s = 1, #numbers
    while i < j do
        s = numbers[i] + numbers[j]
        if s == sum then
            return {i, j}
        elseif s < sum then
            i = i + 1
        else
            j = j - 1
        end
    end
    return {}
end

print(table.concat(twoSum({0,2,11,19,90}, 21), ","))
