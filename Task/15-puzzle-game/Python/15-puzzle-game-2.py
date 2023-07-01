''' Python 3.6.5 code using Tkinter graphical user interface.'''

from tkinter import *
from tkinter import messagebox
import random

# ************************************************

class Board:
    def __init__(self, playable=True):
        while True:
            # list of text for game squares:
            self.lot = [str(i) for i in range(1,16)] + ['']
            if not playable:
                break
            # list of text for game squares randomized:
            random.shuffle(self.lot)
            if self.is_solvable():
                break

        # game board is 2D array of game squares:
        self.bd = []
        i = 0
        for r in range(4):
            row = []
            for c in range(4):
                row.append(Square(r,c,self.lot[i]))
                i += 1
            self.bd.append(row)

    # How to check if an instance of a 15 puzzle
    # is solvable is explained here:
    # https://www.geeksforgeeks.org/check-instance-15-puzzle-solvable/
    # I only coded for the case where N is even.
    def is_solvable(self):
        inv = self.get_inversions()
        odd = self.is_odd_row()
        if inv % 2 == 0 and odd:
            return True
        if inv % 2 == 1 and not odd:
            return True
        return False

    def get_inversions(self):
        cnt = 0
        for i, x in enumerate(self.lot[:-1]):
            if x != '':
                for y in self.lot[i+1:]:
                    if y != '' and int(x) > int(y):
                        cnt += 1
        return cnt

    # returns True if open square is in odd row from bottom:
    def is_odd_row(self):
        idx = self.lot.index('')
        return idx in [4,5,6,7,12,13,14,15]

    # returns name, text, and button object at row & col:
    def get_item(self, r, c):
        return self.bd[r][c].get()

    def get_square(self, r, c):
        return self.bd[r][c]

    def game_won(self):
        goal = [str(i) for i in range(1,16)] + ['']
        i = 0
        for r in range(4):
            for c in range(4):
                nm, txt, btn = self.get_item(r,c)
                if txt != goal[i]:
                    return False
                i += 1
        return True

# ************************************************

class Square:       # ['btn00', '0', None]
    def __init__(self, row, col, txt):
        self.row = row
        self.col = col
        self.name = 'btn' + str(row) + str(col)
        self.txt = txt
        self.btn = None

    def get(self):
            return [self.name, self.txt, self.btn]

    def set_btn(self, btn):
        self.btn = btn

    def set_txt(self, txt):
        self.txt = txt

# ************************************************

class Game:
    def __init__(self, gw):
        self.window = gw

        # game data:
        self.bd = None
        self.playable = False

        # top frame:
        self.top_fr = Frame(gw,
                            width=600,
                            height=100,
                            bg='light green')
        self.top_fr.pack(fill=X)

        self.hdg = Label(self.top_fr,
                         text='  15 PUZZLE GAME  ',
                         font='arial 22 bold',
                         fg='Navy Blue',
                         bg='white')
        self.hdg.place(relx=0.5, rely=0.4,
                       anchor=CENTER)

        self.dir = Label(self.top_fr,
                 text="(Click 'New Game' to begin)",
                 font='arial 12 ',
                 fg='Navy Blue',
                 bg='light green')
        self.dir.place(relx=0.5, rely=0.8,
                       anchor=CENTER)

        self.play_btn = Button(self.top_fr,
                               text='New \nGame',
                               bd=5,
                               bg='PaleGreen4',
                               fg='White',
                               font='times 12 bold',
                               command=self.new_game)
        self.play_btn.place(relx=0.92, rely=0.5,
                       anchor=E)

        # bottom frame:
        self.btm_fr = Frame(gw,
                            width=600,
                            height=500,
                            bg='light steel blue')
        self.btm_fr.pack(fill=X)

        # board frame:
        self.bd_fr = Frame(self.btm_fr,
                           width=400+2,
                           height=400+2,
                           relief='solid',
                           bd=1,
                           bg='lemon chiffon')
        self.bd_fr.place(relx=0.5, rely=0.5,
                         anchor=CENTER)

        self.play_game()

# ************************************************

    def new_game(self):
        self.playable = True
        self.dir.config(text='(Click on a square to move it)')
        self.play_game()

    def play_game(self):
        # place squares on board:
        if self.playable:
            btn_state = 'normal'
        else:
            btn_state = 'disable'
        self.bd = Board(self.playable)
        objh = 100  # widget height
        objw = 100  # widget width
        objx = 0    # x-position of widget in frame
        objy = 0    # y-position of widget in frame

        for r in range(4):
            for c in range(4):
                nm, txt, btn = self.bd.get_item(r,c)
                bg_color = 'RosyBrown1'
                if txt == '':
                    bg_color = 'White'
                game_btn = Button(self.bd_fr,
                                  text=txt,
                                  relief='solid',
                                  bd=1,
                                  bg=bg_color,
                                  font='times 12 bold',
                                  state=btn_state,
                                  command=lambda x=nm: self.clicked(x))
                game_btn.place(x=objx, y=objy,
                               height=objh, width=objw)

                sq = self.bd.get_square(r,c)
                sq.set_btn(game_btn)

                objx = objx + objw
            objx = 0
            objy = objy + objh

    # processing when a square is clicked:
    def clicked(self, nm):
        r, c = int(nm[3]), int(nm[4])
        nm_fr, txt_fr, btn_fr = self.bd.get_item(r,c)

        # cannot 'move' open square to itself:
        if not txt_fr:
            messagebox.showerror(
                'Error Message',
                'Please select "square" to be moved')
            return

        # 'move' square to open square if 'adjacent' to it:
        adjs = [(r-1,c), (r, c-1), (r, c+1), (r+1, c)]
        for x, y in adjs:
            if 0 <= x <= 3 and 0 <= y <= 3:
                nm_to, txt_to, btn_to = self.bd.get_item(x,y)
                if not txt_to:
                    sq = self.bd.get_square(x,y)
                    sq.set_txt(txt_fr)
                    sq = self.bd.get_square(r,c)
                    sq.set_txt(txt_to)
                    btn_to.config(text=txt_fr,
                                  bg='RosyBrown1')
                    btn_fr.config(text=txt_to,
                                  bg='White')
                    # check if game is won:
                    if self.bd.game_won():
                        ans = messagebox.askquestion(
                            'You won!!!   Play again?')
                        if ans == 'no':
                            self.window.destroy()
                        else:
                            self.new_game()
                    return

        # cannot move 'non-adjacent' square to open square:
        messagebox.showerror(
            'Error Message',
            'Illigal move, Try again')
        return

# ************************************************

root = Tk()
root.title('15 Puzzle Game')
root.geometry('600x600+100+50')
root.resizable(False, False)
g = Game(root)
root.mainloop()
