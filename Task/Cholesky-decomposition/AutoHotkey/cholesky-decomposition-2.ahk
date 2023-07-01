A := [[25, 15, -5]
    , [15, 18,  0]
    , [-5, 0 , 11]]
L1 := Cholesky_Decomposition(A)

A := [[18, 22,  54,  42]
    , [22, 70,  86,  62]
    , [54, 86, 174, 134]
    , [42, 62, 134, 106]]
L2 := Cholesky_Decomposition(A)

MsgBox % Result := ShowMatrix(L1) "`n----`n" ShowMatrix(L2) "`n----"
return
