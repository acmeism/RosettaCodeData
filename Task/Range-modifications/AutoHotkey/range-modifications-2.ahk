arr := string2obj("")
steps .= "start with`t:`t" obj2string(arr) "`n"
arr := RangeModifications(arr, "Add", 77)
arr := RangeModifications(arr, "Add", 79)
arr := RangeModifications(arr, "Add", 78)
arr := RangeModifications(arr, "Remove", 77)
arr := RangeModifications(arr, "Remove", 78)
arr := RangeModifications(arr, "Remove", 79)
MsgBox % steps

steps := ""
arr := string2obj("1-3,5-5")
steps .= "start with`t:`t" obj2string(arr) "`n"
arr := RangeModifications(arr, "Add", 1)
arr := RangeModifications(arr, "Remove", 4)
arr := RangeModifications(arr, "Add", 7)
arr := RangeModifications(arr, "Add", 8)
arr := RangeModifications(arr, "add", 6)
arr := RangeModifications(arr, "Remove", 7)
MsgBox % steps

steps := ""
arr := string2obj("1-5,10-25,27-30")
steps .= "start with`t:`t" obj2string(arr) "`n"
arr := RangeModifications(arr, "Add", 26)
arr := RangeModifications(arr, "Add", 9)
arr := RangeModifications(arr, "Add", 7)
arr := RangeModifications(arr, "Remove", 26)
arr := RangeModifications(arr, "Remove", 9)
arr := RangeModifications(arr, "Remove", 7)
MsgBox % steps
return
