load "guilib.ring"

# --- GLOBAL DATA ---
nPlayer   = 1
aBoard    = list(24)
aButtons  = list(24)
oStatus   = null    # Global object for the caption
for i=1 to 24 aBoard[i] = 0 next

# Mill combinations (16 pieces)
aMills = [[1,2,3],[4,5,6],[7,8,9],[10,11,12],[13,14,15],[16,17,18],[19,20,21],[22,23,24],
          [1,10,22],[4,11,19],[7,12,16],[2,5,8],[17,20,23],[9,13,18],[6,14,21],[3,15,24]]

# Coordinates [X, Y]
aPos = [[50,50],[300,50],[550,50],[150,150],[300,150],[450,150],[250,250],[300,250],[350,250],
        [50,300],[150,300],[250,300],[350,300],[450,300],[550,300],[250,350],[300,350],[350,350],
        [150,450],[300,450],[450,450],[50,550],[300,550],[550,550]]

# --- GUI COMPILATION ---
oApp = new qApp {
    win = new qWidget() {
        setWindowTitle("Ring Mill")
        setGeometry(100,100,650,680)
        setStyleSheet("background-color: #DEB887;")

        for i = 1 to 24
            aButtons[i] = new qPushButton(win) {
                setGeometry(aPos[i][1]-20, aPos[i][2]-20, 40, 40)
                setStyleSheet("background-color: #8B4513; border-radius: 20px; border: 2px solid black;")
                setClickEvent("pClick(" + i + ")")
            }
        next

        # The caption is saved in the global oStatus
        oStatus = new qLabel(win) {
            setGeometry(0, 620, 650, 40)
            setText("WHITE player follows")
            setAlignment(Qt_AlignHCenter | Qt_AlignVCenter)
            setStyleSheet("font-size: 18px; font-weight: bold; background-color: #5D4037; color: white;")
        }
        show()
    }
    exec()
}

# --- LOGIC ---
func pClick nID
    if aBoard[nID] != 0 return ok

    aBoard[nID] = nPlayer

    if nPlayer = 1
        aButtons[nID].setStyleSheet("background-color: white; border-radius: 20px; border: 3px solid black;")
        sMsg = "BLACK player follows"
    else
        aButtons[nID].setStyleSheet("background-color: black; border-radius: 20px; border: 3px solid white;")
        sMsg = "WHITE player follows"
    ok

    if fCheckMill(nID)
        new qMessageBox(null) {
            setWindowTitle("MALOM!")
            setText("Gratulálok! Malom alakult ki!")
            show()
        }
    ok

    nPlayer = 3 - nPlayer
    # Use a global reference:
    oStatus.setText(sMsg)

func fCheckMill nID
    for mill in aMills
        if find(mill, nID)
            count = 0
            for p in mill
                if aBoard[p] = nPlayer count++ ok
            next
            if count = 3 return true ok
        ok
    next
    return false
