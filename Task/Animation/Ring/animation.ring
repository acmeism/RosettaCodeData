# Project : Animation

Load "guilib.ring"
load "stdlib.ring"
rotate = false

MyApp = New qApp {
              win1 = new qWidget() {
                         setwindowtitle("Hello World")
                         setGeometry(100,100,370,250)

                         lineedit1 = new qlineedit(win1) {
                                         setGeometry(10,100,350,30)
                                         lineedit1.settext(" Hello World! ")
                         myfilter = new qallevents(lineedit1)
                         myfilter.setMouseButtonPressevent("rotatetext()")
                         installeventfilter(myfilter)}
              show()}
exec()}

func rotatetext()
        rotate = not rotate
        strold = " Hello World! "
        for n = 1 to 15
                 if rotate = true
                    see "str = " + '"' + strold + '"' + nl
                    strnew = right(strold, 1) + left(strold, len(strold) - 1)
                    lineedit1.settext(strnew)
                    strold = strnew
                    sleep(1)
                 ok
                 if rotate = false
                    see "str = " + '"' + strold + '"' + nl
                    strnew = right(strold, len(strold) - 1) + left(strold, 1)
                    lineedit1.settext(strnew)
                    strold = strnew
                    sleep(1)
                 ok
        next
        see nl
