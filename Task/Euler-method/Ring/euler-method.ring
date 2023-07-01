decimals(3)
see euler("return -0.07*(y-20)", 100, 0, 100, 2) + nl
see euler("return -0.07*(y-20)", 100, 0, 100, 5) + nl
see euler("return -0.07*(y-20)", 100, 0, 100, 10) + nl

func euler df, y, a, b, s
     t = a
     while t <= b
           see "" + t + " " + y + nl
           y += s * eval(df)
           t += s
     end
     return y
