load "guilib.ring"

New qApp {
         win1 = new qMainWindow() {
                setwindowtitle("Using QDateEdit")
                setGeometry(100,100,250,100)
                oDate = new qdateedit(win1) {
                        setGeometry(20,40,220,30)
	                oDate.minimumDate()
                }
                show()
                }
                exec()
                }
