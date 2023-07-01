from functools import partial
from itertools import count

from PyQt5.QtWidgets import (QApplication,
                             QLabel,
                             QPushButton,
                             QWidget)
from PyQt5.QtCore import QRect

LABEL_GEOMETRY = QRect(0, 15, 200, 25)
BUTTON_GEOMETRY = QRect(50, 50, 100, 25)


def on_click(_, label, counter=count(1)):
    label.setText(f"Number of clicks: {next(counter)}")


def main():
    application = QApplication([])
    window = QWidget()
    label = QLabel(text="There have been no clicks yet",
                   parent=window)
    label.setGeometry(LABEL_GEOMETRY)
    button = QPushButton(text="click me",
                         parent=window)
    button.setGeometry(BUTTON_GEOMETRY)
    update_counter = partial(on_click,
                             label=label)
    button.clicked.connect(update_counter)
    window.show()
    application.lastWindowClosed.connect(window.close)
    application.exec_()


if __name__ == '__main__':
    main()
