import tkinter as tk


class ClickCounter(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        tk.Pack.config(self)
        self.label = tk.Label(self, text='There have been no clicks yet')
        self.label.pack()
        self.button = tk.Button(self,
                                text='click me',
                                command=self.click)
        self.button.pack()
        self.count = 0

    def click(self):
        self.count += 1
        self.label['text'] = f'Number of clicks: {self.count}'


if __name__ == "__main__":
    ClickCounter().mainloop()
