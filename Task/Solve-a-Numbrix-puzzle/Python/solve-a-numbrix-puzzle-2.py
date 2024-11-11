# numbrix.py by Xing216
MOVES = [(1, 0), (0, 1), (-1, 0), (0, -1)]
class Numbrix:
    def __init__(self) -> None:
        self.grid: list[list[int]]
        self.clues: list[int]
        self.totalToFill: int
        self.startRow: int
        self.StartCol: int
    def solve(self, row, col, count:int, nextClue: int) -> bool:
        if count > self.totalToFill:
            return True
        back = self.grid[row][col]
        if back not in [0, count]:
            return False
        if back == 0 and nextClue < len(self.clues) and self.clues[nextClue] == count:
            return False
        nextClue = nextClue
        if back == count: nextClue += 1
        self.grid[row][col] = count
        for move in MOVES:
            if self.solve(row + move[1], col + move[0], count + 1, nextClue):
                return True
        self.grid[row][col] = back
    def xprint(self):
        for row in self.grid:
            for val in row:
                if val != -1:
                    print(f"{val:02d} ",end='')
            print()
def initNumbrix(board: list[str]) -> Numbrix:
    result = Numbrix()
    nRows = len(board)
    nCols = len(board[0].split(','))
    result.grid = [[-1]*(nCols + 2) for _ in range(nRows + 2)]
    result.totalToFill = nRows * nCols
    xlist = []
    for r, row in enumerate(board):
        row = row.split(',')
        for c, tile in enumerate(row):
            val = int(tile)
            result.grid[r + 1][c + 1] = val
            if val > 0:
                xlist.append(val)
                if val == 1:
                    result.startRow = r + 1
                    result.startCol = c + 1
    xlist.sort()
    result.clues = xlist
    return result
if __name__ == "__main__":
    EXAMPLE1 = ["00,00,00,00,00,00,00,00,00",
                "00,00,46,45,00,55,74,00,00",
                "00,38,00,00,43,00,00,78,00",
                "00,35,00,00,00,00,00,71,00",
                "00,00,33,00,00,00,59,00,00",
                "00,17,00,00,00,00,00,67,00",
                "00,18,00,00,11,00,00,64,00",
                "00,00,24,21,00,01,02,00,00",
                "00,00,00,00,00,00,00,00,00"]
    EXAMPLE2 = ["00,00,00,00,00,00,00,00,00",
                "00,11,12,15,18,21,62,61,00",
                "00,06,00,00,00,00,00,60,00",
                "00,33,00,00,00,00,00,57,00",
                "00,32,00,00,00,00,00,56,00",
                "00,37,00,01,00,00,00,73,00",
                "00,38,00,00,00,00,00,72,00",
                "00,43,44,47,48,51,76,77,00",
                "00,00,00,00,00,00,00,00,00"]
    EXAMPLE3 = ["17,00,00,00,11,00,00,00,59",
                "00,15,00,00,06,00,00,61,00",
                "00,00,03,00,00,00,63,00,00",
                "00,00,00,01,66,00,00,00,00",
                "23,24,00,68,67,78,00,54,55",
                "00,00,00,00,72,00,00,00,00",
                "00,00,35,00,00,00,49,00,00",
                "00,29,00,00,40,00,00,47,00",
                "31,00,00,00,39,00,00,00,45"]
    for i, board in enumerate([EXAMPLE1,EXAMPLE2, EXAMPLE3]):
        numbrix = initNumbrix(board)
        if numbrix.solve(numbrix.startRow, numbrix.startCol, 1, 0):
            print(f"Solution for example {i+1}:", end="")
            numbrix.xprint()
        else:
            "No solution."
