import sys
from qt import *

def update_label():
    global i
    i += 1
    lbl.setText("Number of clicks: %i" % i)

i = 0
app = QApplication(sys.argv)
win = QWidget()
win.resize(200, 100)
lbl = QLabel("There have been no clicks yet", win)
lbl.setGeometry(0, 15, 200, 25)
btn = QPushButton("click me", win)
btn.setGeometry(50, 50, 100, 25)
btn.connect(btn, SIGNAL("clicked()"), update_label)
win.show()
app.connect(app, SIGNAL("lastWindowClosed()"), app, SLOT("quit()"))
app.exec_loop()
