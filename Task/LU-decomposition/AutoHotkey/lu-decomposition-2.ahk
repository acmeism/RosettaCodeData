A1 := [[1, 3, 5]
    , [2, 4, 7]
    , [1, 1, 0]]

A2 := [[11, 9, 24, 2]
    ,[1, 5, 2, 6]
    ,[3, 17, 18, 1]
    ,[2, 5, 7, 1]]

loop 2 {
    L := LU_Decomposition(A%A_Index%)
    result .= ""
    . "A:=`n" ShowMatrix(A%A_Index%, 4)
    . "`n`nL:=`n" ShowMatrix(L.1)
    . "`n`nU:=`n" ShowMatrix(L.2)
    . "`n`nP:=`n" ShowMatrix(L.3)
    . "`n--------------------------------`n"
}
MsgBox, 262144, , % result
return
