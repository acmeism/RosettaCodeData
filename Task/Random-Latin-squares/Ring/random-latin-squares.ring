load "stdlib.ring"
load "guilib.ring"

###====================================================================================

size      = 10

time1     = 0
bwidth    = 0
bheight   = 0	
				
a2DSquare = newlist(size,size)
a2DFinal  = newlist(size,size)

aList  = 1:size
aList2 = RandomList(aList)

GenerateRows(aList2)
ShuffleCols(a2DSquare, a2DFinal)

C_SPACING           = 1
Button              = newlist(size,size)
LayoutButtonRow     = list(size)
C_ButtonOrangeStyle = 'border-radius:1x;color:black; background-color: orange'

###====================================================================================

MyApp = New qApp {

	StyleFusion()

	win = new qWidget() {

		workHeight = win.height()
		fontSize = 8 + (300/size)

	    wwidth = win.width()
	    wheight = win.height()
	    bwidth = wwidth/size
	    bheight = wheight/size

		setwindowtitle("Random Latin Squares")
		move(555,0)
		setfixedsize(1000,1000)

		myfilter = new qallevents(win)
		myfilter.setResizeEvent("resizeBoard()")
		installeventfilter(myfilter)

		LayoutButtonMain = new QVBoxLayout() {
			setSpacing(C_SPACING)
			setContentsmargins(50,50,50,50)
		}

		LayoutButtonStart = new QHBoxLayout() {
			setSpacing(C_SPACING)
			setContentsmargins(0,0,0,0)
		}

		btnStart = new qPushButton(win) {
			setFont(new qFont("Calibri",fontsize,2100,0))
			resize(bwidth,bheight)
			settext(" Start ")
			setstylesheet(C_ButtonOrangeStyle)
			setclickevent("gameSolution()")
		}

		sizeBtn = new qlabel(win)
		{
			setFont(new qFont("Calibri",fontsize,2100,0))
			resize(bwidth,bheight)
			setStyleSheet("background-color:rgb(255,255,204)")
			setText(" Size: ")
		}	

		lineSize = new qLineEdit(win)
		{
			setFont(new qFont("Calibri",fontsize,2100,0))
			resize(bwidth,bheight)
			setStyleSheet("background-color:rgb(255,255,204)")
			setAlignment( Qt_AlignHCenter)
			setAlignment( Qt_AlignVCenter)
			setreturnPressedEvent("newBoardSize()")
			setText(string(size))
		}

		btnExit = new qPushButton(win) {
			setFont(new qFont("Calibri",fontsize,2100,0))
			resize(bwidth,bheight)
			settext(" Exit ")
			setstylesheet(C_ButtonOrangeStyle)
			setclickevent("pExit()")
		}

		LayoutButtonStart.AddWidget(btnStart)
		LayoutButtonStart.AddWidget(sizeBtn)
		LayoutButtonStart.AddWidget(lineSize)
		LayoutButtonStart.AddWidget(btnExit)
	
		LayoutButtonMain.AddLayout(LayoutButtonStart)

		for Row = 1 to size

			LayoutButtonRow[Row] = new QHBoxLayout() {
				setSpacing(C_SPACING)
				setContentsmargins(0,0,0,0)
			}

			for Col = 1 to size
				Button[Row][Col] = new qlabel(win) {
					setFont(new qFont("Calibri",fontsize,2100,0))
					resize(bwidth,bheight)
				}
				LayoutButtonRow[Row].AddWidget(Button[Row][Col])
			next
			LayoutButtonMain.AddLayout(LayoutButtonRow[Row])

		next

		setLayout(LayoutButtonMain)

		 show()

	}

	exec()
}

###====================================================================================

func newBoardSize()

	nrSize = number(lineSize.text())

	if nrSize = 1
		? "Enter: Size > 1"
		return
	ok

	for Row = 1 to size
		for Col = 1 to size
			Button[Row][Col].settext("")
		next
	next

	newWindow(nrSize)

###====================================================================================

