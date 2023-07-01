load "guilib.ring"
load "stdlib.ring"

size = 3
flip = newlist(size,size)
board = newlist(size,size)
colflip = list(size)
rowflip = list(size)

new qapp
        {
        win1 = new qwidget() {
                  setwindowtitle("Flipping bits game")
                  setgeometry(465,115,800,600)
                  label1 = new qlabel(win1) {
                              setgeometry(285,60,120,40)
                              settext("Target")
                  }
                  label2 = new qlabel(win1) {
                              setgeometry(285,220,120,40)
                              settext("Board")
                  }
                  for n = 1 to size
                       for m = 1 to size
                            flip[n][m] = new qpushbutton(win1) {
                                             setgeometry(200+n*40,60+m*40,40,40)
                                             settext(string(random(1)))
                                             }
                       next
                  next
                  for n = 1 to size
                       for m = 1 to size
                            board[n][m] = new qpushbutton(win1) {
                                                 setgeometry(200+n*40,260+m*40,40,40)
                                                 setclickevent("draw(" + n + "," + m +")")
                                                 }
                       next
                  next
                  for n = 1 to size
                       colflip[n]= new qpushbutton(win1) {
                                              setgeometry(200+n*40,260,40,40)
                                              settext("Go")
                                              setclickevent("coldraw(" + n + ")")
                                              }
                  next
                  for n = 1 to size
                       rowflip[n]= new qpushbutton(win1) {
                                               setgeometry(200,260+n*40,40,40)
                                               settext("Go")
                                               setclickevent("rowdraw(" + n + ")")
                                               }
                  next
                  scramblebutton = new qpushbutton(win1) {
                                                   setgeometry(240,460,120,40)
                                                   settext("Scramble Board")
                                                   setclickevent("scramble(flip)")
                                                   }
        scramblebegin(flip)
        show()
        }
        exec()
        }

func coldraw(n)
        for row = 1 to size
             board[n][row] {temp = text()}
             if temp = "0"
                board[n][row].settext("1")
             else
                board[n][row].settext("0")
             ok
         next

func rowdraw(n)
        for col = 1 to size
             board[col][n] {temp = text()}
             if temp = "0"
                board[col][n].settext("1")
             else
                board[col][n].settext("0")
             ok
         next

func scramble(flip)
        for col = 1 to size
             for row = 1 to size
                  flip[col][row]{temp = text()}
                  board[col][row].settext(temp)
             next
        next
        for mix = 1 to size*10
             colorrow = random(1) + 1
             colrow = random(size-1) + 1
             if colorrow = 1
                rc = "coldraw"
             else
                rc = "rowdraw"
             ok
             go = rc + "(" + colrow + ")"
             eval(go)
        next

func scramblebegin(flip)
        for col = 1 to size
             for row = 1 to size
                  flip[col][row]{temp = text()}
                  board[col][row].settext(temp)
             next
        next
