# Project : Numerical integration

decimals(8)
data = [["pow(x,3)",0,1,100], ["1/x",1, 100,1000], ["x",0,5000,5000000], ["x",0,6000,6000000]]
see "Function   Range   L-Rect   R-Rect   M-Rect   Trapeze   Simpson" + nl
for p = 1 to 4
     d1 = data[p][1]
     d2 = data[p][2]
     d3 = data[p][3]
     d4 = data[p][4]
     see "" + d1 + "   " + d2  + " - " + d3  + "   " + lrect(d1, d2, d3, d4) + "   " + rrect(d1, d2, d3, d4)
     see "  " + mrect(d1, d2, d3, d4) + "   " + trapeze(d1, d2, d3, d4) + "   " + simpson(d1, d2, d3, d4) + nl
next

func lrect(x2, a, b, n)
       s = 0
       d = (b - a) / n
       x = a
       for i = 1 to n
       eval("result = " + x2)
            s = s + d * result
            x = x + d
       next
       return s

func rrect(x2, a, b, n)
       s = 0
       d = (b - a) / n
       x = a
       for i = 1 to n
            x = x + d
            eval("result = " + x2)
            s = s + d *result
       next
       return s

func mrect(x2, a, b, n)
       s = 0
       d = (b - a) / n
       x = a
       for i = 1 to n
            x = x + d/2
            eval("result = " + x2)
            s = s + d * result
            x =  x +d/2
       next
       return s

func trapeze(x2, a, b, n)
       s = 0
       d = (b - a) / n
       x = b
       eval("result = " + x2)
       f = result
       x = a
       eval("result = " + x2)
       s = d * (f + result) / 2
       for i = 1 to n-1
            x = x + d
           eval("result = " + x2)
            s = s + d * result
       next
       return s

func simpson(x2, a, b, n)
        s1 = 0
        s = 0
        d = (b - a) / n
        x = b
        eval("result = " + x2)
        f = result
        x = a + d/2
       eval("result = " + x2)
        s1 = result
        for i = 1 to n-1
            x = x + d/2
            eval("result = " + x2)
            s = s + result
            x = x + d/2
            eval("result = " + x2)
            s1 = s1 + result
        next
        x = a
        eval("result = " + x2)
        return (d / 6) * (f + result + 4 * s1 + 2 * s)
