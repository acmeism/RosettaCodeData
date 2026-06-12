FileRead, db, % A_Desktop "\unixdict.txt"
for i, word in StrSplit(db, "`n", "`r")
    if StrLen(word) < 6
        continue
    else if (SubStr(word, 1, 3) = SubStr(word, -2))
        result .= word "`n"
MsgBox, 262144, , % result
return
