nr = 0
for i = 1 to 200
    if kaprekar(i)
       nr += 1
       if i < 201 see "" + nr + " : " + i + nl ok ok
next
see "total kaprekar numbers under 200 = " + nr + nl

func kaprekar n
     s = pow(n,2)
     x = floor(log(s)) + 1
     t = pow(10,x)
     while true
           t /= 10
           if t<=n exit ok
           if s-n = floor(s/t)*(t-1) n = true ok
     end
     return (n = 1)
