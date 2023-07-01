from Xlib import X, display

class Window:
    def __init__(self, display, msg):
        self.display = display
        self.msg = msg

        self.screen = self.display.screen()
        self.window = self.screen.root.create_window(
            10, 10, 100, 100, 1,
            self.screen.root_depth,
            background_pixel=self.screen.white_pixel,
            event_mask=X.ExposureMask | X.KeyPressMask,
            )
        self.gc = self.window.create_gc(
            foreground = self.screen.black_pixel,
            background = self.screen.white_pixel,
            )

        self.window.map()

    def loop(self):
        while True:
            e = self.display.next_event()

            if e.type == X.Expose:
                self.window.fill_rectangle(self.gc, 20, 20, 10, 10)
                self.window.draw_text(self.gc, 10, 50, self.msg)
            elif e.type == X.KeyPress:
                raise SystemExit


if __name__ == "__main__":
    Window(display.Display(), "Hello, World!").loop()
