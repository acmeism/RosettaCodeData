Loop {
  If isHappy(A_Index) {
    out .= (out="" ? "" : ",") . A_Index
    i ++
    If (i = 8) {
      MsgBox, The first 8 happy numbers are: %out%
      ExitApp
    }
  }
}

isHappy(num, list="") {
  list .= (list="" ? "" : ",") . num
  Loop, Parse, num
    sum += A_LoopField ** 2
  If (sum = 1)
    Return true
  Else If sum in %list%
    Return false
  Else Return isHappy(sum, list)
}
