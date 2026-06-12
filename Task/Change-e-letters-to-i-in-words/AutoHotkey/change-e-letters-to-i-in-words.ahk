FileRead, db, % A_Desktop "\unixdict.txt"
oWord := []
for i, word in StrSplit(db, "`n", "`r")
    if (StrLen(word) > 5)
        oWord[word] := true

for word in oWord
    if InStr(word, "e") && oWord[StrReplace(word, "e", "i")]
        result .= word . (StrLen(word) > 8 ? "`t" : "`t`t") . ": " StrReplace(word, "e", "i") "`n"

MsgBox, 262144, , % result
