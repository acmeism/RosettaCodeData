load "guilib.ring"
load "stdlib.ring"

MyApp = New qApp {

        win1 = new qWidget() {

                setwindowtitle("Hello World")
                setGeometry(100,100,370,250)

                Text = "This is an example of speech synthesis"
                Text = split(Text," ")

                label1 = new qLabel(win1) {
                        settext("What is your name ?")
                        setGeometry(10,20,350,30)
                        setalignment(Qt_AlignHCenter)
                }

                btn1 = new qpushbutton(win1) {
                        setGeometry(10,200,100,30)
                        settext("Say Hello")
                        setclickevent("pHello()")
                }

                btn2 = new qpushbutton(win1) {
                        setGeometry(150,200,100,30)
                        settext("Close")
                        setclickevent("pClose()")
                }

                lineedit1 = new qlineedit(win1) {
                        setGeometry(10,100,350,30)
                }

                voice = new QTextToSpeech(win1) {
                }
                show()
        }
        exec()
}

Func pHello
        lineedit1.settext( "Hello " + lineedit1.text())
        for n = 1 to len(Text)
            voice.Say(Text[n])
            see Text[n] + nl
        next

Func pClose
        MyApp.quit()
