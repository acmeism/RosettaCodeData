hasinktok(n) = for k in 1:100000 contains("$(BigInt(k)^k)", "$n") && return k end

foreach(p -> print(rpad(p[2], 4), p[1] % 17 == 0 ? "\n" : ""), enumerate(map(hasinktok, 0:50)))
