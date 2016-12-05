load "guilib.ring"

new qapp
        {
        win1 = new qwidget() {
               setwindowtitle("drawing using qpainter")
               setwinicon(self,"C:\Ring\bin\image\browser.png")
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

     //Black, Red, Green, Blue, Magenta, Cyan, Yellow, White

     for n = 1 to 8
         color2 = new qcolor(){
         switch n
                on 1 r=0 g=0 b=0
                on 2 r=255 g=0 b=0
                on 3 r=0 g=255 b=0
                on 4 r=0 g=0 b=255
                on 5 r=255 g=0 b=255
                on 6 r=0 g=255 b=255
                on 7 r=255 g=255 b=0
                on 8 r=255 g=255 b=255
           off
           setrgb(r,g,b,255)
           }
           mybrush = new qbrush() {setstyle(1) setcolor(color2)}
           setbrush(mybrush)
           drawrect(n*25,25,25,70)
     next

     endpaint()
     }
     label1 { setpicture(p1) show() }
