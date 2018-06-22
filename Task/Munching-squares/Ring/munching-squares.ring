# Project : Munching squares
# Date    : 2018/01/13
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "guilib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Archimedean spiral")
                  setgeometry(100,100,500,600)
                  label1 = new qlabel(win1) {
                              setgeometry(10,10,400,400)
                              settext("")
                  }
                  new qpushbutton(win1) {
                          setgeometry(150,500,100,30)
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

        w = 100
        for x = 0 to w
             for y = 0 to w
                   b = (x ^ y)
                   color = new qcolor()
                   color.setrgb(255 -b,b /2,b,255)
                   pen.setcolor(color)
                   setpen(pen)
                   drawpoint(x,w -y -1)
             next
         next

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return
