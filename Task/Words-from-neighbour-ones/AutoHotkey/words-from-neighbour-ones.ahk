FileRead, wList, % A_Desktop "\unixdict.txt"
for word in neighbour(wList)
    result .= word (Mod(A_Index, 6) ? "`t" : "`n")
MsgBox, 262144, , % result
return

neighbour(wList){
    words := [], wordExist := [], oRes := []
    for i, w in StrSplit(wList, "`n", "`r")
    {
        if (StrLen(w) < 9)
            continue
        words.Push(w)
        wordExist[w] := true
    }
    loop % words.Count()-9
    {
        n := A_Index
        newword := ""
        loop 9
            newword .= SubStr(words[n+A_Index-1], A_Index, 1)
        if wordExist[newword]
            oRes[newword] := true
    }
    return oRes
}
