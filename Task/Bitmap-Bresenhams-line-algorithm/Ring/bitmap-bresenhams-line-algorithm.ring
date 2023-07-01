load "guilib.ring"
load "stdlib.ring"

new qapp
       {
       win1 = new qwidget() {
              setwindowtitle("drawing using qpainter")
              setwinicon(self,"c:\ring\bin\image\browser.png")
              setgeometry(100,100,500,600)
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

        line = [[50,100,100,190], [100,190,150,100], [150,100,100,10], [100,10,50,100]]

        for n = 1 to 4
            x1=line[n][1] y1=line[n][2] x2=line[n][3] y2=line[n][4]
            dx = fabs(x2 - x1)  sx = sign(x2 - x1)
            dy = fabs(y2 - y1)  sy = sign(y2 - y1)
            if dx < dy e = dx / 2 else e = dy / 2 ok
            while true
                  drawline (x1*2,y1*2,x2*2,y2*2)
                  if x1 = x2 if y1 = y2 exit ok ok
                  if dx > dy
                     x1 += sx  e -= dy if e < 0 e += dx  y1 += sy ok
                  else
                     y1 += sy e -= dx if e < 0 e += dy x1 += sx ok ok
            end
        next

        endpaint()
        }
        label1 { setpicture(p1) show() }
