# Author: Gal Zsolt (CalmoSoft)
load "guilib.ring"
load "stdlib.ring"

# --- Global Variables ---
cTape         = "110100"
nHeadPos      = 1
cCurrentState = "q0"
nSpeed        = 500
# Rules format: [State, Read, [NewState, Write, Move]]
aRules        = [
    ["q0", "1", ["q0", "0", "R"]],
    ["q0", "0", ["q1", "1", "L"]],
    ["q1", "1", ["q1", "1", "R"]],
    ["q1", "0", ["halt", "1", "N"]]
]

# GUI Objects
winEdit = NULL
txtEdit = NULL

app = new qApp {
    win = new qWidget() {
        setWindowTitle("Turing Machine - CalmoSoft")
        resize(800, 650)
        setStyleSheet("QWidget { background-color: #1a1a1a; color: white; font-family: Arial; }")

        lblTape = new qLabel(win) {
            move(50, 30) resize(700, 120) setAlignment(132)
            setStyleSheet("border: 3px solid #00ffcc; border-radius: 15px; background: #262626;")
            setText(updateTapeView())
        }

        lblSpeed = new qLabel(win) { move(50, 160) setText("Speed (ms):") }

        sldSpeed = new qSlider(win) {
            move(50, 180) resize(250, 30) setOrientation(1)
            setRange(50, 2000) setValue(nSpeed)
            setValueChangedEvent("updateSpeed()")
        }

        timer = new qTimer(win) { setInterval(nSpeed) setTimeoutEvent("stepTuring()") }

        cmbRules = new qComboBox(win) {
            move(50, 230) resize(700, 45)
            # Item size and font increase via StyleSheet
            setStyleSheet("
                QComboBox {
                    background-color: #333; color: #00ffcc; border: 1px solid #444; font-size: 16px; padding-left: 10px;
                }
                QComboBox QAbstractItemView {
                    background-color: #222; color: #00ffcc; selection-background-color: #444; font-size: 16px;
                }
                QComboBox QAbstractItemView::item {
                    min-height: 40px;
                }
            ")
        }
        fillCombo()

        btnStep = new qPushButton(win) {
            move(50, 300) resize(170, 50) setText("STEP")
            setStyleSheet("background-color: #00ffcc; color: black; font-weight: bold;")
            setClickEvent("stepTuring()")
        }

        btnAuto = new qPushButton(win) {
            move(230, 300) resize(170, 50) setText("START / STOP")
            setStyleSheet("background-color: #f1c40f; color: black; font-weight: bold;")
            setClickEvent("toggleAuto()")
        }

        btnEdit = new qPushButton(win) {
            move(410, 300) resize(170, 50) setText("EDIT RULES")
            setStyleSheet("background-color: #3498db; color: white; font-weight: bold;")
            setClickEvent("openEditor()")
        }

        btnReset = new qPushButton(win) {
            move(590, 300) resize(160, 50) setText("RESET")
            setStyleSheet("background-color: #e74c3c; color: white;")
            setClickEvent("resetMachine()")
        }

        lblStatus = new qLabel(win) {
            move(50, 400) resize(700, 50) setAlignment(132)
            setStyleSheet("font-size: 22px; color: #00ffcc; font-weight: bold;")
            setText("State: " + cCurrentState)
        }
        win.show()
    }
    exec()
}

func updateTapeView
    cHTML = "<html><body style='font-family: Courier New; font-size: 40px;'><center>"
    for i = 1 to len(cTape)
        char = cTape[i]
        if i = nHeadPos
            cHTML += "<span style='color: #00ffcc; background-color: #444; border: 2px solid #00ffcc; padding: 5px;'> " + char + " </span>"
        else
            cHTML += "<span style='color: #ffffff; padding: 5px;'> " + char + " </span>"
        ok
    next
    return cHTML + "</center></body></html>"

func fillCombo
    cmbRules.clear()
    for r in aRules
        cmbRules.addItem("IF "+r[1]+","+r[2]+" -> GO "+r[3][1]+", WRITE "+r[3][2]+", MOVE "+r[3][3], 0)
    next

func toggleAuto
    if timer.isActive() timer.stop() else timer.start() ok

func updateSpeed
    nSpeed = sldSpeed.value()
    timer.setInterval(nSpeed)

func stepTuring
    if cCurrentState = "halt" timer.stop() return ok
    char = "" + cTape[nHeadPos]
    found = 0
    for nIdx = 1 to len(aRules)
        r = aRules[nIdx]
        if r[1] = cCurrentState AND r[2] = char
            found = 1
            cmbRules.setCurrentIndex(nIdx-1)
            cCurrentState = r[3][1]
            cTape[nHeadPos] = "" + r[3][2]
            if r[3][3] = "R" nHeadPos++ elseif r[3][3] = "L" nHeadPos-- ok
            exit
        ok
    next
    # Infinite tape handling
    if nHeadPos < 1
        cTape = "0" + cTape nHeadPos = 1
    elseif nHeadPos > len(cTape)
        cTape = cTape + "0"
    ok

    if found = 0 or cCurrentState = "halt"
        cCurrentState = "halt" timer.stop()
        lblStatus.setText("<span style='color:#ff4444;'>FINISHED: HALTED</span>")
    else
        lblStatus.setText("State: " + cCurrentState + " | Position: " + nHeadPos)
    ok
    lblTape.setText(updateTapeView())

func openEditor
    winEdit = new qWidget() {
        setWindowTitle("Rule Editor")
        resize(450, 450)
        setStyleSheet("background-color: #222; color: white;")
        txtEdit = new qTextEdit(winEdit) {
            move(10, 10) resize(430, 340)
            setStyleSheet("background-color: #333; color: white; font-family: monospace; font-size: 14px;")
            cContent = ""
            for r in aRules
                cContent += r[1] + "," + r[2] + "," + r[3][1] + "," + r[3][2] + "," + r[3][3] + nl
            next
            setText(cContent)
        }
        btnSave = new qPushButton(winEdit) {
            move(10, 370) resize(430, 50) setText("SAVE & APPLY")
            setStyleSheet("background-color: #00ffcc; color: black; font-weight: bold;")
            setClickEvent("saveRules()")
        }
        winEdit.show()
    }

func saveRules
    cRaw = txtEdit.toPlainText()
    aLines = split(cRaw, nl)
    aNewRules = []
    for line in aLines
        line = trim(line)
        if line = "" loop ok
        parts = split(line, ",")
        if len(parts) < 5 loop ok
        add(aNewRules, [ parts[1], parts[2], [parts[3], parts[4], parts[5]] ])
    next
    aRules = aNewRules
    fillCombo()
    resetMachine()
    winEdit.close()

func resetMachine
    cTape = "110100" nHeadPos = 1 cCurrentState = "q0"
    timer.stop()
    lblStatus.setText("State: q0")
    lblTape.setText(updateTapeView())
