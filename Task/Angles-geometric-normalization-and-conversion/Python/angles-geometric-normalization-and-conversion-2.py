''' Python 3.6.5 code using Tkinter graphical user interface.
    Angles (geometric), normalization and conversion challenge.
    User enteres value for angle and selects a unit, then
    presses 'Convert' button.
    Values for that angle are shown in degrees, grads, mils
    and radians.
'''

from tkinter import *
from tkinter import messagebox
import math

class Angle:
    def __init__(self, gw):
        self.window = gw
        self.unit = StringVar()
        self.unit.set(' ')

        a1 = "(Enter 'Angle' & select 'Unit',"
        a2 = "then click 'Convert')"
        self.msga = a1 + '\n' + a2

        # dictionary of functions to execute depending
        # on which radio button was selected:
        self.d_to_deg = {'d':self.d2d,
                         'g':self.g2d,
                         'm':self.m2d,
                         'r':self.r2d}

        # top frame:
        self.top_fr = Frame(gw,
                            width=600,
                            height=100,
                            bg='dodger blue')
        self.top_fr.pack(fill=X)

        self.hdg = Label(self.top_fr,
                         text='  Angle Conversion  ',
                         font='arial 22 bold',
                         fg='navy',
                         bg='lemon chiffon')
        self.hdg.place(relx=0.5, rely=0.5,
                       anchor=CENTER)

        self.close_btn = Button(self.top_fr,
                                text='Quit',
                                bd=5,
                                bg='navy',
                                fg='lemon chiffon',
                                font='arial 12 bold',
                                command=self.close_window)
        self.close_btn.place(relx=0.07, rely=0.5,
                             anchor=W)

        self.clear_btn = Button(self.top_fr,
                                text='Clear',
                                bd=5,
                                bg='navy',
                                fg='lemon chiffon',
                                font='arial 12 bold',
                                command=self.clear_screen)
        self.clear_btn.place(relx=0.92, rely=0.5,
                             anchor=E)

        # bottom frame:
        self.btm_fr = Frame(gw,
                            width=600,
                            height=500,
                            bg='lemon chiffon')
        self.btm_fr.pack(fill=X)

        self.msg = Label(self.btm_fr,
                         text=self.msga,
                         font='arial 16 bold',
                         fg='navy',
                         bg='lemon chiffon')
        self.msg.place(relx=0.5, rely=0.1,
                       anchor=CENTER)

        self.nbr_fr = LabelFrame(self.btm_fr,
                                 text='     Angle   ',
                                 bg='dodger blue',
                                 fg='navy',
                                 bd=4,
                                 relief=RIDGE,
                                 font='arial 12 bold')
        self.nbr_fr.place(relx=0.17, rely=0.27,
                          anchor=CENTER)

        self.nbr_ent = Entry(self.nbr_fr,
                             justify='center',
                             font='arial 12 bold',
                             fg='navy',
                             bg='lemon chiffon',
                             bd=4,
                             width=10)
        self.nbr_ent.grid(row=0, column=0,
                          padx=(8,8),
                          pady=(8,8))

        self.su_fr = LabelFrame(self.btm_fr,
                                text='  Select Unit  ',
                                bg='dodger blue',
                                fg='navy',
                                bd=8,
                                relief=RIDGE,
                                font='arial 12 bold')
        self.su_fr.place(relx=0.48, rely=0.35,
                         anchor=CENTER)

        self.radiod = Radiobutton(self.su_fr,
                                  text='degree',
                                  font='arial 12 bold',
                                  fg='navy',
                                  bg='dodger blue',
                                  variable=self.unit,
                                  value='d')
        self.radiod.pack(side='top', anchor='w')

        self.radiog = Radiobutton(self.su_fr,
                                  text='gradian',
                                  font='arial 12 bold',
                                  fg='navy',
                                  bg='dodger blue',
                                  variable=self.unit,
                                  value='g')
        self.radiog.pack(side='top', anchor='w')

        self.radiom = Radiobutton(self.su_fr,
                                  text='mil',
                                  font='arial 12 bold',
                                  fg='navy',
                                  bg='dodger blue',
                                  variable=self.unit,
                                  value='m')
        self.radiom.pack(side='top', anchor='w')

        self.radior = Radiobutton(self.su_fr,
                                  text='radian',
                                  font='arial 12 bold',
                                  fg='navy',
                                  bg='dodger blue',
                                  variable=self.unit,
                                  value='r')
        self.radior.pack(side='top', anchor='w')

        self.convert_btn = Button(self.btm_fr,
                                  text='Convert',
                                  width=14,
                                  bd=5,
                                  bg='dodger blue',
                                  fg='navy',
                                  font='arial 12 bold',
                                  command=self.convert)
        self.convert_btn.place(relx=0.93, rely=.25,
                               anchor=E)

        self.res_fr = LabelFrame(self.btm_fr,
                                 text='   Results  ',
                                 bg='dodger blue',
                                 fg='navy',
                                 bd=8,
                                 width=230,
                                 height=130,
                                 relief=RIDGE,
                                 font='arial 12 bold')
        self.res_fr.place(relx=0.48, rely=0.74,
                          anchor=CENTER)

        objh = 20   # widget height
        lblw = 80   # label width
        valw = 100  # value width
        lblx = 15   # x-position of label in frame
        valx = 100  # x-position of value in frame
        objy = 5    # y-position of widget in frame

        self.deg_lbl = Label(self.res_fr,
                             text=' degrees: ',
                             anchor=E,
                             font='"Noto Mono" 12 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.deg_lbl.place(x=lblx, y=objy,
                           height=objh, width=lblw)

        self.deg_val = Label(self.res_fr,
                             text=' ',
                             anchor=E,
                             padx = 3,
                             font='"Noto Mono" 12 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.deg_val.place(x=valx, y=objy,
                           height=objh, width=valw)

        objy = objy + objh   # next row
        self.grd_lbl = Label(self.res_fr,
                             text='   grads: ',
                             anchor=E,
                             font='"Noto Mono" 12 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.grd_lbl.place(x=lblx, y=objy,
                           height=objh, width=lblw)


        self.grd_val = Label(self.res_fr,
                             text=' ',
                             anchor=E,
                             padx = 3,
                             font='"Noto Mono" 12 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.grd_val.place(x=valx, y=objy,
                           height=objh, width=valw)

        objy = objy + objh   # next row
        self.mil_lbl = Label(self.res_fr,
                             text='    mils: ',
                             anchor=E,
                             font='"Noto Mono" 12 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.mil_lbl.place(x=lblx, y=objy,
                           height=objh, width=lblw)

        self.mil_val = Label(self.res_fr,
                             text=' ',
                             anchor=E,
                             padx = 3,
                             font='"Noto Mono" 12 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.mil_val.place(x=valx, y=objy,
                           height=objh, width=valw)

        objy = objy + objh   # next row
        self.rad_lbl = Label(self.res_fr,
                             text='radians: ',
                             anchor=E,
                             font='"Noto Mono" 12 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.rad_lbl.place(x=lblx, y=objy,
                           height=objh, width=lblw)

        self.rad_val = Label(self.res_fr,
                             text=' ',
                             anchor=E,
                             padx = 3,
                             font='"Noto Mono" 12 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.rad_val.place(x=valx, y=objy,
                           height=objh, width=valw)

    # process conversion request:
    def convert(self):
        # edit requested angle and unit:
        try:
            a = float(self.nbr_ent.get())
        except:
            self.err_msg('Angle entry must be numeric')
            return
        u = self.unit.get()
        if u not in self.d_to_deg:
            self.err_msg('Unit must be selected')
            return

        # convert request to degrees:
        deg = self.d_to_deg[u](a)

        # normalize:
        self.deg = self.normalize(deg)

        # convert to grads, mils, radians
        self.grad = self.d2g(self.deg)
        self.mil = self.d2m(self.deg)
        self.rad = self.d2r(self.deg)

        # show results
        self.deg_val.config(text=self.format_angle(self.deg))
        self.grd_val.config(text=self.format_angle(self.grad))
        self.mil_val.config(text=self.format_angle(self.mil))
        self.rad_val.config(text=self.format_angle(self.rad))
        return

    def d2d(self, a):
        return a

    def g2d(self, a):
        return .9 * a

    def r2d(self, a):
        return 180 * a / math.pi

    def m2d(self, a):
        return .05625 * a

    def normalize(self, a):
        if a >= 0:
            x = a % 360
        else:
            x = -(-a % 360)
        if x == -0.0:
            x = 0.0
        return x

    def d2g(self, a):
        return 10 * a / 9

    def d2m(self, a):
        return 160 * a / 9

    def d2r(self, a):
        return math.pi * a / 180

    def format_angle(self, a):
        return f'{a:.4f}'

    def err_msg(self, msg):
        messagebox.showerror('Error Message', msg)
        return

    # restore screen to it's 'initial' state:
    def clear_screen(self):
        self.nbr_ent.delete(0, 'end')
        self.unit.set(' ')
        self.deg_val.config(text='')
        self.grd_val.config(text='')
        self.mil_val.config(text='')
        self.rad_val.config(text='')
        return

    def close_window(self):
        self.window.destroy()

# ************************************************

root = Tk()
root.title('ANGLES')
root.geometry('600x600+100+50')
root.resizable(False, False)
a = Angle(root)
root.mainloop()

# ************************************************

##  I wish I could show a screenshot of the tkinter window
##  to show how the input and output appear, but I don't know
##  if that is possible here.
##  I have processed all of the suggested angles and the
##  results matched those from a few other languages on this
##  page.
