# Project : Cantor set

load "guilib.ring"
paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("")
                  setgeometry(100,100,800,600)
                  label1 = new qlabel(win1) {
                              setgeometry(10,10,800,600)
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
                 setwidth(10)
        }
        paint = new qpainter() {
                  begin(p1)
                  setpen(pen)

        cantor(10,20,600)

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return

func cantor(x,y,lens)
        if lens >= 10
           paint.drawline(x,y,x+lens,y)
           y = y + 20
           cantor(x,y,floor(lens/3))
           cantor(x+floor(lens*2/3),y,floor(lens/3))
        ok
