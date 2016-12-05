Load "guilib.ring"

MyApp = New qApp {
        num = 0
        win1 = new qWidget() {
               setwindowtitle("Hello World")
               setGeometry(100,100,370,250)

               btn1 = new qpushbutton(win1) {
                    setGeometry(150,200,100,30)
                    settext("click me")
                    setclickevent("clickme()")}

                    Lineedit1 = new qlineedit(win1) {
                                setGeometry(10,100,350,30)}
        show()}
        Exec()}

func clickme
     num += 1
     lineedit1.settext( "you clicked me " + num + " times")
