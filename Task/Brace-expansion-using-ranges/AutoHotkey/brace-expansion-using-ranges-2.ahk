data=
(
simpleNumberRising{1..3}.txt
simpleAlphaDescending-{Z..X}.txt
steppedDownAndPadded-{10..00..5}.txt
minusSignFlipsSequence {030..20..-5}.txt
reverseSteppedNumberRising{1..6..-2}.txt
combined-{Q..P}{2..1}.txt
emoji{🌵..🌶}{🌽..🌾}etc
li{teral
rangeless{}empty
rangeless{random}string
)
for i, line in StrSplit(data, "`n", "`r")
    result .= line " ->`n" RegExReplace(Brace_expansion_using_ranges(line), "`am)^", "`t") "`n`n"

MsgBox, 262144, , % result
return
