; if
x = 1
If x
  MsgBox, x is %x%
Else If x > 1
  MsgBox, x is %x%
Else
  MsgBox, x is %x%

; ternary if
x = 2
y = 1
var := x > y ? 2 : 3
MsgBox, % var

; while
While (A_Index < 3) {
  MsgBox, %A_Index% is less than 3
}
