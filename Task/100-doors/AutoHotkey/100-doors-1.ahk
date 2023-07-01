Loop, 100
  Door%A_Index% := "closed"

Loop, 100 {
  x := A_Index, y := A_Index
  While (x <= 100)
  {
    CurrentDoor := Door%x%
    If CurrentDoor contains closed
    {
      Door%x% := "open"
      x += y
    }
    else if CurrentDoor contains open
    {
      Door%x% := "closed"
      x += y
    }
  }
}

Loop, 100 {
   CurrentDoor := Door%A_Index%
   If CurrentDoor contains open
      Res .= "Door " A_Index " is open`n"
}
MsgBox % Res
