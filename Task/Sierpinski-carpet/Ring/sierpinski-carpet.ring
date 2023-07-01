load "guilib.ring"

new qapp
        {
        win1 = new qwidget() {
                   etwindowtitle("drawing using qpainter")
                   setgeometry(100,100,500,500)
               label1 = new qlabel(win1) {
                        setgeometry(10,10,400,400)
                        settext("")
               }
               new qpushbutton(win1) {
                   setgeometry(200,450,100,30)
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

         order = 3
         side = pow(3,order)
         for y = 0 to side-1
             for x = 0 to side-1
                 if carpet(self,x,y)
                    drawpoint(x*16,y*16+15)
                    drawpoint(x*16+1,y*16+16)
                    drawpoint(x*16+2,y*16+17) ok
             next
         next

         endpaint()
        }
        label1 { setpicture(p1) show() }

        func carpet myObj,x,y
             myObj{while x!=0 and y!=0
                         if x % 3 = 1 if y % 3 = 1 return false ok ok
                         x = floor(x/3)
                         y = floor(y/3)
                   end
                   return true}
