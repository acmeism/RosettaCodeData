sortLetters(str, RemoveSpace := 1){
    oChar := []
    for i, v in StrSplit(str)
        if (v <> " ") && RemoveSpace
            oChar[Asc(v), i] := v
        else if !RemoveSpace
            oChar[Asc(v), i] := v

    for ascii, obj in oChar
        for i, letter in obj
            result .= letter
    return result
}
