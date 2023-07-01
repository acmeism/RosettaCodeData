date := 20200202
counter := 0

while (counter < 15) {
    date += 1, days
    date := SubStr(date, 1, 8)
    if (date = reverse(date))
    {
        FormatTime, fdate, % date, yyyy-MM-dd
        output .= fdate "`n"
        counter++
    }
}

MsgBox, 262144, , % output
return

reverse(n){
    for i, v in StrSplit(n)
        output := v output
    return output
}
