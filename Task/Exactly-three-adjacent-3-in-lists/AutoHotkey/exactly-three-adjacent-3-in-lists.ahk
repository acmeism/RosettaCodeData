lists := [[9, 3, 3, 3, 2, 1, 7, 8, 5]
        , [5, 2, 9, 3, 3, 7, 8, 4, 1]
        , [1, 4, 3, 6, 7, 3, 8, 3, 2]
        , [1, 2, 3, 4, 5, 6, 7, 8, 9]
        , [4, 6, 8, 7, 2, 3, 3, 3, 1]]

L := []
for i, list in lists
{
    c := cnsctv := 0
    for j, v in list
    {
        cnsctv := (list[j] = 3 && list[j+1] = 3 && list[j+2] = 3) ? true : cnsctv
        c += (v = 3) ? 1 : 0
        L[i] .= (L[i] ? ", " : "" ) . v
    }
    result .= "[" L[i] "] : " (cnsctv && c=3 ? "true" : "false") "`n"
}
MsgBox % result
