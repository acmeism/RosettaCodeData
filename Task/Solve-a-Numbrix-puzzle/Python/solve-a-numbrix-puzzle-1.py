import re


class HidatoPuzzle:
    """ Generic Hidato type puzzle solver, used here for Numbrix puzzles """

    def __init__(self, board_text: str, allowed_moves: list[list[int]]):
        """ initialize the puzzle from a board and the move rules
            . means blocked, 0 or _ means open, numeric > 0 are fixed points
        """
        lines = board_text.strip().split('\n')
        self.nrows, self.ncols = len(lines), len(re.split(r'\s+', lines[0]))
        self.board = [[-1] * self.ncols for _ in range(self.nrows)]
        self.allowed_moves = allowed_moves
        self.starts = []
        self.fixed = []
        self.solutions = []
        self.maxmoves = 0
        for i, line in enumerate(lines):
            for j, s in enumerate(re.split(r'\s+', line.strip())):
                c = s[0]
                if c == '_' or c == '0' and len(s) == 1:
                    self.board[i][j] = 0
                    self.maxmoves += 1
                elif c == '.':
                    continue # remains -1, blocked
                else:  # get digits and add to fixed numeric positions as > 0
                    self.board[i][j] = int(s)
                    self.fixed.append(self.board[i][j])
                    if self.board[i][j] == 1:
                        self.starts.append((i, j))
                    self.maxmoves += 1

        self.fixed.sort()
        if len(self.starts) != 1:  # 1 is not fixed, so we can start at any (0)
            self.starts = []
            for i in range(self.nrows):
                for j in range(self.ncols):
                    if self.board[i][j] == 0:
                        self.starts.append((i, j))

    def solve(self):
        """ solve puzzle: if start (1) not fixed may give multiple solutions """
        for xy in self.starts:
            saved = self.board
            self.board = [r[:] for r in self.board]
            if self.dfs(xy[0], xy[1], 1):
                self.solutions.append(self.board)
            self.board = saved

        return len(self.solutions) > 0

    def dfs(self, row, col, current_target):
        """ depth first search for a solution """
        if current_target > self.maxmoves:
            return True
        n = self.board[row][col]
        if not n in (0, current_target) or n == 0 and current_target in self.fixed:
            return False
        backnum = n  # backup board[row][col] value before trying change
        self.board[row][col] = current_target
        for move in self.allowed_moves:
            i, j = row + move[0], col + move[1]
            if 0 <= i < self.nrows and 0 <= j < self.ncols and \
               self.dfs(i, j, current_target + 1):
                return True

        self.board[row][col] = backnum  # restore board to original state
        return False

    def print_matrix(self, mat, emptysquare=" 0 ", blocked=" . "):
        """ pretty print 2D matrix with substitution for 0 or blocked values """
        d = {-1: blocked, 0: emptysquare, -2: '\n'}
        for i in range(self.nrows * self.ncols):
            d[i + 1] = str(i + 1).center(3, ' ')

        for r in range(self.nrows):
            for c in range(self.ncols):
                print(d[mat[r][c]], end='')
            print()

    def print_starting_board(self):
        """ print input board """
        self.print_matrix(self.board)

    def is_solved(self):
        """ true if there is at least 1 solution """
        return len(self.solutions) > 0

    def print_solution(self, print_all=True):
        """ print solution board(s) """
        n_solutions = len(self.solutions)
        print(f"\n{n_solutions} solution{'s' if n_solutions != 1 else ''} found.")
        for b in self.solutions:
            self.print_matrix(b, '__ ')
            if not print_all:
                break
            print()


if __name__ == '__main__':
    NUMBRIX_TESTS = [
        """
        0  0  0  0  0  0  0  0  0
        0  0 46 45  0 55 74  0  0
        0 38  0  0 43  0  0 78  0
        0 35  0  0  0  0  0 71  0
        0  0 33  0  0  0 59  0  0
        0 17  0  0  0  0  0 67  0
        0 18  0  0 11  0  0 64  0
        0  0 24 21  0  1  2  0  0
        0  0  0  0  0  0  0  0  0
        """,
        """
        0  0  0  0  0  0  0  0  0
        0 11 12 15 18 21 62 61  0
        0  6  0  0  0  0  0 60  0
        0 33  0  0  0  0  0 57  0
        0 32  0  0  0  0  0 56  0
        0 37  0  1  0  0  0 73  0
        0 38  0  0  0  0  0 72  0
        0 43 44 47 48 51 76 77  0
        0  0  0  0  0  0  0  0  0
        """,
        """
        17 0  0  0 11  0  0  0 59
        0 15  0  0  6  0  0 61  0
        0  0  3  0  0  0 63  0  0
        0  0  0  0 66  0  0  0  0
        23 24 0 68 67 78  0 54 55
        0  0  0  0 72  0  0  0  0
        0  0 35  0  0  0 49  0  0
        0 29  0  0 40  0  0 47  0
        31 0  0  0 39  0  0  0 45
        """,
        """
        0  0  0  0  0
        0  0  0  0  0
        0  0  0  0  3
        0  0  0  0  0
        0  0  0  0  0
        """,
    ]

    NUMBRIX_MOVES = [[-1, 0], [0, -1], [0, 1], [1, 0]]

    for t in NUMBRIX_TESTS:
        puzzle = HidatoPuzzle(t.strip(), NUMBRIX_MOVES)
        print("\nStarting position:")
        puzzle.print_starting_board()
        puzzle.solve()
        puzzle.print_solution()
