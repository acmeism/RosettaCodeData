function countSubstring(s1, s2)
    return select(2, s1:gsub(s2, ""))
end

print(countSubstring("the three truths", "th"))
print(countSubstring("ababababab", "abab"))
