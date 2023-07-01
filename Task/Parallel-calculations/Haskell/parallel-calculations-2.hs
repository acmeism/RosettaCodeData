procedure main(A)
    threads := []
    L := list(*A)
    every i := 1 to *A do put(threads, thread L[i] := primedecomp(A[i]))
    every wait(!threads)

    maxminF := L[maxminI := 1][1]
    every i := 2 to *L do if maxminF <:= L[i][1] then maxminI := i
    every writes((A[maxminI]||": ")|(!L[maxminI]||" ")|"\n")
end

procedure primedecomp(n)         #: return a list of factors
    every put(F := [], genfactors(n))
    return F
end

link factors
