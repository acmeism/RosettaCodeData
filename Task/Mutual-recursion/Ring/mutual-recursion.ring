see "F sequence : "
for i = 0 to 20
    see "" + f(i) + " "
next
see nl
see "M sequence : "
for i = 0 to 20
    see "" + m(i) + " "
next

func f n
     fr = 1
     if n != 0 fr = n - m(f(n - 1)) ok
     return fr

func m n
     mr = 0
     if n != 0 mr = n - f(m(n - 1)) ok
     return mr
