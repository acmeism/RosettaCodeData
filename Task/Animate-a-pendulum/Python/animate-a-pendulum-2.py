''' Python 3.6.5 code using Tkinter graphical user interface.'''

from tkinter import *
import math

class Animation:
    def __init__(self, gw):
        self.window = gw
        self.xoff, self.yoff = 300, 100
        self.angle = 0
        self.sina = math.sin(self.angle)
        self.cosa = math.cos(self.angle)
        self.rodhyp = 170
        self.bobr = 30
        self.bobhyp = self.rodhyp + self.bobr
        self.rodx0, self.rody0 = self.xoff, self.yoff
        self.ra = self.rodx0
        self.rb = self.rody0
        self.rc = self.xoff + self.rodhyp*self.sina
        self.rd = self.yoff + self.rodhyp*self.cosa
        self.ba = self.xoff - self.bobr + self.bobhyp*self.sina
        self.bb = self.yoff - self.bobr + self.bobhyp*self.cosa
        self.bc = self.xoff + self.bobr + self.bobhyp*self.sina
        self.bd = self.yoff + self.bobr + self.bobhyp*self.cosa
        self.da = math.pi / 360

        # create / fill canvas:
        self.cnv = Canvas(gw, bg='lemon chiffon')
        self.cnv.pack(fill=BOTH, expand=True)

        self.cnv.create_line(0, 100, 600, 100,
                             fill='dodger blue',
                             width=3)
        radius = 8
        self.cnv.create_oval(300-radius, 100-radius,
                             300+radius, 100+radius,
                             fill='navy')

        self.bob = self.cnv.create_oval(self.ba,
                                        self.bb,
                                        self.bc,
                                        self.bd,
                                        fill='red',
                                        width=2)

        self.rod = self.cnv.create_line(self.ra,
                                        self.rb,
                                        self.rc,
                                        self.rd,
                                        fill='dodger blue',
                                        width=6)

        self.animate()

    def animate(self):
        if abs(self.angle) > math.pi / 2:
            self.da = - self.da
        self.angle += self.da
        self.sina = math.sin(self.angle)
        self.cosa = math.cos(self.angle)
        self.ra = self.rodx0
        self.rb = self.rody0
        self.rc = self.xoff + self.rodhyp*self.sina
        self.rd = self.yoff + self.rodhyp*self.cosa
        self.ba = self.xoff - self.bobr + self.bobhyp*self.sina
        self.bb = self.yoff - self.bobr + self.bobhyp*self.cosa
        self.bc = self.xoff + self.bobr + self.bobhyp*self.sina
        self.bd = self.yoff + self.bobr + self.bobhyp*self.cosa

        self.cnv.coords(self.rod,
                        self.ra,
                        self.rb,
                        self.rc,
                        self.rd)
        self.cnv.coords(self.bob,
                        self.ba,
                        self.bb,
                        self.bc,
                        self.bd)
        self.window.update()
        self.cnv.after(5, self.animate)

root = Tk()
root.title('Pendulum')
root.geometry('600x400+100+50')
root.resizable(False, False)
a = Animation(root)
root.mainloop()
