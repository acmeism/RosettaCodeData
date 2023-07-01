''' Python 3.6.5 code using Tkinter graphical user
    interface (Canvas widget) to display final results.'''
from tkinter import *

# given a grid, display it on a tkinter Canvas:
class Sandpile:
    def __init__(self, wn, grid):
        self.window = wn
        self.grid = grid
        self.canvas = Canvas(wn, bg='lemon chiffon')
        self.canvas.pack(fill=BOTH, expand=1)

        colors = {0:'dodger blue',
                  1:'red',
                  2:'green',
                  3:'lemon chiffon'}

        x = 10
        y = 10
        d = 5

        for row in self.grid:
            for value in row:
                clr = colors[value]
                self.canvas.create_rectangle(
                    x, y, x+d, y+d,
                    outline=clr,
                    fill = clr)
                x += 5
            x = 10
            y += 5

class Grid:
    def __init__(self, size, center):
        self.size = size        # rows/cols in (best if odd)
        self.center = center    # start value at center of grid
        self.grid = [[0]*self.size for i in range(self.size)]
        self.grid[self.size // 2][self.size // 2] = self.center

    # print the grid:
    def show(self, msg):
        print('  ' + msg + ':')
        for row in self.grid:
            print(' '.join(str(x) for x in row))
        print()
        return

    # dissipate piles of sand as required:
    def abelian(self):
        while True:
            found = False
            for r in range(self.size):
                for c in range(self.size):
                    if self.grid[r][c] > 3:
                        self.distribute(self.grid[r][c], r, c)
                        found = True
            if not found:
                return

    # distribute sand from a single pile to its neighbors:
    def distribute(self, nbr, row, col):
        qty, remain = divmod(nbr, 4)
        self.grid[row][col] = remain
        for r, c in [(row+1, col),
                     (row-1, col),
                     (row, col+1),
                     (row, col-1)]:
            self.grid[r][c] += qty
        return

    # display the grid using tkinter:
    def display(self):
        root = Tk()
        root.title('Sandpile')
        root.geometry('700x700+100+50')
        sp = Sandpile(root, self.grid)
        root.mainloop()

# execute program for size, center value pair:
# just print results for a small grid
g = Grid(9,17)
g.show('BEFORE')
g.abelian()          # scatter the sand
g.show('AFTER')

# just show results in tkinter for a large grid
# I wish there was a way to attach a screen shot
# of the tkinter result here
g = Grid(131,25000)
g.abelian()          # scatter the sand
g.display()          # display result using tkinter

##  OUTPUT:
##
##      BEFORE:
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 17 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##
##      AFTER:
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 1 0 0 0 0
##    0 0 0 2 1 2 0 0 0
##    0 0 1 1 1 1 1 0 0
##    0 0 0 2 1 2 0 0 0
##    0 0 0 0 1 0 0 0 0
##    0 0 0 0 0 0 0 0 0
##    0 0 0 0 0 0 0 0 0