func newWindow(newSize)

	time1 = clock()

	for Row = 1 to size
		for Col = 1 to size
			Button[Row][Col].delete()
		next
	next

	size = newSize

	bwidth  = ceil((win.width() - 8) / size)
	bheight = ceil((win.height() - 32) / size)

	fontSize = 8 + (300/size)

	if size > 16
		fontSize = 8 + (150/size)
	ok

	if size < 8
		fontSize = 30 + (150/size)
	ok

	if size = 2
		fontSize = 10 + (100/size)
	ok

	btnStart.setFont(new qFont("Calibri",fontsize,2100,0))
	sizeBtn.setFont(new qFont("Calibri",fontsize,2100,0))
	lineSize.setFont(new qFont("Calibri",fontsize,2100,0))
	btnExit.setFont(new qFont("Calibri",fontsize,2100,0))

	LayoutButtonStart = new QHBoxLayout() {
		setSpacing(C_SPACING)
		setContentsmargins(0,0,0,0)
	}

	Button = newlist(size,size)
	LayoutButtonRow = list(size)

	for Row = 1 to size

		LayoutButtonRow[Row] = new QHBoxLayout() {
			setSpacing(C_SPACING)
			setContentsmargins(0,0,0,0)
		}

		for Col = 1 to size

			Button[Row][Col] = new qlabel(win) {
				setFont(new qFont("Calibri",fontsize,2100,0))
				resize(bwidth,bheight)
			}
			LayoutButtonRow[Row].AddWidget(Button[Row][Col])

		next

		LayoutButtonMain.AddLayout(LayoutButtonRow[Row])

	next

	win.setLayout(LayoutButtonMain)

	return

###====================================================================================

func resizeBoard

	bwidth  = ceil((win.width() - 8) / size)
	bheight = ceil((win.height() - 32) / size)

	for Row = 1 to size
		for Col = 1 to size
			Button[Row][Col].resize(bwidth,bheight)
		next
	next

###====================================================================================

Func pExit

	MyApp.quit()

###====================================================================================

func gameSolution()

	a2DSquare = newlist(size,size)
	a2DFinal  = newlist(size,size)

	aList  = 1:size
	aList2 = RandomList(aList)

	GenerateRows(aList2)
	ShuffleCols(a2DSquare, a2DFinal)

	for nRow = 1 to size
		for nCol = 1 to size
			Button[nRow][nCol].settext("-")
		next
	next

	for nRow = 1 to size
		for nCol = 1 to size
			Button[nRow][nCol].resize(bwidth,bheight)
			Button[nRow][nCol].settext(string(a2DSquare[nRow][nCol]))
		next
	next

	time2 = clock()
	time3 = (time2 - time1)/1000
	? "Elapsed time: " + time3 + " ms at size = " + size + nl

###====================================================================================

// Scramble the numbers in the List
// Uniq random picks, then shorten list by each pick

Func RandomList(aInput)

    aOutput = []

    while len(aInput) > 1
        nIndex = random(len(aInput)-1)
        nIndex++

        aOutput + aInput[nIndex]
        del(aInput,nIndex)
    end

    aOutput + aInput[1]

return aOutput

###====================================================================================
// Generate Rows of data. Put them in the 2DArray

Func GenerateRows(aInput)

	aOutput = []
	size  = len(aInput)
    shift = 1

	for k = 1 to size									// Make 8 Rows of lists
		aOutput = []
		
		for i = 1 to size           					// make a list
			   pick = i + shift     					// shift every Row by +1 more
			if pick > size   pick = pick - size  ok
	
			aOutput + aInput[pick]
		next
	
		a2DSquare[k] = aOutput							// Row of Output to a2DSquare

		shift++                    						// shift next line by +1 more
		if shift > size  shift = 1 ok
	next

	return

###====================================================================================
// Shift random Rows into a2DFinal, then random Cols

Func ShuffleCols(a2DSquare, a2DFinal)

	aSuffle  = 1:size
    aSuffle2 = RandomList(aSuffle)	// Pick random Col to insert in a2DFinal
	
	for i = 1 to size           	// Row		
		pick = aSuffle2[i]

        for j = 1 to size			// Col
			a2DFinal[i][j] =  a2DSquare[pick][j]  // i-Row-Col j-Horz-Vert
		next
	next

	a2DSquare = a2DFinal			// Now do the verticals
	aSuffle  = 1:size
	aSuffle2 = RandomList(aSuffle)

	for i = 1 to size           	// Row		
		pick = aSuffle2[i]

        for j = 1 to size			// Col
			a2DFinal[j][i] =  a2DSquare[j][pick]  //Reverse i-j , i-Row-Col j-Horz-Vert
		next
	next

	return

###====================================================================================
