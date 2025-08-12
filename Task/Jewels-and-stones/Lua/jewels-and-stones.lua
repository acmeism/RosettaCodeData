function count_jewels(s, j)
    local count = 0
    for i=1,#s do
        if j:match(s:sub(i,i)) then
            count = count + 1
        end
    end
    return count
end

print(count_jewels("aAAbbbb", "aA"))
print(count_jewels("ZZ", "z"))
