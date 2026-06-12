dhstring(N) = [i for i in 0:N if sort(unique(digits(i))) == sort(unique(digits(i, base=16)))]

foreach(p -> print(rpad(p[2], 6), p[1] % 10 == 0 ? "\n" : ""), enumerate(dhstring(100000)))
