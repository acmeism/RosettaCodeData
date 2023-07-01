Load "guilib.ring"

MyApp = New qApp {
                 num = 0
                 win1 = new qWidget() {
                        setwindowtitle("Hello World")
                        setGeometry(100,100,370,250)

                        btn1 = new qpushbutton(win1) {
                               setGeometry(130,200,100,30)
                               settext("Validate")
                               setclickevent("Validate()")}

                        lineedit1 = new qlineedit(win1) {
                                    setGeometry(10,100,250,30)
                                    settext("")}

                        lineedit2 = new qlineedit(win1) {
                                    setGeometry(10,150,50,30)
                                    settext("0")}

                        label1 = new qLabel(win1) {
                                 setGeometry(270,100,50,30)
		                 setText("")}

                        label2 = new qLabel(win1) {
                                 setGeometry(70,150,50,30)
		                 setText("")}
	
                        label3 = new qLabel(win1) {
                                 setGeometry(10,50,250,30)
		                 setText("Please enter a string, and the number 75000 :")}
                 show()}
                 exec()}

func Validate
     lineedit1{temp1 = text()}
     num1 = isdigit(temp1)
     if num1 = 0 label1{settext("OK")} else label1{settext("NOT OK")} ok

     lineedit2{temp2 = text()}
     num2 = number(temp2)
     if num2 = 75000 label2{settext("OK")} else label2{settext("NOT OK")} ok
