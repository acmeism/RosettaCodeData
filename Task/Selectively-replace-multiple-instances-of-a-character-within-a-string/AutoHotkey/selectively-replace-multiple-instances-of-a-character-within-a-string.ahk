str := "abracadabra"
steps := [[1, "a", "A"]
        , [2, "a", "B"]
        , [4, "a", "C"]
        , [5, "a", "D"]
        , [1, "b", "E"]
        , [2, "r", "F"]]

MsgBox % result := Selectively_replace(str, steps)
return

Selectively_replace(str, steps){
    Res := [], x := StrSplit(str)
    for i, step in steps {
        n := step.1, L := step.2, R := step.3, k := 0
        for j, v in x
            if (v=L) && (++k = n) {
                Res[j] := R
                break
            }
    }
    for j, v in x
        result .= Res[j] = "" ? x[j] : Res[j]
    return result
}
