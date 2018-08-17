# Project : Pinstripe/Display

load "guilib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Pinstripe/Display")
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

        xscreen = 100
        yscreen = 100
        color = new qcolor()
        color.setrgb(0,0,0,255)
        mybrush = new qbrush() {setstyle(1) setcolor(color)}
        setbrush(mybrush)
        for x = 0 to xscreen*4-4 step 4
             drawrect(x,yscreen*3/2,2,yscreen/2)
        next
        for x = 0 to xscreen*4-8 step 8
             drawrect(x,yscreen*2/2,4,yscreen/2)
        next
        for x = 0 to xscreen*4-12 step 12
             drawrect(x,yscreen*1/2,6,yscreen/2)
        next
        for x = 0 to xscreen*4-16 step 16
             drawrect(x,yscreen*0/2,8,yscreen/2)
        next

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return
