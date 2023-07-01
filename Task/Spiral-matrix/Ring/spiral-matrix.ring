# Project : Spiral matrix

load "guilib.ring"
load "stdlib.ring"
new qapp
        {
        win1 = new qwidget() {
                   setwindowtitle("Spiral matrix")
                   setgeometry(100,100,600,400)
                   n = 5
                   result = newlist(n,n)
                   spiral = newlist(n,n)
                   k = 1
                   top = 1
                   bottom = n
                   left = 1
                   right = n
                   while (k <= n*n)
                           for  i= left to right
                                result[top][i] = k
                                k = k + 1
                           next
                           top = top + 1
                           for i = top to bottom
                                result[i][right] = k
                                k = k + 1
                           next
                           right = right - 1
                           for i = right to left step -1
                                result[bottom][i] = k
                                k = k + 1
                           next
                           bottom = bottom - 1
                           for i = bottom to top step -1
                                result[i][left] = k
                                k = k + 1
                           next
                           left = left + 1
                   end
                   for m = 1 to n
                        for p = 1 to n
                             spiral[p][m] = new qpushbutton(win1) {
                                                  x = 150+m*40
                                                  y = 30 + p*40
                                                  setgeometry(x,y,40,40)
                                                  settext(string(result[m][p]))
                                                  }
                        next
                   next
                   show()
                   }
                   exec()
                   }
