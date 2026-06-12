str = Tom? Toms bottom tomato is in his stomach while playing the "Tom-tom" brand tom-toms. That's so tom.
words := ["Tom", "tom"]
opts := ["wsn", "win", "psn", "pin", "pso", "pio"]
for i, word in words
{
    result .= "Redact '" word "'`n"
    for j, opt in opts
        result .= opt "`t" redact(str, word, opt) "`n"
    result .= "`n"
}
MsgBox, 262144, , % result
return
redact(str, word, opt){
    if InStr(opt, "w")                            ; Whole word
        a := "(^|[^-])\K\b", z := "\b(?!-)"
    if InStr(opt, "o")                            ; Overkill
        a .= "\b[\w\-]*", z := "[\w\-]*\b" z
    if InStr(opt, "i")                            ; Case insensitive
        i := "i)"

    ndle := i a "\Q" word "\E" z

    while pos := RegExMatch(str, ndle, mtch, A_Index=1?1:pos+StrLen(mtch))
    {
        rplc := ""
        loop % StrLen(mtch)
            rplc .= "X"
        str := RegExReplace(str, ndle, rplc,, 1)
    }
    return str
}
