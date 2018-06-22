# Project : Plot coordinate pairs
# Date    : 2018/01/11
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "guilib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Plot coordinate pairs")
                  setgeometry(100,100,1024,900)
                  label1 = new qlabel(win1) {
                              setgeometry(10,10,1024,900)
                              settext("")
                  }
                  new qpushbutton(win1) {
                          setgeometry(50,50,100,30)
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

        old = 0
        yold = 0
        xnew = 0
        ynew = 0
        x2 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        y2 = [2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0]

        for x = 1 to 9
              drawline(100*x,720,100*x,0)
              drawtext(100*x,750,string(x))
        next

        for y = 20 to 180 step 20
             drawline(900,4*y,0,4*y)
             drawtext(0,720-4*y,string(y))
        next

        drawline(0,0,0,720)
        drawline(0,0,900,0)

        for i = 1 to 10
             if i=1
                xold = 100*x2[i]
                yold = 720-4*y2[i]
             else
                xnew = 100*x2[i]
                ynew = 720-4*y2[i]
                drawline(xold,yold,xnew,ynew)
                xold = xnew
                yold = ynew
             ok
        next

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return
