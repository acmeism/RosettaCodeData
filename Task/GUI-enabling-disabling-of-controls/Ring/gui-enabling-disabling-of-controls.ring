Load "guilib.ring"

MyApp = New qApp {
        num = 0
        win1 = new qWidget() {
               setwindowtitle("Hello World")
               setGeometry(100,100,370,250)

               btn1 = new qpushbutton(win1) {
                      setGeometry(50,200,100,30)
                      settext("Increment")
                      setclickevent("Increment()")}

               btn2 = new qpushbutton(win1) {
                      setGeometry(200,200,100,30)
                      settext("Decrement")
                      setclickevent("Decrement()")}

               lineedit1 = new qlineedit(win1) {
                           setGeometry(10,100,350,30)
                           settext("0")}
               show()}
exec()}

func Increment
     lineedit1{ num = text()}
     num = string(number(num)+1)
     lineedit1.settext(num)
     if number(num)>9 btn1.setDisabled(True) ok

func Decrement
     lineedit1{ num = text()}
     num = string(number(num)-1)
     lineedit1.settext(num)
     if number(num)<0 btn2.setDisabled(True) ok
