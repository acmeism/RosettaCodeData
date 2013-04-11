import Tkinter as tk

def showxy(event):
    xm, ym = event.x, event.y
    str1 = "mouse at x=%d  y=%d" % (xm, ym)
    # show cordinates in title
    root.title(str1)
    # switch color to red if mouse enters a set location range
    x,y, delta = 100, 100, 10
    frame.config(bg='red'
                 if abs(xm - x) < delta and abs(ym - y) < delta
                 else 'yellow')

root = tk.Tk()
frame = tk.Frame(root, bg= 'yellow', width=300, height=200)
frame.bind("<Motion>", showxy)
frame.pack()

root.mainloop()
