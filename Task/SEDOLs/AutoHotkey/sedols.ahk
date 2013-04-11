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
   Static w1:=1,w2:=3,w3:=1,w4:=7,w5:=3,w6:=9
   Loop Parse, w
      s += ((c:=Asc(A_LoopField))>=Asc("A") ? c-Asc("A")+10 : c-Asc("0")) * w%A_Index%
   Return w mod(10-mod(s,10),10)
}
