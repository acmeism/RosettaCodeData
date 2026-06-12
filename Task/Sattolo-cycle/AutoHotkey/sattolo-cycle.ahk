loop 3
{
    testCases:= [[]
                ,[10]
                ,[10, 20]
                ,[10, 20, 30]
                ,[11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]]

    for n, items in testCases
    {
        Sattolo_cycle(items)
        res := "["
        for m, v in items
            res .= v ", "
        result .= Trim(res, ", ") "]`n"
    }
    result .= "`n"
}
MsgBox % result
return

Sattolo_cycle(ByRef items){
    i := items.Count()
    while (i>1)
    {
        Random, j, 1, i-1
        t := items[i], items[i] := items[j], items[j] := t
        i--
    }
}
