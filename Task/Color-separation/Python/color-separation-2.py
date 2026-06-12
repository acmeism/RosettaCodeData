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
    with Image.open(img).convert("CMYK") as img:
        c, m, y, _ = img.split()

        c = Image.merge(
            "CMYK",
            (
                c,
                Image.new("L", img.size, 0),
                Image.new("L", img.size, 0),
                Image.new("L", img.size, 0),
            ),
        )
        m = Image.merge(
            "CMYK",
            (
                Image.new("L", img.size, 0),
                m,
                Image.new("L", img.size, 0),
                Image.new("L", img.size, 0),
            ),
        )
        y = Image.merge(
            "CMYK",
            (
                Image.new("L", img.size, 0),
                Image.new("L", img.size, 0),
                y,
                Image.new("L", img.size, 0),
            ),
        )

        return pil_to_qpixmap(y), pil_to_qpixmap(m), pil_to_qpixmap(c)


class MainWidget(QWidget):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        vbox = QVBoxLayout()

        first_row = QHBoxLayout()
        second_row = QHBoxLayout()

        original = QLabel()
        original.setPixmap(QPixmap(IMG))

        first_row.addWidget(original)

        for img in seperate_channels(IMG):
            label = QLabel()
            label.setPixmap(img)
            second_row.addWidget(label)

        vbox.addLayout(first_row)
        vbox.addLayout(second_row)

        self.setLayout(vbox)
        self.setFixedSize(self.sizeHint())
        self.setWindowTitle("CMY Model")


if __name__ == "__main__":
    app = QApplication([])

    main_widget = MainWidget()
    main_widget.show()

    exit(app.exec())
