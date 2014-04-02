MsgBox % SEDOL("710889")  ;7108899
MsgBox % SEDOL("B0YBKJ")  ;B0YBKJ7
MsgBox % SEDOL("406566")  ;4065663
MsgBox % SEDOL("B0YBLH")  ;B0YBLH2
MsgBox % SEDOL("228276")  ;2282765
MsgBox % SEDOL("B0YBKL")  ;B0YBKL9
MsgBox % SEDOL("557910")  ;5579107
MsgBox % SEDOL("B0YBKR")  ;B0YBKR5
MsgBox % SEDOL("585284")  ;5852842
MsgBox % SEDOL("B0YBKT")  ;B0YBKT7

SEDOL(w) {
    static weights := [1,3,1,7,3,9]
    loop parse, w
        s += ((c := Asc(A_LoopField)) >= 65 ? c - 65 + 10 : c - 48) * weights[A_Index]
    return w Mod(10 - Mod(s, 10), 10)
}
