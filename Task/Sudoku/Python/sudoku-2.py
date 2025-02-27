# Sudoku Solver
# Recursive backtracking algorithm
# Usage: python3 sudoku.py [puzzle.txt]

import sys

grid0 = [[0,0,8,0,0,0,0,1,6],  # Data type for sudoku puzzles:
         [5,0,0,0,9,2,0,0,8],  # a list of 9 lists, each of 9 digits.
         [0,0,0,1,0,0,0,0,0],
         [9,0,0,3,0,0,8,2,0],  # grid0 is a global variable used by readFile()
         [0,2,0,0,0,0,0,7,0],
         [0,8,4,0,0,6,0,0,5],  # This sudoku is solved when there is no
         [0,0,0,0,0,3,0,0,0],  # filename argument on the command line.
         [4,0,0,9,6,0,0,0,2],
         [1,6,0,0,0,0,7,0,0]]

def readFile():
    '''Parses a textfile containing a sudoku puzzle;
       returns this puzzle as 'grid', a list of 9 lists of 9 digits.
       Returns grid0 if no filename is given on the command line.
    '''
    if len(sys.argv) == 1:  # No command line argument
        return grid0
    else:
        name = sys.argv[1]  # A filename or path/filename of a sudoku textfile
    file = open(name)
    grid = []
    while True:
        txt = file.readline()
        if txt == "": break
        row = []
        for ch in txt:                      # In the sudoku textfile:
            if ch == "#":    break          #   a '#' can be used for comments,
            if ch == ".":    row.append(0)  #   '.' or '0' stand for empty cells
            if ch == "_":    row.append(0)  #   '_' or '-'
            if ch == "-":    row.append(0)  #   could also be used for this.
            if ch.isdigit(): row.append(int(ch))
        if row != []:  # all lines without digits or empty cell characters give []
            if len(row) != 9:
                print("Sudoku file configuration error: not 9 columns");
                file.close; exit()          # Halt the program
            grid.append(row)
    file.close()
    if len(grid) != 9:
        print("Sudoku file configuration error: not 9 rows"); exit()
    else:
        return grid

def printGrid (grid):
    for i in range(0, 9):
        if i > 0 and i % 3 == 0:
            print("------+-------+------", end="")
            print()
        for j in range(0, 9):
            if j > 0 and j % 3 == 0: print("| ", end="")
            n = grid[i][j]
            c = "." if n == 0 else str(n)
            print(c, end=" ")
        print()

def valid (row, col, n):
    res = True
    for i in range(0, 9):
        for j in range(0, 9):
            if ( i == row or j == col or
                 i // 3 == row // 3 and j // 3 == col // 3 ):  # square
                if grid[i][j] == n: res = False
    return res

def solve():
    for row in range(0, 9):
        for col in range(0, 9):
            if grid[row][col] == 0:
                for n in (range(1, 10)):
                    if valid(row, col, n):
                        grid[row][col] = n
                        solve()             # recursive call
                        grid[row][col] = 0  # backtracking step
                return
    printGrid(grid)  # The solved sudoku
    input("\nPress enter to check for more solutions\n")

grid = readFile()    # valid() and solve() use this global variable
printGrid(grid)      # The unsolved sudoku
print()
solve()
