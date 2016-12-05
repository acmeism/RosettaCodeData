see sedol("710889") + nl
see sedol("B0YBKJ") + nl
see sedol("406566") + nl
see sedol("B0YBLH") + nl
see sedol("228276") + nl
see sedol("B0YBKL") + nl
see sedol("557910") + nl
see sedol("B0YBKR") + nl
see sedol("585284") + nl
see sedol("B0YBKT") + nl
see sedol("B00030") + nl

func sedol d
     d = upper(d)
     s = 0
     weights  = [1, 3, 1, 7, 3, 9]
     for i = 1 to 6
         a = substr(d,i,1)
         if ascii(a) >= 48 and ascii(a) <= 57
            s += number(a) * weights[i]
         else
            s += (ascii(a) - 55) * weights[i] ok
     next
     return d + (10 - (s % 10)) % 10
