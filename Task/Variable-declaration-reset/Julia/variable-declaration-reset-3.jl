s = [1, 2, 2, 3, 4, 4, 5]

for i in eachindex(s)[begin+1:end] # or 2:length(s)
    s[i] == s[i - 1] && println(i)
end
