from PIL import Image
from PyQt5.QtGui import QImage, QPixmap
from PyQt5.QtWidgets import QApplication, QHBoxLayout, QLabel, QVBoxLayout, QWidget

IMG = "jelly-beans-usc-sipi.jpg"


def pil_to_qpixmap(img: Image):
    with img.convert("RGBA") as new_img:
        data = new_img.tobytes("raw", "RGBA")
        q_image = QImage(data, *img.size, QImage.Format_ARGB32)
        return QPixmap.fromImage(q_image)


def seperate_channels(img: str):
    with Image.open(img).convert("RGB") as img:
        r, g, b = img.split()

        r = Image.merge(
            "RGB", (r, Image.new("L", img.size, 0), Image.new("L", img.size, 0))
        )
        g = Image.merge(
            "RGB", (Image.new("L", img.size, 0), g, Image.new("L", img.size, 0))
        )
        b = Image.merge(
            "RGB", (Image.new("L", img.size, 0), Image.new("L", img.size, 0), b)
        )

        return pil_to_qpixmap(b), pil_to_qpixmap(g), pil_to_qpixmap(r)


class MainWidget(QWidget):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        vbox = QVBoxLayout()

        first_row = QHBoxLayout()
        second_row = QHBoxLayout()

        original = QLabel()
        original.setPixmap(QPixmap(IMG))

        first_row.addWidget(original)

        for channel in seperate_channels(IMG):
            label = QLabel()
            label.setPixmap(channel)
            second_row.addWidget(label)

        vbox.addLayout(first_row)
        vbox.addLayout(second_row)

        self.setLayout(vbox)
        self.setFixedSize(self.sizeHint())
        self.setWindowTitle("RGB Model")


if __name__ == "__main__":
    app = QApplication([])

    main_widget = MainWidget()
    main_widget.show()

    exit(app.exec())
