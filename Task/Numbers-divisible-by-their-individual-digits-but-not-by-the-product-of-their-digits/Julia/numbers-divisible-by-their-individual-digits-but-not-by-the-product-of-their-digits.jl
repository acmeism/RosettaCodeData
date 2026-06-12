isonlydigdivisible(n) = (d = digits(n); !(0 in d) && all(x -> n % x == 0, d) && n % prod(d) != 0)

foreach(p -> print(rpad(p[2], 5), p[1] % 15 == 0 ? "\n" : ""), enumerate(filter(isonlydigdivisible, 1:1000)))
