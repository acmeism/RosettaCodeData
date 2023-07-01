# Project : Identity Matrix
# Date    : 2022/16/02
# Author  : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

load "stdlib.ring"
load "guilib.ring"

size = 8
C_Spacing = 1

C_ButtonBlueStyle   = 'border-radius:6px;color:black; background-color: blue'
C_ButtonOrangeStyle = 'border-radius:6px;color:black; background-color: orange'

Button = newlist(size,size)
LayoutButtonRow = list(size)

app = new qApp
{
      win = new qWidget() {
	    setWindowTitle('Identity Matrix')
	    move(500,100)
	    reSize(600,600)
	    winheight = win.height()
	    fontSize = 18 + (winheight / 100)

 	    LayoutButtonMain = new QVBoxLayout()			
	    LayoutButtonMain.setSpacing(C_Spacing)
	    LayoutButtonMain.setContentsmargins(0,0,0,0)

	    for Row = 1 to size
		LayoutButtonRow[Row] = new QHBoxLayout() {
				       setSpacing(C_Spacing)
				       setContentsmargins(0,0,0,0)
				       }
         	 for Col = 1 to size
		     Button[Row][Col] = new QPushButton(win) {
                                        setSizePolicy(1,1)
					}
					
		     LayoutButtonRow[Row].AddWidget(Button[Row][Col])	
		 next
		 LayoutButtonMain.AddLayout(LayoutButtonRow[Row])			
	      next
              LayoutDataRow1 = new QHBoxLayout() { setSpacing(C_Spacing) setContentsMargins(0,0,0,0) }
              LayoutButtonMain.AddLayout(LayoutDataRow1)
              setLayout(LayoutButtonMain)
              show()
   }
   pBegin()
   exec()
   }

func pBegin()
     for Row = 1 to size
         for Col = 1 to size
             if Row = Col
                Button[Row][Col].setStyleSheet(C_ButtonOrangeStyle)
                Button[Row][Col].settext("1")
             else
                Button[Row][Col].setStyleSheet(C_ButtonBlueStyle)
                Button[Row][Col].settext("0")
             ok
	 next
     next
     score = 0
