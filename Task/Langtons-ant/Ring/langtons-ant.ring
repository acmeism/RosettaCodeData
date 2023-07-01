load "guilib.ring"
load "stdlib.ring"

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

        fieldsize=100
        field = newlist(fieldsize,fieldsize)
        x=fieldsize/2
        y=fieldsize/2
        d=0
        while x<=fieldsize and x>=0 and y<=fieldsize and y>=0
                if field[x][y]=0  field[x][y]=1 d-=1 else field[x][y]=0 d+=1 ok
                drawpoint(x*2, y*2)
                d=(d+4) % 4
                switch d
                        on 0 y+=1
                        on 1 x+=1
                        on 2 y-=1
                        on 3 x-=1
                off
        end

        endpaint()
        }
        label1 { setpicture(p1) show() }
