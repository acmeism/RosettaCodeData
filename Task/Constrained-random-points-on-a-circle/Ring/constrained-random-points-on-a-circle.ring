load "guilib.ring"

new qapp
        {
        win1 = new qwidget() {
                   setwindowtitle("drawing using qpainter")
                   setgeometry(100,100,500,500)
                   label1 = new qlabel(win1) {
                            setgeometry(10,10,400,400)
                            settext("")
                  }
                  new qpushbutton(win1) {
                      setgeometry(200,400,100,30)
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
        new qpainter() {
            begin(p1)
            setpen(pen)

        for i = 1 to 1000
            x = random(31)-16
            y = random(31)-16
            r = sqrt (pow(x,2) + pow(y,2))
            if r >= 10 if r <= 15 drawpoint(x*2, y*2) ok ok
        next

        endpaint()
        }
        label1 { setpicture(p1) show() }
