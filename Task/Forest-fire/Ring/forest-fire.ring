# Project : Forest fire

load "guilib.ring"
load "stdlib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Forest fire")
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

pregen = newlist(200,200)
newgen = newlist(200,200)

 for gen = 1 to 20
      see "gen = " + gen + nl
      for x = 1 to 199
           for y = 1 to 199
                 switch pregen[x][y]
                            on 0
                                 if random(9)/10 > 0.099
                                    newgen[x][y] = 1
                                    color = new qcolor()
                                    color.setrgb(0,128,0,255)
                                    pen.setcolor(color)
                                    setpen(pen)
                                    drawpoint(x,y)
                                 ok
                            on 2
                                 newgen[x][y] = 0
                                 color = new qcolor()
                                 color.setrgb(165,42,42,255)
                                 pen.setcolor(color)
                                 setpen(pen)
                                 drawpoint(x,y)
                            on 1
                                 if pregen[x][y] = 2 or pregen[x][y]   = 2 or pregen[x][y+1] = 2 or
                                    pregen[x][y]   = 2 or pregen[x][y+1]   = 2 or pregen[x+1][y] = 2 or
                                    pregen[x+1][y]   = 2 or pregen[x+1][y+1] = 2 or random(9)/10 > 0.0999
                                    color = new qcolor()
                                    color.setrgb(255,0,0,255)
                                    pen.setcolor(color)
                                    setpen(pen)
                                    drawpoint(x,y)
                                    newgen[x][y] = 2
                                 ok
                 off
                 pregen[x][y] = newgen[x][y]
           next
      next
next

        endpaint()
        }
        label1 { setpicture(p1) show() }
        return
