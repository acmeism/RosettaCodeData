FileRead, db, % A_Desktop "\unixdict.txt"
vowels := ["a", "e", "i", "o", "u"]
oRes := []
for i, word in StrSplit(db, "`n", "`r")
{
    if StrLen(word) < 11
        continue
    tWord := word
    for j, v in vowels
        word := StrReplace(word, v)
    if !(word ~= "(.)(?=.*?\1)")
        oRes[0-StrLen(word), tword] := 1 ; result .= tword "`n"
}

for l, obj in oRes
{
    result .= 0-l " Unique consonants, word count: " obj.Count() "`n"
    for word in obj
        result .= word (!Mod(A_Index, 9) ? "`n" : "`t")
    result .= "`n`n"
}
MsgBox, 262144, , % result
