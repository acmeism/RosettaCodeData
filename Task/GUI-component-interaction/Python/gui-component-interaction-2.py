import random, tkinter.messagebox
from tkinter import *

window = Tk()
window.geometry("330x50+100+100")
options = { "padx":5, "pady":5}
s=StringVar()
s.set(1)

def increase():
    s.set(int(s.get())+1)
def rand():
    if messagebox.askyesno("Confirmation", "Reset to random value ?"):
        s.set(random.randrange(0,5000))
def update(e):
    if not e.char.isdigit():
        messagebox.showerror('Error', 'Invalid input !')
        return "break"

e = Entry(text=s)
e.grid(column=0, row=0, **options)
e.bind('<Key>', update)

b1 = Button(text="Increase", command=increase, **options )
b1.grid(column=1, row=0, **options)
b2 = Button(text="Random", command=rand, **options)
b2.grid(column=2, row=0, **options)

mainloop()
