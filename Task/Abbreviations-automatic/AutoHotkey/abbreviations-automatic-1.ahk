AutoAbbreviations(line){
    len := prev := 0
    Days := StrSplit(line, " ")
    loop % StrLen(Days.1)
    {
        obj := []
        for j, day in Days
        {
            abb := SubStr(day, 1, len)
            obj[abb] := (obj[abb] ? obj[abb] : 0) + 1
            if (obj[abb] > 1)
            {
                len++
                break
            }
        }
        if (prev = len)
            break
        prev := len
    }
    return len
}
