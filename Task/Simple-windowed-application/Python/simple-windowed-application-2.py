#!/usr/bin/env python
from Tkinter import Button, Frame, Label, Pack

class ClickCounter(Frame):
    def click(self):
        self.count += 1
        self.label['text'] = 'Number of clicks: %d' % self.count

    def createWidgets(self):
        self.label = Label(self, text='here have been no clicks yet')
        self.label.pack()
        self.button = Button(self, text='click me', command=self.click)
        self.button.pack()

    def __init__(self, master=None):
        Frame.__init__(self, master)
        Pack.config(self)
        self.createWidgets()
        self.count = 0

if __name__=="__main__":
    ClickCounter().mainloop()
