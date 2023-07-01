list = 1,5,17,-2
Loop Parse, list, `,
   x := x < A_LoopField ? A_LoopField : x
MsgBox Max = %x%
