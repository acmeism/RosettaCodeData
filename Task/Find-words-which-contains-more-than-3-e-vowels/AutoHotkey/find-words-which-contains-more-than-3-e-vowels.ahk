FileRead, db, % A_Desktop "\unixdict.txt"
vowelsLessE := ["a", "i", "o", "u"]
oRes := []
main:
for i, word in StrSplit(db, "`n", "`r")
{
    for j, v in vowelsLessE
    {
        StrReplace(word, v, v, c)
        if c
            continue main
    }
    StrReplace(word, "e", "e", c)
    if c > 3
        result .= word "`n"
}
MsgBox, 262144, , % result
