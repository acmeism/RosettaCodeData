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

        x1=300 y1=250
        i1=-1 i2=1 r1=-2 r2=1
        s1=(r2-r1)/x1 s2=(i2-i1)/y1
        for y=0 to y1
            i3=i1+s2*y
            for x=0 to x1
                r3=r1+s1*x z1=r3 z2=i3
                for n=0 to 30
                    a=z1*z1 b=z2*z2
                    if a+b>4 exit ok
                       z2=2*z1*z2+i3 z1=a-b+r3
                next
                if n != 31 drawpoint(x,y) ok
            next
        next

        endpaint()
        }
        label1 { setpicture(p1) show() }
