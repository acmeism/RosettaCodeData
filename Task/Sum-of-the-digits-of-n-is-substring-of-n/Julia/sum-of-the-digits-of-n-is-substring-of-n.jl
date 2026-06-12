issumsub(n, base=10) = occursin(string(sum(digits(n, base=base)), base=base), string(n, base=base))

foreach(p -> print(rpad(p[2], 4), p[1] % 10 == 0 ? "\n" : ""), enumerate(filter(issumsub, 0:999)))
