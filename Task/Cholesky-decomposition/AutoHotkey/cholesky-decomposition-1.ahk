Cholesky_Decomposition(A){
    L := [], n := A.Count()
    L[1,1] := Sqrt(A[1,1])
    loop % n {
        k := A_Index
        loop % n-1 {
            i := A_Index+1

            Sigma := 0, j := 0
            while (++j <= k-1)
                Sigma += L[i, j] * L[k, j]
            L[i, k] := (A[i, k] - Sigma) / L[k, k]

            Sigma := 0, j := 0
            while (++j <= k-1)
                Sigma += (L[k, j])**2
            L[k, k] := Sqrt(A[k, k] - Sigma)
        }
    }
    loop % n{
        k := A_Index
        loop % n
            L[k, A_Index] := L[k, A_Index] ? L[k, A_Index] : 0
    }
    return L
}
ShowMatrix(L){
    for r, obj in L{
        row := ""
        for c, v in obj
            row .= Format("{:.3f}", v) ", "
        output .= "[" trim(row, ", ") "]`n,"
    }
    return "[" Trim(output, "`n,") "]"
}
