list = 1,5,17,-2
StringSplit, list, list,`, ; creates a pseudo-array
Loop % List0
   x := x < List%A_Index% ? List%A_Index% : x
MsgBox Max = %x%
