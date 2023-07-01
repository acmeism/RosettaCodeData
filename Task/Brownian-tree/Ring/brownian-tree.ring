# Project : Brownian tree

load "stdlib.ring"
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
                 setwidth(1)
        }
        paint = new qpainter() {
                   begin(p1)
                   color = new qcolor()
                   color.setrgb(255,0,0,255)
                   pen = new qpen() {
                   setcolor(color)
                   setwidth(1)}
                   setpen(pen)

        browniantree()

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return

func browniantree()
        numparticles = 3000
        canvas = newlist(210,210)
        canvas[randomf() * 100][randomf() * 200] = 1
        for i = 1 to numparticles
             x = floor((randomf() * 199)) + 1
             y = floor((randomf() * 199)) + 1
             if x = 1
                x = 2
             ok
             if y = 1
                y = 2
             ok
             while canvas[x+1][y+1]+canvas[x][y+1]+canvas[x+1][y]+canvas[x-1][y-1]+canvas[x-1][y]+canvas[x][y-1] = 0
                     x = x + floor((randomf() * 2)) + 1
                     y = y + floor((randomf() * 2)) + 1
                     if x = 1
                        x = 2
                     ok
                     if y = 1
                        y = 2
                     ok
                     if x < 1 or x > 200 or y < 1 or y > 200
                        x = floor((randomf()  * 199)) + 1
                        y = floor((randomf()  * 199)) + 1
                        if x = 1
                           x = 2
                        ok
                        if y = 1
                           y = 2
                        ok
                     ok
             end
             canvas[x][y] = 1
             paint.drawpoint(x,y)
             paint.drawpoint(x,y+1)
             paint.drawpoint(x,y+2)
        next

func randomf()
       decimals(10)
       str = "0."
       for i = 1 to 10
            nr = random(9)
            str = str + string(nr)
       next
       return number(str)
