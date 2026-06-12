FileRead, db, % A_Desktop "\unixdict.txt"
vowels := {"a":1, "e":1, "i":1, "o":1, "u":1}, c := 0

Main:
for i, word in StrSplit(db, "`n", "`r")
{
    if StrLen(word) < 10
        continue
    vCount := cCount := 0
    while (letter := SubStr(word, A_Index, 1))
    {
        if vowels[letter]
            vCount++, cCount:=0
        else
            vCount:=0, cCount++
        if (vCount > 1 || cCount > 1)
            continue main
    }
    c++
    result .= word (Mod(c, 9) ? "`t" : "`n")

}
MsgBox, 262144, , % result
return
