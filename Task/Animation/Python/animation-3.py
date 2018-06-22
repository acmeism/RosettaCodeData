import Tkinter as tki

def scroll_text(s, how_many):
    return s[how_many:] + s[:how_many]

direction = 1
tk = tki.Tk()
var = tki.Variable(tk)

def mouse_handler(point):
    global direction
    direction *= -1

def timer_handler():
    var.set(scroll_text(var.get(),direction))
    tk.after(125, timer_handler)

var.set('Hello, World! ')
tki.Label(tk, textvariable=var).pack()
tk.bind("<Button-1>", mouse_handler)
tk.after(125, timer_handler)
tk.title('Python Animation')
tki.mainloop()
