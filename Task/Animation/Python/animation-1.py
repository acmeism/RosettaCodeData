#!/usr/bin/env python3
import sys

from PyQt5.QtCore import QBasicTimer, Qt
from PyQt5.QtGui import QFont
from PyQt5.QtWidgets import QApplication, QLabel


class Marquee(QLabel):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.right_to_left_direction = True
        self.initUI()
        self.timer = QBasicTimer()
        self.timer.start(80, self)

    def initUI(self):
        self.setWindowFlags(Qt.FramelessWindowHint)
        self.setAttribute(Qt.WA_TranslucentBackground)
        self.setText("Hello World! ")
        self.setFont(QFont(None, 50, QFont.Bold))
        # make more irritating for the authenticity with <marquee> element
        self.setStyleSheet("QLabel {color: cyan; }")

    def timerEvent(self, event):
        i = 1 if self.right_to_left_direction else -1
        self.setText(self.text()[i:] + self.text()[:i])  # rotate

    def mouseReleaseEvent(self, event):  # change direction on mouse release
        self.right_to_left_direction = not self.right_to_left_direction

    def keyPressEvent(self, event):  # exit on Esc
        if event.key() == Qt.Key_Escape:
            self.close()


app = QApplication(sys.argv)
w = Marquee()
# center widget on the screen
w.adjustSize()  # update w.rect() now
w.move(QApplication.instance().desktop().screen().rect().center()
       - w.rect().center())
w.show()
sys.exit(app.exec())
