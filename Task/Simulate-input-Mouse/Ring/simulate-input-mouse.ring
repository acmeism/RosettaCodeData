# Project : Simulate input/Mouse

load "guilib.ring"
load "stdlib.ring"

paint = null

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("")
                  setgeometry(100,100,800,600)
                  setwindowtitle("Mouse events")

                  line1 = new qlineedit(win1) {
                              setgeometry(150,450,300,30)
                              settext("")}

                  line2 = new qlineedit(win1) {
                              setgeometry(150,400,300,30)
                              settext("")}

                  new qpushbutton(win1) {
                          setgeometry(150,500,300,30)
                          settext("draw")
                          myfilter = new qallevents(win1)
                          myfilter.setMouseButtonPressevent("drawpress()")
                          myfilter.setMouseButtonReleaseevent("drawrelease()")
                          installeventfilter(myfilter)
                  }
                  show()
        }
        exec()
        }

func drawpress()
        line2.settext("")
        line1.settext("Mouse was pressed")

func drawrelease()
        line1.settext("")
        line2.settext("Mouse was released")
