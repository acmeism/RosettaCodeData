# Project  : Draw pixel 2

load "guilib.ring"

new qapp {
       nwidth = 320
       nheight= 240
       win1 = new qwidget() {
                  setwindowtitle("Draw Pixel 2")
                  setgeometry(100,100,640,480)
                  label1 = new qlabel(win1) {
                              setgeometry(10,10,640,480)
                              settext("")
                  }
                  new qpushbutton(win1) {
                         setgeometry(200,400,100,30)
                         settext("draw")
                         setclickevent("draw()")
                  }
                  new qpushbutton(win1) {
                         setgeometry(300,400,100,30)
                         settext("get pixel color")
                         setclickevent("PixelColor()")
                  }
                  show()
       }
       exec()
}

func draw()
        p1 = new qpicture()
        color = new qcolor() {
                   setrgb(255,255,0,255)
                  }
        pen = new qpen() {
                  setcolor(color)
                  setwidth(10)
                  }
        new qpainter() {
               begin(p1)
               setpen(pen)
               x = random(nwidth-1) + 1
               y = random(nheight-1) + 1
               see "x = " + x + " y = " + y + nl
               drawpoint(x,y)
               endpaint()
               }
               label1 { setpicture(p1) show() }

func PixelColor()
       oapp = new qapp(0,null)  {
                  screen = win1.windowhandle().screen()
                  pixmap = screen.grabwindow(0,0,0,-1,-1)
                  image = pixmap.toimage()
                  color = image.pixel(100,100)
                  mycolor = new qcolor()
                  mycolor.setrgb(255,255,0,255)
                  see nl+"red : " + mycolor.red() + nl
                  see "green : " + mycolor.green() + nl
                  see "blue : " + mycolor.blue() + nl
                  }
