# Project : Colour pinstripe/Display

load "guilib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("archimedean spiral")
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
        h = 100
        color = list(8)
        color[1] = [0 ,0, 0]
        color[2] = [255, 0, 0]
        color[3] = [0, 255, 0]
        color[4] = [0, 0, 255]
        color[5] = [255, 0, 255]
        color[6] = [0, 255, 255]
        color[7] = [255, 255, 0]
        color[8] = [255, 255, 255]
        y = h*4
        for p = 1 to 4
             y = y - h
             for x = 0 to w step 4*p
                  col = random(7) + 1
                  color2 = new qcolor()
                  color2.setrgb(color[col][1],color[col][2],color[col][3],255)
                  mybrush = new qbrush() {setstyle(1) setcolor(color2)}
                  setbrush(mybrush)
                  paint.drawrect(x, y, 2*p, h)
             next
        next
        endpaint()
        }
        label1 { setpicture(p1) show() }
