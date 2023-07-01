''' Python 3.6.5 code using Tkinter graphical user interface.
    Combination of '24 game' and '24 game/Solve'
    allowing user or random selection of 4-digit number
    and user or computer solution.
    Note that all computer solutions are displayed'''

from tkinter import *
from tkinter import messagebox
from tkinter.scrolledtext import ScrolledText
# 'from tkinter import scrolledtext' in later versions?
import random
import itertools

# ************************************************

class Game:
    def __init__(self, gw):
        self.window = gw
        self.digits = '0000'

        a1 = "(Enter '4 Digits' & click 'My Digits'"
        a2 = "or click 'Random Digits')"
        self.msga = a1 + '\n' + a2

        b1 = "(Enter 'Solution' & click 'Check Solution'"
        b2 = "or click 'Show Solutions')"
        self.msgb = b1 + '\n' + b2

        # top frame:
        self.top_fr = Frame(gw,
                            width=600,
                            height=100,
                            bg='dodger blue')
        self.top_fr.pack(fill=X)

        self.hdg = Label(self.top_fr,
                         text='  24 Game  ',
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

        self.user_dgt_btn = Button(self.btm_fr,
                                   text='My Digits',
                                   width=12,
                                   bd=5,
                                   bg='navy',
                                   fg='lemon chiffon',
                                   font='arial 12 bold',
                                   command=self.get_digits)
        self.user_dgt_btn.place(relx=0.07, rely=0.2,
                                anchor=W)

        self.rdm_dgt_btn = Button(self.btm_fr,
                                  text='Random Digits',
                                  width=12,
                                  bd=5,
                                  bg='navy',
                                  fg='lemon chiffon',
                                  font='arial 12 bold',
                                  command=self.gen_digits)
        self.rdm_dgt_btn.place(relx=0.92, rely=0.2,
                               anchor=E)

        self.dgt_fr = LabelFrame(self.btm_fr,
                                 text='   4 Digits  ',
                                 bg='dodger blue',
                                 fg='navy',
                                 bd=4,
                                 relief=RIDGE,
                                 font='arial 12 bold')
        self.dgt_fr.place(relx=0.5, rely=0.27,
                          anchor=CENTER)

        self.digit_ent = Entry(self.dgt_fr,
                               justify='center',
                               font='arial 16 bold',
                               fg='navy',
                               disabledforeground='navy',
                               bg='lemon chiffon',
                               disabledbackground='lemon chiffon',
                               bd=4,
                               width=6)
        self.digit_ent.grid(row=0, column=0,
                            padx=(8,8),
                            pady=(8,8))

        self.chk_soln_btn = Button(self.btm_fr,
                                   text='Check Solution',
                                   state='disabled',
                                   width=14,
                                   bd=5,
                                   bg='navy',
                                   fg='lemon chiffon',
                                   font='arial 12 bold',
                                   command=self.check_soln)
        self.chk_soln_btn.place(relx=0.07, rely=.42,
                                anchor=W)

        self.show_soln_btn = Button(self.btm_fr,
                                    text='Show Solutions',
                                    state='disabled',
                                    width=14,
                                    bd=5,
                                    bg='navy',
                                    fg='lemon chiffon',
                                    font='arial 12 bold',
                                    command=self.show_soln)
        self.show_soln_btn.place(relx=0.92, rely=.42,
                                 anchor=E)

        self.soln_fr = LabelFrame(self.btm_fr,
                                  text='  Solution  ',
                                  bg='dodger blue',
                                  fg='navy',
                                  bd=4,
                                  relief=RIDGE,
                                  font='arial 12 bold')
        self.soln_fr.place(relx=0.07, rely=0.58,
                           anchor=W)

        self.soln_ent = Entry(self.soln_fr,
                              justify='center',
                              font='arial 16 bold',
                              fg='navy',
                              disabledforeground='navy',
                              bg='lemon chiffon',
                              disabledbackground='lemon chiffon',
                              state='disabled',
                              bd=4,
                              width=15)
        self.soln_ent.grid(row=0, column=0,
                           padx=(8,8), pady=(8,8))

        self.solns_fr = LabelFrame(self.btm_fr,
                                   text='  Solutions  ',
                                   bg='dodger blue',
                                   fg='navy',
                                   bd=4,
                                   relief=RIDGE,
                                   font='arial 12 bold')
        self.solns_fr.place(relx=0.92, rely=0.5,
                            anchor='ne')

        self.solns_all = ScrolledText(self.solns_fr,
                                      font='courier 14 bold',
                                      state='disabled',
                                      fg='navy',
                                      bg='lemon chiffon',
                                      height=8,
                                      width=14)
        self.solns_all.grid(row=0, column=0,
                            padx=(8,8), pady=(8,8))

    # validate '4 Digits' entry.
    # save if valid and switch screen to solution mode.
    def get_digits(self):
        txt = self.digit_ent.get()
        if not(len(txt) == 4 and txt.isdigit()):
            self.err_msg('Please enter 4 digits (eg 1357)')
            return
        self.digits = txt       # save
        self.reset_one()        # to solution mode
        return

    # generate 4 random digits, display them,
    # save them, and switch screen to solution mode.
    def gen_digits(self):
        self.digit_ent.delete(0, 'end')
        self.digits = ''.join([random.choice('123456789')
                       for i in range(4)])
        self.digit_ent.insert(0, self.digits)   # display
        self.reset_one()        # to solution mode
        return

    # switch screen from get digits to solution mode:
    def reset_one(self):
        self.digit_ent.config(state='disabled')
        self.user_dgt_btn.config(state='disabled')
        self.rdm_dgt_btn.config(state='disabled')
        self.msg.config(text=self.msgb)
        self.chk_soln_btn.config(state='normal')
        self.show_soln_btn.config(state='normal')
        self.soln_ent.config(state='normal')
        return

    # edit user's solution:
    def check_soln(self):
        txt = self.soln_ent.get()   # user's expression
        d = ''                      # save digits in expression
        dgt_op = 'd'                # expecting d:digit or o:operation
        for t in txt:
            if t not in '123456789+-*/() ':
                self.err_msg('Invalid character found: ' + t)
                return
            if t.isdigit():
                if dgt_op == 'd':
                    d += t
                    dgt_op = 'o'
                else:
                    self.err_msg('Need operator between digits')
                    return
            if t in '+-*/':
                if dgt_op == 'o':
                    dgt_op = 'd'
                else:
                    self.err_msg('Need digit befor operator')
                    return
        if sorted(d) != sorted(self.digits):
            self.err_msg("Use each digit in '4 Digits' once")
            return
        try:
            # round covers up Python's
            # representation of floats
            if round(eval(txt),5) == 24:
                messagebox.showinfo(
                    'Success',
                    'YOUR SOLUTION IS VADLID!')
                self.show_soln()        # show all solutions
                return
        except:
            self.err_msg('Invalid arithmetic expression')
            return
        messagebox.showinfo(
            'Failure',
            'Your expression does not yield 24')
        return

    # show all solutions:
    def show_soln(self):
        # get all sets of 3 operands: ('+', '+', '*'), ...)
        ops = ['+-*/', '+-*/', '+-*/']
        combs = [p for p in itertools.product(*ops)]

        # get unique permutations for requested 4 digits:
        d = self.digits
        perms = set([''.join(p) for p in itertools.permutations(d)])

        # list of all (hopefully) expressions for
        # 4 operands and 3 operations:
        formats = ['Aop1Bop2Cop3D',
                   '(Aop1Bop2C)op3D',
                   '((Aop1B)op2C)op3D',
                   '(Aop1(Bop2C))op3D',
                   'Aop1Bop2(Cop3D)',
                   'Aop1(Bop2C)op3D',
                   '(Aop1B)op2Cop3D',
                   '(Aop1B)op2(Cop3D)',
                   'Aop1(Bop2Cop3D)',
                   'Aop1((Bop2C)op3D)',
                   'Aop1(Bop2(Cop3D))']

        lox = []            # list of valid expressions

        for fm in formats:                      # pick a format
            for c in combs:                     # plug in 3 ops
                f = fm.replace('op1', c[0])
                f = f.replace('op2', c[1])
                f = f.replace('op3', c[2])
                for A, B, C, D in perms:        # plug in 4 digits
                    x = f.replace('A', A)
                    x = x.replace('B', B)
                    x = x.replace('C', C)
                    x = x.replace('D', D)
                    try:                        # evaluate expression
                        # round covers up Python's
                        # representation of floats
                        if round(eval(x),5) == 24:
                            lox.append(' ' + x)
                    except ZeroDivisionError:   # can ignore these
                        continue
        if lox:
            txt = '\n'.join(x for x in lox)
        else:
            txt =' No Solution'
        self.solns_all.config(state='normal')
        self.solns_all.insert('end', txt)       # show solutions
        self.solns_all.config(state='disabled')

        self.chk_soln_btn.config(state='disabled')
        self.show_soln_btn.config(state='disabled')
        self.soln_ent.config(state='disabled')
        return

    def err_msg(self, msg):
        messagebox.showerror('Error Message', msg)
        return

    # restore screen to it's 'initial' state:
    def clear_screen(self):
        self.digits = ''
        self.digit_ent.config(state='normal')
        self.user_dgt_btn.config(state='normal')
        self.rdm_dgt_btn.config(state='normal')
        self.digit_ent.delete(0, 'end')
        self.chk_soln_btn.config(state='disabled')
        self.show_soln_btn.config(state='disabled')
        self.soln_ent.config(state='normal')
        self.soln_ent.delete(0, 'end')
        self.soln_ent.config(state='disabled')
        self.msg.config(text=self.msga)
        self.clear_solns_all()
        return

    # clear the 'Solutions' frame.
    # note: state must be 'normal' to change data
    def clear_solns_all(self):
        self.solns_all.config(state='normal')
        self.solns_all.delete(1.0, 'end')
        self.solns_all.config(state='disabled')
        return

    def close_window(self):
        self.window.destroy()

# ************************************************

root = Tk()
root.title('24 Game')
root.geometry('600x600+100+50')
root.resizable(False, False)
g = Game(root)
root.mainloop()
