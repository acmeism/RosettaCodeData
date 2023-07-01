''' Python 3.6.5 code using Tkinter graphical user interface.
    Starting player chosen randomly. '''
from tkinter import *
from tkinter import messagebox
import random

# ************************************************

class Game:
    def __init__(self, gw):
        self.window = gw
        self.won = 0
        self.lost = 0
        self.score = 0
        self.puter_turn = None
        self.var123 = IntVar()
        self.varsub = IntVar()

        # top frame:
        self.top_fr = Frame(gw,
                            width=600,
                            height=100,
                            bg='dodger blue')
        self.top_fr.pack(fill=X)

        self.hdg = Label(self.top_fr,
                         text='  21 Game  ',
                         font='arial 22 bold',
                         fg='navy',
                         bg='lemon chiffon')
        self.hdg.place(relx=0.5, rely=0.5,
                       anchor=CENTER)

        self.play_btn = Button(self.top_fr,
                               text='Play\nGame',
                               bd=5,
                               bg='navy',
                               fg='lemon chiffon',
                               font='arial 12 bold',
                               command=self.play_game)
        self.play_btn.place(relx=0.92, rely=0.5,
                            anchor=E)

        self.quit_btn = Button(self.top_fr,
                               text='Quit\nGame',
                               bd=5,
                               bg='navy',
                               fg='lemon chiffon',
                               font='arial 12 bold',
                               command=self.quit_game)
        self.quit_btn.place(relx=0.07, rely=0.5,
                            anchor=W)

        # bottom frame:
        self.btm_fr = Frame(gw,
                            width=600,
                            height=500,
                            bg='lemon chiffon')
        self.btm_fr.pack(fill=X)

        self.msg = Label(self.btm_fr,
                         text="(Click 'Play' or 'Quit')",
                         font='arial 16 bold',
                         fg='navy',
                         bg='lemon chiffon')
        self.msg.place(relx=0.5, rely=0.1,
                       anchor=CENTER)

        self.hdg = Label(self.btm_fr,
                         text="Scoreboard",
                         font='arial 16 bold',
                         fg='navy',
                         bg='lemon chiffon')
        self.hdg.place(relx=0.5, rely=0.2,
                       anchor=CENTER)

        self.score_msg = Label(self.btm_fr,
                               text="0",
                               font='arial 16 bold',
                               fg='navy',
                               bg='dodger blue',
                               width=8)

        self.score_msg.place(relx=0.5, rely=0.27,
                             anchor=CENTER)

        self.ch_fr = LabelFrame(self.btm_fr,
                                text='Choose a number',
                                bg='dodger blue',
                                fg='navy',
                                bd=8,
                                relief=RIDGE,
                                font='arial 16 bold')
        self.ch_fr.place(relx=0.5, rely=0.5,
                         anchor=CENTER)

        self.radio1 = Radiobutton(self.ch_fr,
                                  text='1',
                                  state='disabled',
                                  font='arial 16 bold',
                                  fg='navy',
                                  bg='dodger blue',
                                  variable=self.var123,
                                  value=1)
        self.radio1.pack()

        self.radio2 = Radiobutton(self.ch_fr,
                                  text='2',
                                  state='disabled',
                                  font='arial 16 bold',
                                  fg='navy',
                                  bg='dodger blue',
                                  variable=self.var123,
                                  value=2)
        self.radio2.pack()

        self.radio3 = Radiobutton(self.ch_fr,
                                  text='3',
                                  state='disabled',
                                  font='arial 16 bold ',
                                  fg='navy',
                                  bg='dodger blue',
                                  variable=self.var123,
                                  value=3)
        self.radio3.pack()

        self.submit_btn = Button(self.btm_fr,
                                 text='SUBMIT',
                                 state='disabled',
                                 bd=5,
                                 bg='navy',
                                 fg='lemon chiffon',
                                 font='arial 12 bold',
                                 command=self.submit)
        self.submit_btn.place(relx=0.5, rely=0.75,
                              anchor=CENTER)

        self.won_lbl = Label(self.btm_fr,
                             text="Won: 0",
                             font='arial 16 bold',
                             fg='navy',
                             bg='lemon chiffon')
        self.won_lbl.place(relx=0.85, rely=0.88,
                           anchor=W)

        self.lost_lbl = Label(self.btm_fr,
                              text="Lost: 0",
                              font='arial 16 bold',
                              fg='navy',
                              bg='lemon chiffon')
        self.lost_lbl.place(relx=0.85, rely=0.93,
                            anchor=W)

    # play one game:
    def play_game(self):
        self.play_btn.config(state='disabled')
        # pick who goes first randomly:
        self.puter_turn = random.choice([True, False])
        self.score = 0
        self.score_msg.config(text=self.score)
        if not self.puter_turn:
            m = 'your turn'
            self.msg.config(text=m)
        # alternate turns until 21 is reached:
        while self.score != 21:
            if self.puter_turn:
                self.puter_plays()
            else:
                self.user_plays()
            self.puter_turn = not self.puter_turn
        self.play_btn.config(state='normal')
        return

    # computer picks a number:
    def puter_plays(self):
        if self.score == 20:
            x = 1
        elif self.score == 19:
                x = random.choice([1, 2])
        else:
            x = random.choice([1, 2, 3])
        self.score += x
        self.score_msg.config(text=self.score)
        if self.score == 21:
            m = 'Computer won!'
            self.lost += 1
            self.lost_lbl.config(text='Lost: ' + str(self.lost))
        else:
            m = 'Computer chose ' + str(x) + ', your turn'
        self.msg.config(text=m)
        return

    # user picks a number:
    def user_plays(self):
        self.set_user_state('normal')
        while True:
            # wait for submit button to be pressed:
            self.submit_btn.wait_variable(self.varsub)
            x = self.var123.get()
            if x + self.score > 21:
                m = 'Score cannot exceed 21, try again'
                messagebox.showerror('Error', m)
            elif x not in (1,2,3):
                m = 'No selection made'
                messagebox.showerror('Error', m)
            else:
                break
        self.score += x
        if self.score == 21:
            m = 'You won!'
            self.msg.config(text=m)
            self.score_msg.config(text=self.score)
            self.won += 1
            self.won_lbl.config(text='Won: ' + str(self.won))
        # reset and disable radio buttons:
        self.var123.set(0)
        self.set_user_state('disabled')
        return

    # set radio buttons to 'disabled' or 'normal':
    def set_user_state(self, state):
        self.radio1.config(state=state)
        self.radio2.config(state=state)
        self.radio3.config(state=state)
        self.submit_btn.config(state=state)
        return


    def quit_game(self):
        self.window.destroy()

    # indicate that submit button was pressed:
    def submit(self):
        self.varsub.set(0)

# ************************************************

root = Tk()
root.title('21 Game')
root.geometry('600x600+100+50')
root.resizable(False, False)
g = Game(root)
root.mainloop()
