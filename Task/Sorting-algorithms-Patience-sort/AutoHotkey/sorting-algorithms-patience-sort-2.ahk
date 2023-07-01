Test := [[4, 65, 2, -31, 0, 99, 83, 782, 1]
        ,["n", "o", "n", "z", "e", "r", "o", "s", "u", "m"]
        ,["dog", "cow", "cat", "ape", "ant", "man", "pig", "ass", "gnu"]]

for i, v in Test{
    X := PatienceSort(V)
    output := ""
    for k, v in X
        output .= v ", "
    MsgBox % "[" Trim(output, ", ") "]"
}
return
