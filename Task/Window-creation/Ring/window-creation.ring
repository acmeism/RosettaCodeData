Load "guilib.ring"

MyApp = New qApp {
        win1 = new qWidget() {
               setwindowtitle("Hello World")
               setGeometry(100,100,370,250)
               show()}
        exec()}
