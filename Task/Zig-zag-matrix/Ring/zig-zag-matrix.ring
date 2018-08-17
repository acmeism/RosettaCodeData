# Project  Zig-zag matrix

load "guilib.ring"
load "stdlib.ring"
new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Zig-zag matrix")
                  setgeometry(100,100,600,400)
                  n = 5
                  a = newlist(n,n)
                  zigzag = newlist(n,n)
                  for j = 1 to n
                       for i = 1 to n
                            a[j][i] = 0
                       next
                  next
                  i = 1
                  j = 1
                  k = 1
                  while k < n * n
                          a[j][i] = k
                          k = k + 1
                          if i = n
                             j = j + 1
                             a[j][i] = k
                             k = k + 1
                             di = -1
                             dj = 1
                          ok
                          if j = 1
                             i = i + 1
                             a[j][i] = k
                             k = k + 1
                             di = -1
                             dj = 1
                          ok
                          if j = n
                             i = i + 1
                             a[j][i] = k
                             k = k + 1
                             di = 1
                             dj = -1
                          ok
                          if i = 1
                             j = j + 1
                             a[j][i] = k
                             k = k + 1
                             di = 1
                             dj = -1
                          ok
                          i = i + di
                          j = j + dj
                  end
                  for p = 1 to n
                       for m = 1 to n
                            zigzag[p][m] = new qpushbutton(win1) {
                                                  x = 150+m*40
                                                  y = 30 + p*40
                                                  setgeometry(x,y,40,40)
                                                  settext(string(a[p][m]))
                                                  }
                       next
                  next
        show()
        }
        exec()
        }
