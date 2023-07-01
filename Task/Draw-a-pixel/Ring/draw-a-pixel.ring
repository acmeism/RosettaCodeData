# Project  : Draw a pixel

load "guilib.ring"

new qapp {
       win1 = new qwidget() {
                  setwindowtitle("Drawing Pixels")
                  setgeometry(100,100,320,240)
                  label1 = new qlabel(win1) {
                              setgeometry(10,10,300,200)
                              settext("")
                  }
                  new qpushbutton(win1) {
                         setgeometry(200,200,100,30)
                         settext("draw")
                         setclickevent("draw()")
                  }
                  show()
       }
       exec()
}

func draw()
        p1 = new qpicture()
        color = new qcolor() {
                   setrgb(255,0,0,255)
                  }
        pen = new qpen() {
                  setcolor(color)
                  setwidth(5)
                  }
        new qpainter() {
               begin(p1)
               setpen(pen)
               drawpoint(100,100)
               endpaint()
               }
               label1 { setpicture(p1) show() }
