from Tkinter import Tk, Label, Button

def update_label():
    global n
    n += 1
    l["text"] = "Number of clicks: %d" % n

w = Tk()
n = 0
l = Label(w, text="There have been no clicks yet")
l.pack()
Button(w, text="click me", command=update_label).pack()
w.mainloop()
