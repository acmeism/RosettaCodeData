FileRead, db, % A_Desktop "\unixdict.txt"
oWord := [], Found := []
for i, word in StrSplit(db, "`n", "`r")
    if (StrLen(word) > 11)
        oWord[word] := true

for word1 in oWord
    for word2 in oWord
        if Changeable(word1, word2) && !Found[word2]
            found[word1] := true, result .= word1 . "`t<-> " word2 "`n"

MsgBox, 262144, , % result
return

Changeable(s1, s2) {
    if (StrLen(s1) <> StrLen(s2))
        return 0
    for i, v in StrSplit(s1)
        if (v = SubStr(s2, i, 1))
            num++
    return (StrLen(s1) - num = 1)
}
