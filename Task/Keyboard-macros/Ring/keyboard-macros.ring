load "guilib.ring"

app = new qApp {
      win = new qWidget() {
                setWindowTitle("Don't accept Spaces")
                move(100,100)    resize(400,400)
                new qLineedit(win) {
                    myfilter = new qAllEvents(win) {
                    setkeypressevent("keypress()")
                }
                installeventfilter(myfilter)
                }
                show()
            }
            exec()
      }

func keypress
     nKey = myfilter.getkeycode()
     switch nKey
            on 16777264 see "You pressed F1 " + nl
            on 16777265 see "You pressed F2 " + nl
     off
