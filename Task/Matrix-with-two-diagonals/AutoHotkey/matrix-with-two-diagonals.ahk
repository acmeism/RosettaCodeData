for i, v in [8, 9]
    result .= "Matrix Size: " v "*" v "`n" matrix2txt(diagonalMatrix(v)) "`n"
MsgBox % result
return

diagonalMatrix(size){
    M := []
    loop % size {
        row := A_Index
        loop % size
            M[row, A_Index] := (row = A_Index || row = size-A_Index+1)  ? 1 : 0
    }
    return M
}

matrix2txt(M){
    for row , obj in M {
        for col, v in obj
            result .= M[row, col] "  "
        result .= "`n"
    }
    return result
}
