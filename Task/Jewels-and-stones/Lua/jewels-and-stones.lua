function count_jewels(s, j)
    local count = 0
    for i=1,#s do
        local c = s:sub(i,i)
        if string.match(j, c) then
            count = count + 1
        end
    end
    return count
end

print(count_jewels("aAAbbbb", "aA"))
print(count_jewels("ZZ", "z"))
