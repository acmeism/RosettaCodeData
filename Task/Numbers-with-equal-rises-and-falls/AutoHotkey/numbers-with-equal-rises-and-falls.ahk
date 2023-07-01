limit1 := 200, limit2 := 10000000
count := 0, result1 := result1 := ""
loop{
    num := A_Index
    if !Rise_Fall(num)
        continue
    count++
    if (count <= limit1)
        result1 .= num . (Mod(count, 20) ? "`t" : "`n")
    if (count = limit2){
        result2 := num
        break
    }
    if !mod(count, 10000)
        ToolTip % count
}
ToolTip
MsgBox % "The first " limit1 " numbers in the sequence:`n" result1 "`nThe " limit2 " number in the sequence is: " result2
return

Rise_Fall(num){
    rise := fall := 0
    for i, n in StrSplit(num){
        if (i=1)
            prev := n
        else if (n > prev)
            rise++
        else if (n < prev)
            fall++
        if (rise > (StrLen(num)-1) /2) || (fall > (StrLen(num)-1) /2)
            return 0
        prev := n
    }
    if (fall = rise)
        return 1
}
