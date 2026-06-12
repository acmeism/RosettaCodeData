usesnoletters = filter(n -> begin s = string(n, base = 16); all(c -> c in "abcdef", s) end, 1:500)

foreach(p -> print(rpad(p[2], 4), p[1] % 14 == 0 ? "\n" : ""), enumerate(usesnoletters))
