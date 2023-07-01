A := [8,6,4,3,5,2,7,1]
cocktailShakerSort(A)
for k, v in A
    output .= v ", "
MsgBox % "[" Trim(output, ", ") "]"     ; show output
