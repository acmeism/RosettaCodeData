while h < 8
    if (Happy(A_Index)) {
        Out .= A_Index A_Space
        h++
    }
MsgBox, % Out

Happy(n) {
    Loop, {
        Loop, Parse, n
            t += A_LoopField ** 2
        if (t = 89)
            return, 0
        if (t = 1)
            return, 1
        n := t, t := 0
    }
}
