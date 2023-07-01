#!/usr/bin/env python3

''' Python 3.6.5 code using Tkinter graphical user interface.
    Option to set goal to powers of 2 from 128 to 2048. '''
from tkinter import *
from tkinter import messagebox
from tkinter import ttk
import random

# ************************************************

class Board:

    def __init__(self):
        self.bd = ['']* 16
        self.goal = 2048
        self.choices = '2222222224'

    # place 2 random squares on empty board:
    def place_two(self):
        idx = range(15)
        a, b = random.sample(idx, 2)
        self.bd[a] = random.choice(self.choices)
        self.bd[b] = random.choice(self.choices)

    # return text on square at index=idx of board:
    def get_text(self, idx):
        return self.bd[idx]

    # move squares on board based on arrow key entered:
    def move_squares(self, key):
        if key in ('LR'):
            # generate 4x4 2D array for row processing:
            rows = [[self.bd[0],  self.bd[1],  self.bd[2],  self.bd[3]],
                    [self.bd[4],  self.bd[5],  self.bd[6],  self.bd[7]],
                    [self.bd[8],  self.bd[9],  self.bd[10], self.bd[11]],
                    [self.bd[12], self.bd[13], self.bd[14], self.bd[15]]]
        else:
            # generate transposed 4x4 2D array instead:
            rows = [[self.bd[0],  self.bd[4],  self.bd[8],  self.bd[12]],
                    [self.bd[1],  self.bd[5],  self.bd[9],  self.bd[13]],
                    [self.bd[2],  self.bd[6],  self.bd[10], self.bd[14]],
                    [self.bd[3],  self.bd[7],  self.bd[11], self.bd[15]]]

        # build a new 4x4 array of "moved" rows:
        nrows = []
        for row in rows:
            if key in 'RD':
                # reverse these rows and slide to left:
                row = row[::-1]
            nrow = self.slide_squares(row)
            if key in 'RD':
                # restore reversed rows:
                nrow = nrow[::-1]
            nrows.append(nrow)
        if key in ('UD'):
            # transpose arrays that were transposed:
            nrows = list(map(list, zip(*nrows)))

        # flatten 4x4 2D array:
        newbd = []
        for row in nrows:
            for r in row:
                newbd.append(r)

        # place a '2' or '4' in random open square of newbd:
        if newbd != self.bd and '' in newbd:
            loi = []
            for i in range(16):
                if newbd[i] == '':
                    loi.append(i)
            i = random.choice(loi)
            newbd[i] = random.choice(self.choices)

        self.bd = newbd
        return

    # slide squares in row to the left:
    def slide_squares(self, row):
        new = ['']  * 4
        icmb = -1
        inew = 0
        for x in row:
            if x:
                if (inew > 0         and
                    x == new[inew-1] and
                    icmb != inew-1):
                    new[inew-1] = str(2*int(x))
                    icmb = inew-1
                else:
                    new[inew] = x
                    inew += 1
        return new

    # check if game won, lost, or continuing:
    def is_end(self):
        if self.goal in self.bd:
            return 'W'
        if '' in self.bd:
            return 'C'
        for i in [0, 1, 2, 4, 5, 6, 8, 9, 10, 12, 13, 14]:
            if self.bd[i] == self.bd[i+1]:
                return 'C'
        for i in range(12):
            if self.bd[i] == self.bd[i+4]:
                return 'C'
        return 'L'

# ************************************************

