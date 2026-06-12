FileRead, db, % A_Desktop "\unixdict.txt"
vowels := ["a", "e", "i", "o", "u"]
main:
for i, word in StrSplit(db, "`n", "`r")
{
    if StrLen(word) < 11
        continue
    for j, v in vowels
    {
        StrReplace(word, v, v, c)
        if (c<>1)
            continue, main
    }
    result .= word "`n"
}
MsgBox, 262144, , % result
