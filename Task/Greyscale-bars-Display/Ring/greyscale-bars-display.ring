# Project : Greyscale bars/Display
# Date    : 2018/01/09
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "guilib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Greyscale bars/Display")
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

        for row=1 to 4
              n=pow(2,(row+2))
              w=1280/n
              py=256*(4-row)
              for b=0 to n-1
                   g=floor(255*b/(n-1))
                   if n=16 or n=64
                      g=255-g
                   ok
                   color2 = new qcolor()
                   color2.setrgb(g,g,g,255)
                   mybrush = new qbrush() {setstyle(1) setcolor(color2)}
                   paint.setbrush(mybrush)
                   paint.drawrect(w*b,py,w,256)
              next
        next

        endpaint()
        }
        label1 { setpicture(p1) show() }
