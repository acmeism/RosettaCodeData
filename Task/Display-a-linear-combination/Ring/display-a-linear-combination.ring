# Project : Display a linear combination

scalars = [[1,  2,  3], [0,  1,  2,  3], [1,  0,  3,  4], [1,  2,  0], [0,  0,  0], [0], [1,  1,  1], [-1, -1, -1], [-1, -2,  0, -3], [-1]]
for n=1 to len(scalars)
    str = ""
    for m=1 to len(scalars[n])
        scalar = scalars[n] [m]
        if scalar != "0"
           if scalar = 1
              str = str + "+e" + m
           elseif  scalar = -1
              str = str + "" + "-e" + m
           else
              if scalar > 0
                 str = str + char(43) + scalar + "*e" + m
              else
                 str = str + "" + scalar + "*e" + m
              ok
           ok
        ok
    next
    if str = ""
       str = "0"
    ok
    if left(str, 1) = "+"
       str = right(str, len(str)-1)
    ok
    see str + nl
next
