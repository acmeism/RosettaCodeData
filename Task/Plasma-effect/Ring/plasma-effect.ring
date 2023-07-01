# Project : Plasma effect

load "guilib.ring"

paint = null

new qapp
       {
        win1 = new qwidget()
       {
                   setwindowtitle("Plasma effect")
                   setgeometry(100,100,500,600)

                   label1 = new qlabel(win1)
                   {
                   setgeometry(10,10,400,400)
                   settext("")
                    }

                   new qpushbutton(win1)
                   {
                   setgeometry(150,500,100,30)
                   settext("Draw")
                   setclickevent("Draw()")
                  }
                  show()
       }
       exec()
       }

func draw

        p1    = new qpicture()
        color = new qcolor() { setrgb(0,0,255,255) }   ### <<< BLUE
        pen   = new qpen() { setcolor(color) setwidth(1) }

        paint = new qpainter()
        {
                   begin(p1)
                   setpen(pen)

                   w = 256
                   h = 256
                   time = 0

                   for x = 0 to w -1
                         for y = 0 to h -1
                               time = time + 0.99
                               value = sin(dist(x + time, y, 128, 128) / 8) +
                                           sin(dist(x, y, 64, 64) / 8) +
                                           sin(dist(x, y + time / 7, 192, 64) / 7) +
                                           sin(dist(x, y, 192, 100) / 8) + 4
                               c = floor(value * 32)
                               r = c
                               g = (c*2)%255
                               b = 255-c
                               color2 = new qcolor()
                               color2.setrgb(r,g,b,255)
                               pen.setcolor(color2)
                               setpen(pen)
                               drawpoint(x,y)
                        next
                   next
        endpaint()
        }
        label1 { setpicture(p1) show() }
        return

func dist(a, b, c, d)
        d = sqrt(((a - c) * (a - c) + (b - d) * (b - d)))
        return d
