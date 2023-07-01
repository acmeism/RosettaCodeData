List1 := [1, 2, 3]
List2 := [4, 5, 6]
cList := Arr_concatenate(List1, List2)
MsgBox % Arr_disp(cList) ; [1, 2, 3, 4, 5, 6]

Arr_concatenate(p*) {
    res := Object()
    For each, obj in p
        For each, value in obj
            res.Insert(value)
    return res
}

Arr_disp(arr) {
    for each, value in arr
        res .= ", " value
    return "[" SubStr(res, 3) "]"
}
