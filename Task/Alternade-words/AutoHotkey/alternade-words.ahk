FileRead, db, % A_Desktop "\unixdict.txt"
words := [], sixWords := []

for i, w in StrSplit(db, "`n", "`r")
    if (StrLen(w) >= 6)
        sixWords[w] := true
    else
        Words[w] := true

for w in sixWords
{
    w1 := w2 := ""
    for j, letter in StrSplit(w)
        if Mod(j, 2)
            w1 .= letter
        else
            w2 .= letter

    if words[w1] && words[w2]
        result .= w "`t-> " w1 " " w2 "`n"
}
MsgBox % result
