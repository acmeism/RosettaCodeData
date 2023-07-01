# Project : Show Ascii table

load "guilib.ring"
load "stdlib.ring"

decarr = newlist(16,6)
ascarr = newlist(16,6)

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Show Ascii table")
                  setgeometry(100,100,800,600)
                  for n = 1 to 16
                       for m = 1 to 6
                            decarr[n][m] = new qpushbutton(win1) {
                                                  x = 150+m*60
                                                  y = 30 + n*30
                                                  ind = string((m-1)*16+n+31)
                                                  setgeometry(x,y,30,30)
                                                  settext(ind)
                                                  }
                       next
                  next
                  for n = 1 to 16
                       for m = 1 to 6
                            ascarr[n][m] = new qpushbutton(win1) {
                                                  x = 180+m*60
                                                  y = 30 + n*30
                                                  ind = (m-1)*16+n+31
                                                  setgeometry(x,y,30,30)
                                                  if ind = 32
                                                     settext("Spc")
                                                     loop
                                                  ok
                                                  if ind = 127
                                                     settext("Del")
                                                     loop
                                                  ok
                                                  settext(char(ind))
                                                  }
                       next
                  next
                  show()
        }
        exec()
        }
