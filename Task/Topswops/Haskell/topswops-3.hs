procedure main()
    every n := 1 to 10 do {
        ts := 0
        every (ts := 0) <:= swop(permute([: 1 to n :]))
        write(right(n, 3),": ",right(ts,4))
        }
end

procedure swop(A)
    count := 0
    while A[1] ~= 1 do {
        A := reverse(A[1+:A[1]]) ||| A[(A[1]+1):0]
        count +:= 1
        }
    return count
end

procedure permute(A)
    if *A <= 1 then return A
    suspend [(A[1]<->A[i := 1 to *A])] ||| permute(A[2:0])
end
