procedure main(A)
    l := integer(A[1]) | 10
    every writeRow(n := !l, [: mf(!10,n) :])
end

procedure writeRow(n, r)
    writes(right(n,3),": ")
    every writes(right(!r,8)|"\n")
end

procedure mf(n, m)
    if n <= 0 then return 1
    return n*mf(n-m, m)
end
