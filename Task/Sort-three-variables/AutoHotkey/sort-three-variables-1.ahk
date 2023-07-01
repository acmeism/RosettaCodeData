SortThreeVariables(ByRef x,ByRef y,ByRef z){
  obj := []
  for k, v in (var := StrSplit("x,y,z", ","))
    obj[%v%] := true
  for k, v in obj
    temp := var[A_Index], %temp% := k
}
