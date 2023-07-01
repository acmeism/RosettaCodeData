procedure main(A)
    n := integer(!A) | 10
    every r := 2 to (n+1) do write(right(r-1,2),": ",showList(row(r)))
    write()
    every r := 23 | 123 | 1234 | 12345 do write(r," ",cumu(r+1)[-1])
end

procedure cumu(n)
    static cache
    initial cache := [[1]]
    every l := *cache to n do {
        every (r := [0], x := !l) do put(r, r[-1]+cache[1+l-x][1+min(x,l-x)])
        put(cache, r)
        }
    return cache[n]
end

procedure row(n)
    return (r := cumu(n), [: (i := !(*r-1), r[i+1]-r[i]) :]) | r
end

procedure showList(A)
    every (s := "[") ||:= (!A||", ")
    return s[1:-2]||"]"
end
