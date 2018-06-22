# Project : Hofstadter Figure-Figure sequences
# Date    : 2018/01/17
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

hofr = list(20)
hofr[1] = 1
hofs = []
add(hofs,2)
for n = 1 to 10
      hofr[n+1] = hofr[n] + hofs[n]
      if n = 1
         add(hofs,4)
      else
         for p = hofr[n] + 1 to hofr[n+1] - 1
               if p != hofs[n]
                  add(hofs,p)
               ok
         next
      ok
next
see "First 10 values of R:" + nl
showarray(hofr)
see "First 10 values of S:" + nl
showarray(hofs)

func showarray(vect)
         svect = ""
        for n = 1 to 10
              svect = svect + vect[n] + " "
        next
        svect = left(svect, len(svect) - 1)
        see svect + nl
