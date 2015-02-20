set1 := "the that a"
set2 := "frog elephant thing"
set3 := "walked treaded grows"
set4 := "slowly quickly"

MsgBox % amb( "", set1, set2, set3, set4 )
; this takes a total of 17 iterations to complete

amb( char = "", set1 = "", set2 = "", set3 = "", set4 = "" )
{ ; original call to amb must leave char param blank
  Loop, Parse, set1, %A_Space%
    If (char = (idxchar := SubStr(A_LoopField, 1, 1)) && set2 = ""
    || (char = idxchar || char = "") && ((retval:= amb(SubStr(A_LoopField, 0, 1), set2, set3, set4)) != ""))
      Return A_LoopField " " retval
  Return ""
}
