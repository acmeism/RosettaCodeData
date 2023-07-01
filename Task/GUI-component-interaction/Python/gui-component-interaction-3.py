import random
from Tkinter import *
import tkMessageBox

class Application(Frame):
    def __init__(self, master):
        Frame.__init__(self, master)
        self.counter = 0
        self.contents = StringVar()
        self.contents.set(str(self.counter))
        self.pack(expand=True, fill='both', padx=10, pady=15)
        self.create_widgets()

    def increment(self, *args):
        self.counter += 1
        self.update_entry()

    def random(self):
        if tkMessageBox.askyesno("Confirmation", "Reset to random value ?"):
            self.counter = random.randint(0, 5000)
            self.update_entry()

    def entry_updated(self, event, *args):
        if not event.char:
            return 'break'
        if not event.char.isdigit():
            tkMessageBox.showerror('Error', 'Invalid input !')
            return 'break'
        self.counter = int('%s%s' % (self.contents.get(), event.char))

    def update_entry(self):
        self.contents.set(str(self.counter))
        self.entry['textvariable'] = self.contents

    def create_widgets(self):
        options = {'expand': True, 'fill': 'x', 'side': 'left', 'padx': 5}
        self.entry = Entry(self)
        self.entry.bind('<Key>', self.entry_updated)
        self.entry.pack(**options)
        self.update_entry()
        self.increment_button = Button(self, text='Increment', command=self.increment)
        self.increment_button.pack(**options)
        self.random_button = Button(self, text='Random', command=self.random)
        self.random_button.pack(**options)

if __name__ == '__main__':
    root = Tk()
    try:
        app = Application(master=root)
        app.master.title("Rosetta code")
        app.mainloop()
    except KeyboardInterrupt:
        root.destroy()
