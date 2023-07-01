Values := [7, 6, 5, 4, 3, 2, 1, 0]
Indices := [7, 2, 8]
Values := Sort_disjoint_sublist(Values, Indices)
for k, v in Values
    output .= v ", "
MsgBox % "[" Trim(output, ", ") "]"					; show output
