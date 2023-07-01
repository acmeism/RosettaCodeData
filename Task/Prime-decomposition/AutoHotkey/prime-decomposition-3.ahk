num := 8388607, output := ""
for i, p in prime_numbers(num)
    output .= p " * "
MsgBox % num " = " Trim(output, " * ")
return
