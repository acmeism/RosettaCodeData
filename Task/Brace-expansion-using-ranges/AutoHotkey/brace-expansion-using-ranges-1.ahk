Brace_expansion_using_ranges(line){
    needle := "^.*\K{(?P<Start>[^{}]+?)\..(?P<End>[^{}]+?)(?:\..(?P<Incr>[^{}]+?))?}"
    while true
    {
        while pos := RegExMatch(line, needle, m, A_Index=1?1:pos+StrLen(m))
        {
            char := false, step := "", output := ""
            reverse := InStr(mIncr, "-") ? true : false

            if mStart is number
                pad1 := pad(mStart), pad2 := pad(mEnd), pad := StrLen(pad1)>=StrLen(pad2) ? pad1 : pad2
            else
                mStart := Ord(mStart), mEnd := Ord(mEnd), char := true

            mIncr := (mIncr?Abs(mIncr):1) * (mStart>mEnd?-1:1)
            loop % Abs((mStart-mEnd)/mIncr) + 1
            {
                step := mStart + (A_Index-1) * mIncr
                step := pad <> "" ? SubStr(pad . step, 1-StrLen(pad)) : step
                step := char ? Chr(step) : step
                Rep := StrReplace(line, m, step)
                output := reverse ? rep "`n" output : output .= Rep "`n"
            }
            output := Trim(Output, "`n")
        }
        if RegExMatch(output, needle)
            line := output
        else
            break
    }
    return output ? output : line
}
pad(num){
    if RegExMatch(num, "`am)^(0+)(?=[1-9]|0$)", m)
        loop % StrLen(num)
            pad .= "0"
    return pad
}
