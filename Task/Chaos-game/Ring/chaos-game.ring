# Project : Chaos game

load "guilib.ring"

paint = null

new qapp
       {
       win1 = new qwidget() {
                  setwindowtitle("Archimedean spiral")
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

       x = floor(random(10)/10 * 200)
       y = floor(random(10/10) * 173)
       for i = 1 to 20000
           v = floor(random(10)/10 * 3) + 1
	   if v = 1
	      x = x/2
	      y = y/2
	   ok
	   if v = 2
	      x = 100 + (100-x)/2
	      y = 173 - (173-y)/2
	   ok
	   if v = 3
	      x = 200 - (200-x)/2
	      y = y/2
	   ok
	   drawpoint(x,y)
       next
       endpaint()
       }
       label1 {setpicture(p1) show()}
