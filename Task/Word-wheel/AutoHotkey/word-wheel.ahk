letters := ["N", "D", "E", "O", "K", "G", "E", "L", "W"]

FileRead, wList, % A_Desktop "\unixdict.txt"
result := ""
for word in Word_wheel(wList, letters, 3)
    result .= word "`n"
MsgBox % result
return

Word_wheel(wList, letters, minL){
    oRes := []
    for i, w in StrSplit(wList, "`n", "`r")
    {
        if (StrLen(w) < minL)
            continue
        word := w
        for i, l in letters
            w := StrReplace(w, l,,, 1)
        if InStr(word, letters[5]) && !StrLen(w)
            oRes[word] := true
    }
    return oRes
}
