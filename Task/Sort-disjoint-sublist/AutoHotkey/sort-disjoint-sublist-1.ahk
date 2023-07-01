Sort_disjoint_sublist(Values, Indices){
    A := [], B:=[], C := [], D := []
    for k, v in Indices
        A[v] := 1 , B[Values[v]] := v
    for k, v in A
        C.Push(k)
    for k, v in B
        D.Push(k)
    for k, v in D
        Values[C[A_Index]] := D[A_Index]
    return Values
}
