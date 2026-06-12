palinbases(n, bases = [2, 4, 16]) = all(b -> (d = digits(n, base = b); d == reverse(d)), bases)

foreach(p -> print(rpad(p[2], 7), p[1] % 11 == 0 ? "\n" : ""), enumerate(filter(palinbases, 1:25000)))
