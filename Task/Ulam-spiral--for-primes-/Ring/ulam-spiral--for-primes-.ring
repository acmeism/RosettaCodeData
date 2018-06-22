# Project : Ulam spiral (for primes)
# Date    : 2018/06/11
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

load "guilib.ring"
load "stdlib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Ulam spiral")
                  setgeometry(100,100,560,600)
                  label1 = new qlabel(win1) {
                              setgeometry(10,10,800,600)
                              settext("")
                  }
                  new qpushbutton(win1) {
                          setgeometry(220,500,100,30)
                          settext("draw")
                          setclickevent("draw()")
                  }
                  show()
        }
        exec()
        }

func draw
        p1 = new qpicture()
               color = new qcolor() {
               setrgb(0,0,255,255)
        }
        pen = new qpen() {
                 setcolor(color)
                 setwidth(1)
        }
        paint = new qpainter() {
                  begin(p1)
                  setpen(pen)

        usn = 81
        ulamspiral(usn)

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return

func ulamspiral(nr)
        button = list(nr)
        win1{
                sizenew = sqrt(nr)
                 for n = 1 to nr
                     col = n%9
                     if col = 0 col = 9 ok
                     row = ceil(n/9)

                     button[n] = new qpushbutton(win1)
                     {
                                        setgeometry(60+col*40,60+row*40,40,40)
                                        setclickevent("movetile(" + string(n) +")")
                                        show()
                     }
                next
        n = 9
        result = newlist(n,n)
        k = 1
        top = 1
        bottom = n
        left = 1
        right = n
        while (k<=n*n)
                 for i=left to right
                      result[top][i]=k
                      k = k + 1
                 next
                 top = top + 1
                 for i=top to bottom
                     result[i][right]=k
                     k = k + 1
                 next
                 right = right - 1
                 for i=right to left step -1
                      result[bottom][i]=k
                      k = k + 1
                 next
                 bottom = bottom - 1
                 for i=bottom to top step -1
                      result[i][left] = k
                      k = k + 1
                 next
                 left = left + 1
        end
        for m = 1 to n
             for p = 1 to n
                  pos = (m-1)*n + p
                  if isprime(result[m][p])
                     button[pos] {settext(string(result[m][p]))}
                  ok
             next
         next
         }
