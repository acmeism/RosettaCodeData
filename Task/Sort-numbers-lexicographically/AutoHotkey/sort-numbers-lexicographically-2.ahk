n := 13
x := n2lexicog(n)
for k, v in x
    output .= v ", "
MsgBox % "[" Trim(output, ", ") "]"					; show output
return
