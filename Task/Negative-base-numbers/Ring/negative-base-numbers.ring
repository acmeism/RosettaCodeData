# Project : Negative base numbers

negs = [[146,-3],[21102,-3],[10,-2],[11110,-2],[15,-10],[195,-10]]
for n = 1 to len(negs) step 2
     enc = encodeNegBase(negs[n][1],negs[n][2])
     encstr = showarray(enc)
     dec = decodeNegBase(negs[n+1][1],negs[n+1][2])
     see "" + negs[n][1] + " encoded in base " + negs[n][2] + " = " + encstr + nl
     see "" + negs[n+1][1] + " decoded in base " + negs[n+1][2] + " = " + dec + nl
next

func encodeNegBase(n,b)
       out = []
       while n != 0
               rem = (n%b)
               if rem < 0
                  rem = rem - b
               ok
               n = ceil(n/b)
               rem = fabs(rem)
               add(out,rem)
       end
       out = reverse(out)
       return out

func decodeNegBase(n,b)
        out = 0
        n = string(n)
        for nr = len(n) to 1 step -1
             out = out + n[nr]*pow(b,len(n)-nr)
        next
        return out

func showarray(vect)
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n]
        next
        return svect
