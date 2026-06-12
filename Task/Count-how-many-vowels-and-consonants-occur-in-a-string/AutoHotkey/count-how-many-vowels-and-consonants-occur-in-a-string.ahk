str := "Now is the time for all good men to come to the aid of their country."
oV:= [], oC := [], v := c := o := 0
for i, ch in StrSplit(str)
    if (ch ~= "i)[AEIOU]")
        v++, oV[ch] := (oV[ch]?oV[ch]:0) + 1
    else if (ch ~= "i)[A-Z]")
        c++, oC[ch] := (oC[ch]?oC[ch]:0) + 1
    else
        o++

Vowels := "{"
for ch, count in oV
    Vowels .= """" ch """:" count ", "
Vowels := Trim(Vowels , ", ") "}"
Consonants := "{"
for ch, count in oC
    Consonants .= """" ch """:" count ", "
Consonants := Trim(Consonants , ", ") "}"

MsgBox % result := str "`n`n" v+c+o " characters, " v " vowels, " c " consonants and " o " other"
        . "`n" Vowels "`n" Consonants
