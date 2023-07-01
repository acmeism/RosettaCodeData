for i, n in StrSplit("1 2 3 4 5 11 65 100 101 272 23456 8007006005004003", " ")
    res .= PrettyNumber(n) "`t" Spell(n) "`t" OrdinalNumber(Spell(n)) "`n"
MsgBox % res
