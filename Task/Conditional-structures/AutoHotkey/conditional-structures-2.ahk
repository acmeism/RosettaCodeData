x = 2
y = 1
var := x > y ? 2 : 3
MsgBox, % var

===while (looping if)===
<lang AutoHotkey>While (A_Index < 3) {
  MsgBox, %A_Index% is less than 3
}
