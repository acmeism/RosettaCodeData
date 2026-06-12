n:=0
while (n++<=1000)
{
    bin := LTrim(dec2bin(n), "0")
    l := Strlen(bin)
    if (l/2 <> Floor(l/2))
        continue
    if (SubStr(bin, 1, l/2) = SubStr(bin, l/2+1))
        result .= n "`t" bin "`n"
}
MsgBox % result
return

Dec2Bin(i, s=0, c=0) {
    l := StrLen(i := Abs(i + u := i < 0))
    Loop, % Abs(s) + !s * l << 2
        b := u ^ 1 & i // (1 << c++) . b
    Return, b
}
