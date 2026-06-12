for i, v in [8, 9]
    result .= "Matrix Size: " v "*" v "`n" matrix2txt(mosaicMatrix(v)) "`n"
MsgBox % result
return

mosaicMatrix(size){
    M := []
    loop % size {
        row := A_Index
        loop % size
            M[row, A_Index] := (Toggle:=!Toggle)  ? 1 : 0
            , toggle := (A_Index = size && size/2 = floor(size/2)) ? !toggle : toggle
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
