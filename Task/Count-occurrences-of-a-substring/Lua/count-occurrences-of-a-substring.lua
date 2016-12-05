function countSubstring (s1, s2)
    local count = 0
    for eachMatch in s1:gmatch(s2) do count = count + 1 end
    return count
end

print(countSubstring("the three truths", "th"))
print(countSubstring("ababababab","abab"))
