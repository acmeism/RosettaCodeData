SetFormat, FloatFast, 0.1
strings := ["1 2 3 4 5 6 7 8 7 6 5 4 3 2 1"
         ,  "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"]

Loop, % strings.MaxIndex()
{
    SL := Sparklines(strings[A_Index])
    MsgBox, % "Min: " SL["Min"] ", Max: " SL["Max"] ", Range: " SL["Rng"] "`n" SL["Chars"]
}

Sparklines(s)
{
    s := RegexReplace(s, "[^\d\.]+", ",")
    Loop, Parse, s, `,
    {
        Max := A_LoopField > Max ? A_LoopField : Max
        Min := !Min ? Max : A_LoopField < Min ? A_LoopField : Min
    }
    Rng := Max - Min
    Loop, Parse, s, `,
        Chars .= Chr(0x2581 + Round(7 * (A_LoopField - Min) / Rng))
    return, {"Min": Min, "Max": Max, "Rng": Rng, "Chars": Chars}
}
