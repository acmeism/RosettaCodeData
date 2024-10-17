s = [1, 2, 2, 3, 4, 4, 5]
prev = -1

for i in eachindex(s)
    global prev
    curr = s[i]
    i > 1 && curr == prev && println(i)
    prev = curr
end
