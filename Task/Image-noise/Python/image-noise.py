import time
import random
import tkinter
from PIL import Image
from PIL import ImageTk


class App:
    def __init__(self, size, root):
        self.root = root
        self.root.title("Image Noise Test")

        self.img = Image.new("1", size)
        self.label = tkinter.Label(root)
        self.label.pack()

        self.time = 0.0
        self.frames = 0
        self.size = size
        self.n_pixels = self.size[0] * self.size[1]

        self.loop()

    def loop(self):
        start_time = time.time()

        self.img.putdata(
            [255 if b > 127 else 0 for b in random.randbytes(self.n_pixels)]
        )

        self.bitmap_image = ImageTk.BitmapImage(self.img)
        self.label["image"] = self.bitmap_image

        end_time = time.time()
        self.time += end_time - start_time
        self.frames += 1

        if self.frames == 30:
            try:
                fps = self.frames / self.time
            except ZeroDivisionError:
                fps = "INSTANT"

            print(f"{self.frames} frames in {self.time:3.2f} seconds ({fps} FPS)")
            self.time = 0
            self.frames = 0

        self.root.after(1, self.loop)


def main():
    root = tkinter.Tk()
    app = App((320, 240), root)
    root.mainloop()


if __name__ == "__main__":
    main()
