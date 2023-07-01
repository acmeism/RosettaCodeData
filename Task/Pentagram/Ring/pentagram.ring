# Project : Pentagram

load "guilib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Pentagram")
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
                 setwidth(5)
        }
        paint = new qpainter() {
                  begin(p1)
                  setpen(pen)

        nn = 165
        cx = 800
        cy = 600
        phi = 54

        color = new qcolor()
        color.setrgb(0, 0, 255,255)
        mybrush = new qbrush() {setstyle(1) setcolor(color)}
        setbrush(mybrush)

       for n = 1 to 5
             theta = fabs(180-144-phi)
	     p1x = floor(cx + nn * cos(phi * 0.01745329252))
	     p1y = floor(cy + nn * sin(phi * 0.01745329252))
	     p2x = floor(cx - nn * cos(theta * 0.01745329252))
	     p2y = floor(cy - nn * sin(theta * 0.01745329252))
	     phi+= 72
	     drawpolygon([[p1x,p1y],[cx,cy],[p2x,p2y]],0)
        next

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return
