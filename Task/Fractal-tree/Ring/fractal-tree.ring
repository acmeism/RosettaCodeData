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
               draw()
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

        sizex = 400
        sizey = 200
        depth = 10

        tree(self, sizex, 0, sizey/2, 90, depth)

        endpaint()
        }
        label1 { setpicture(p1) show() }

        func tree myObj, x1, y1, size, angle, depth
             myObj{
             scale = 0.76
             spread = 25
             x2 = x1 + size * cos(angle)
             y2 = y1 + size * sin(angle)
             drawline(x1, y1, x2, y2)
             if depth > 0
             tree(self, x2, y2, size * scale, angle - spread, depth - 1)
             tree(self, x2, y2, size * scale, angle + spread, depth - 1) ok}
