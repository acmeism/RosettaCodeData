usesletters = filter(n -> begin s = string(n, base = 16); any(c -> c in s, collect("abcdef")) end, 1:500)

foreach(p -> print(rpad(p[2], 4), p[1] % 15 == 0 ? "\n" : ""), enumerate(usesletters))
