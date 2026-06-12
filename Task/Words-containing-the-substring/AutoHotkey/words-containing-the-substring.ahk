FileRead, wList, % A_Desktop "\unixdict.txt"
SubString := "the"
list := ContainSubStr(wList, SubString)
for i, v in list
    result .= i "- " v "`n"
MsgBox, 262144, , % result
return

ContainSubStr(wList, SubString){
    oRes := []
    for i, w in StrSplit(wList, "`n", "`r")
    {
        if (StrLen(w) < 12 || !InStr(w, SubString))
            continue
        oRes.Push(w)
    }
    return oRes
}