class Game:
    def __init__(self, gw):
        self.window = gw

        self.rosybrown1 = '#ffc1c1'
        self.lemonchiffon = '#fffacd'
        self.skyblue1 = '#87ceff'
        self.springgreen = '#00ff7f'
        self.tomato1 = '#ff6347'
        self.hotpink = '#ff69b4'
        self.brilliantlavender = '#edcaf6'
        self.cobaltgreen = '#3d9140'
        self.dodgerblue = '#1e90ff'
        self.darkgoldenrod1 = '#ffb90f'
        self.yellow = '#ffff00'
        self.imperialred = '#ed2939'
        self.navyblue = '#000080'
        self.lightgreen = '#90ee90'
        self.lightsteelblue = '#b0c4de'
        self.white = '#ffffff'
        self.palegreen4 = '#548b54'
        self.darkgreen = '#013220'
        self.black = '#000000'

        self.doc = {'':self.rosybrown1,
                    '2':self.lemonchiffon,
                    '4':self.skyblue1,
                    '8':self.springgreen,
                    '16':self.tomato1,
                    '32':self.hotpink,
                    '64':self.brilliantlavender,
                    '128':self.cobaltgreen,
                    '256':self.dodgerblue,
                    '512':self.darkgoldenrod1,
                    '1024':self.yellow,
                    '2048':self.imperialred}

        # game data:
        self.bd = None
        self.playable = False

        # top frame:
        self.top_fr = Frame(gw,
                            width=600,
                            height=100,
                            bg=self.lightgreen)
        self.top_fr.pack(fill=X)

        self.hdg = Label(self.top_fr,
                         text='  2048  ',
                         font='arial 22 bold',
                         fg=self.navyblue,
                         bg=self.white)
        self.hdg.place(relx=0.5, rely=0.4,
                       anchor=CENTER)

        self.dir = Label(self.top_fr,
                 text="(Select a 'Goal' & Click 'New Game')",
                 font='arial 12 ',
                 fg=self.navyblue,
                 bg=self.lightgreen)
        self.dir.place(relx=0.5, rely=0.8,
                       anchor=CENTER)

        self.play_btn = Button(self.top_fr,
                               text='New \nGame',
                               bd=5,
                               bg=self.palegreen4,
                               fg=self.white,
                               font='times 12 bold',
                               command=self.new_game)
        self.play_btn.place(relx=0.92, rely=0.5,
                       anchor=E)

        self.lbl_cb = Label(self.top_fr,
                            text='     Goal',
                            font='arial 12 bold ',
                            fg=self.darkgreen,
                            bg=self.lightgreen)
        self.lbl_cb.place(relx=0.08, rely=0.35,
                       anchor=W)

        goals = ['2048', '1024', '512', '256', '128']
        self.cur_goal = StringVar()
        self.goal_cb = ttk.Combobox(self.top_fr,
                                    foreground=self.darkgreen,
                                    values=goals,
                                    font='times 12 bold',
                                    justify='left',
                                    state='readonly',
                                    textvariable=self.cur_goal,
                                    width=7,
                                    height=30)
        self.goal_cb.place(relx=0.08, rely=0.6,
                       anchor=W)
        self.goal_cb.current(0)

        # bottom frame:
        self.btm_fr = Frame(gw,
                            width=600,
                            height=500,
                            bg=self.lightsteelblue)
        self.btm_fr.pack(fill=X)

        # board frame:
        self.bd_fr = Frame(self.btm_fr,
                           width=400+2,
                           height=400+2,
                           relief='solid',
                           bd=1,
                           bg=self.lemonchiffon)
        self.bd_fr.place(relx=0.5, rely=0.5,
                         anchor=CENTER)

        self.bd = Board()
        self.play_game()

# ************************************************

    # action to take if 'new game' button is clicked
    # or if 'play again' is chosen after win or loss:
    def new_game(self):
        self.playable = True
        self.bd = Board()
        self.bd.place_two()
        self.bd.goal = self.goal_cb.get()
        self.goal_cb.config(state='disabled')
        self.dir.config(text='(Use arrow keys to play game)')
        self.play_game()

    # show current contents of board:
    def play_game(self):
        objh = 100  # widget height
        objw = 100  # widget width
        objx = 0    # x-position of widget in frame
        objy = 0    # y-position of widget in frame

        i = 0
        for r in range(4):
            for c in range(4):
                txt = self.bd.get_text(i)
                bg_color = self.doc[txt]
                game_sq = Label(self.bd_fr,
                                text=txt,
                                relief='solid',
                                bd=1,
                                fg=self.black,
                                bg=bg_color,
                                font='times 16 bold')
                game_sq.place(x=objx, y=objy,
                              height=objh, width=objw)
                i += 1
                objx = objx + objw
            objx = 0
            objy = objy + objh

    # control play when an arrow key is pressed:
    def key(self, event):
        if event.keysym in ('Left', 'Right', 'Up', 'Down'):
            if self.playable:
                self.bd.move_squares(event.keysym[0])
                self.play_game()
                x = self.bd.is_end()
                if x == 'C':
                    return
                elif x == 'W':
                    msg = 'You won!!!   Play again?'
                elif x == 'L':
                    msg = 'You lost!!!   Play again?'
                ans = messagebox.askquestion(msg)
                if ans == 'no':
                    self.window.destroy()
                else:
                    self.new_game()

# ************************************************

root = Tk()
root.title('2048')
root.geometry('600x600+100+50')
root.resizable(False, False)
g = Game(root)
root.bind_all('<Key>', g.key)
root.mainloop()
