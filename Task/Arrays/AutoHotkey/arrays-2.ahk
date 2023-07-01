arrayX0 = 4      ; length
arrayX1 = first
arrayX2 = second
arrayX3 = foo
arrayX4 = bar
Loop, %arrayX0%
  Msgbox % arrayX%A_Index%
source = apple bear cat dog egg fish
StringSplit arrayX, source, %A_Space%
Loop, %arrayX0%
  Msgbox % arrayX%A_Index%
