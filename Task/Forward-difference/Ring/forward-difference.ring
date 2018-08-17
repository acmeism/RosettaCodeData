# Project : Forward difference

s = [90, 47, 58, 29, 22, 32, 55, 5, 55, 73]
for p = 1 to 9
      s = fwddiff(s)
      showarray(s)
next

func fwddiff(s)
        for j=1 to len(s)-1
             s[j] = s[j+1]-s[j]
        next
        n = len(s)
        del(s, n)
        return s

func showarray(vect)
        see "{"
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + ", "
        next
        svect = left(svect, len(svect) - 2)
        see svect
        see "}" + nl
