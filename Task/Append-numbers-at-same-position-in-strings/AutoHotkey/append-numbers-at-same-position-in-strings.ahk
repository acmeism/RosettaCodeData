list1 := [1,2,3,4,5,6,7,8,9]
list2 := [10,11,12,13,14,15,16,17,18]
list3 := [19,20,21,22,23,24,25,26,27]
list4 := []

for i, v in list1
    list4.Push(v . list2[i] . list3[i])
for i, v in list4
    result .= v ", "
MsgBox % "[" trim(result, ", ") "]"
