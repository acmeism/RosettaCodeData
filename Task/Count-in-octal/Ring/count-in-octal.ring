size = 30
for n = 1 to size
    see octal(n) + nl
next

func octal m
     output = ""
     w = m
     while fabs(w) > 0
           oct = w & 7
           w = floor(w / 8)
           output = string(oct) + output
     end
     return output
