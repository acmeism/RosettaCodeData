;--------------------------
LU_decomposition(A){
    P := Pivot(A)
    A_ := Multiply_Matrix(P, A)

    U := [], L := [], n := A_.Count()
    loop % n {
        i := A_Index
        loop % n {
            j := A_Index

            Sigma := 0, k := 1
            while (k <= i-1)
                Sigma += (U[k, j] * L[i, k]), k++
            U[i, j] := A_[i, j] - Sigma

            Sigma := 0, k := 1
            while (k <= j-1)
                Sigma += (U[k, j] * L[i, k]), k++
            L[i, j] := (A_[i, j] - Sigma) / U[j, j]
        }
    }
    return [L, U, P]
}
;--------------------------
Pivot(M){
    n := M.Count(), P := [], i := 0
    while (i++ < n){
        P.push([])
        j := 0
        while (j++ < n)
            P[i].push(i=j ? 1 : 0)
    }
    i := 0
    while (i++ < n){
        maxm := M[i, i], row := i, j := i
        while (j++ < n)
            if (M[j, i] > maxm)
                maxm := M[j, i], row := j
        if (i != row)
            tmp := P[i], P[i] := P[row], P[row] := tmp
    }
    return P
}
;--------------------------
Multiply_Matrix(A,B){
    if (A[1].Count() <> B.Count())
        return
    RCols := A[1].Count()>B[1].Count()?A[1].Count():B[1].Count()
    RRows := A.Count()>B.Count()?A.Count():B.Count(),     R := []
    Loop, % RRows {
        RRow:=A_Index
        loop, % RCols {
            RCol:=A_Index,            v := 0
            loop % A[1].Count()
                col := A_Index,        v += A[RRow, col] * B[col,RCol]
            R[RRow,RCol] := v
        }
    }
    return R
}
;--------------------------
ShowMatrix(L, f:=3){
    for r, obj in L{
        row := ""
        for c, v in obj
            row .= Format("{:." f "f}", v) ", "
        output .= "[" trim(row, ", ") "]`n,"
    }
    return "[" Trim(output, "`n,") "]"
}
;--------------------------
