n := 2, steplimit := 15, numerator := [], denominator := []
s := "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"

Loop, Parse, s, % A_Space
    if (!RegExMatch(A_LoopField, "^(\d+)/(\d+)$", m))
        MsgBox, % "Invalid input string (" A_LoopField ")."
    else
        numerator[A_Index] := m1, denominator[A_Index] := m2

SetFormat, FloatFast, 0.0
Gui, Add, ListView, R10 W100 -Hdr, |
SysGet, VSBW, 2
LV_ModifyCol(1, 95 - VSBW), LV_Add( , 0 ": " n)
Gui, Show

Loop, % steplimit {
    i := A_Index
    Loop, % numerator.MaxIndex()
        if (!Mod(nn := n * numerator[A_Index] / denominator[A_Index], 1)) {
            LV_Modify(LV_Add( , i ": " (n := nn)), "Vis")
            continue, 2
        }
    break
}
