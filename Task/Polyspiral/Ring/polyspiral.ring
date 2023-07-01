# Project : Polyspiral

load "guilib.ring"

paint = null
incr = 1
x1 = 1000
y1 = 1080
angle = 10
length = 10

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("")
                  setgeometry(10,10,1000,1080)
                  label1 = new qlabel(win1) {
                              setgeometry(10,10,1000,1080)
                              settext("")
                  }
                  new qpushbutton(win1) {
                          setgeometry(150,30,100,30)
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
        for i = 1 to 150
             x2 = x1 + cos(angle) * length
             y2 = y1 + sin(angle) * length
             drawline(x1, y1, x2, y2)
             x1 = x2
             y1 = y2
             length = length + 3
             angle = (angle + incr) % 360
        next

        endpaint()
        }
        label1 { setpicture(p1) show() }
