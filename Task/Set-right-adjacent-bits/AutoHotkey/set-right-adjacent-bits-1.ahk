setRight(num, n){
    x := StrSplit(num)
    for i, v in StrSplit(num)
        if v
            loop, % n
                x[i+A_Index] := 1
    Loop % n
        x.removeAt(StrLen(num)+1)
    for i, v in x
        res .= v
    return res
}
