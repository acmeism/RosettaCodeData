# Project : Draw a cuboid

load "guilib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Draw a cuboid")
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

        color = new qcolor()
        color.setrgb(255,0,0,255)
        mybrush = new qbrush() {setstyle(1) setcolor(color)}
        setbrush(mybrush)
        paint.drawPolygon([[200,200],[300,200],[300,100],[200,100]], 0)
        color = new qcolor()
        color.setrgb(0,255,0,255)
        mybrush = new qbrush() {setstyle(1) setcolor(color)}
        setbrush(mybrush)
        paint.drawPolygon([[200,100],[250,50],[350,50],[300,100]], 0)
        color = new qcolor()
        color.setrgb(0, 0, 255,255)
        mybrush = new qbrush() {setstyle(1) setcolor(color)}
        setbrush(mybrush)
        paint.drawPolygon([[350,50],[350,150],[300,200],[300,100]], 0)

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return
