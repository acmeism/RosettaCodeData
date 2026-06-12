issteadysquare(n) = (s = "$n"; s == "$(n * n)"[end+1-length(s):end])

println(filter(issteadysquare, 1:10000)) # [1, 5, 6, 25, 76, 376, 625, 9376]
