procedure main(A)
    n := integer(!A) | 3
    write("Magic number: ",n*(n*n+1)/2)
    sq := buildSquare(n)
    showSquare(sq)
end

procedure buildSquare(n)
    sq := [: |list(n)\n :]
    r := 0
    c := n/2
    every i := !(n*n) do {
        /sq[r+1,c+1] := i
        nr := (n+r-1)%n
        nc := (c+1)%n
        if /sq[nr+1,nc+1] then (r := nr,c := nc) else r := (r+1)%n
        }
    return sq
end

procedure showSquare(sq)
    n := *sq
    s := *(n*n)+2
    every r := !sq do every writes(right(!r,s)|"\n")
end
