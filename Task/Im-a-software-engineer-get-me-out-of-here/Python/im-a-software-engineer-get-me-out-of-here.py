from collections import deque
from dataclasses import dataclass
from typing import List

@dataclass(frozen=True)
class CellWithCost:
    fromRow: int
    fromCol: int
    cost: int

ZERO = CellWithCost(0, 0, 0)

@dataclass
class Cell:
    row: int
    col: int

    def __repr__(self):
        return f"({self.row}, {self.col})"

GMOOH = (
    ".........00000.........\n"
    "......00003130000......\n"
    "....000321322221000....\n"
    "...00231222432132200...\n"
    "..0041433223233211100..\n"
    "..0232231612142618530..\n"
    ".003152122326114121200.\n"
    ".031252235216111132210.\n"
    ".022211246332311115210.\n"
    "00113232262121317213200\n"
    "03152118212313211411110\n"
    "03231234121132221411410\n"
    "03513213411311414112320\n"
    "00427534125412213211400\n"
    ".013322444412122123210.\n"
    ".015132331312411123120.\n"
    ".003333612214233913300.\n"
    "..0219126511415312570..\n"
    "..0021321524341325100..\n"
    "...00211415413523200...\n"
    "....000122111322000....\n"
    "......00001120000......\n"
    ".........00000.........\n"
).strip().splitlines()
HEIGHT, WIDTH = len(GMOOH), len(GMOOH[0])

directions = [
    Cell(1, -1), Cell(1, 0), Cell(1, 1),
    Cell(0, -1), Cell(0, 1),
    Cell(-1, -1), Cell(-1, 0), Cell(-1, 1)
]
routes: List[List[CellWithCost]] = []

#### Helper functions ####

def digit(ch: str) -> int:
    return int(ch) if ch.isdigit() else -1

#### End of helper functions ####

def searchFromCell(startRow: int, startCol: int):
    global routes

    routes = [[ZERO for _ in range(WIDTH)] for _ in range(HEIGHT)]
    routes[startRow][startCol] = CellWithCost(startRow, startCol, 0)

    queue = deque()
    row, col, cost = startRow, startCol, 0

    while True:
        step = digit(GMOOH[row][col])
        for d in directions:
            nr = row + step * d.row
            nc = col + step * d.col

            if 0 <= nr < HEIGHT and 0 <= nc < WIDTH and digit(GMOOH[nr][nc]) >= 0:
                current = routes[nr][nc]
                if current == ZERO or current.cost > cost + 1:
                    routes[nr][nc] = CellWithCost(row, col, cost+1)
                    if digit(GMOOH[nr][nc]) > 0:
                        queue.append(CellWithCost(nr, nc, cost+1))
        if not queue:
            break

        nextCell = queue.popleft()
        row, col, cost = nextCell.fromRow, nextCell.fromCol, nextCell.cost

def createRouteToCell(endRow: int, endCol: int) -> List[Cell]:
    route: deque[Cell] = deque()
    route.append(Cell(endRow, endCol))

    while True:
        cw = routes[endRow][endCol]
        if cw.cost == 0:
            break
        endRow, endCol = cw.fromRow, cw.fromCol
        route.appendleft(Cell(endRow, endCol))

    return list(route)

def showShortestRoutes():
    minCost = float("inf")
    bestCells: List[Cell] = []

    for r in range(HEIGHT):
        for c in range(WIDTH):
            if digit(GMOOH[r][c]) == 0:
                cw = routes[r][c]
                if cw != ZERO:
                    if cw.cost < minCost:
                        minCost = cw.cost
                        bestCells.clear()
                    if cw.cost == minCost:
                        bestCells.append(Cell(r, c))

    plural = "s" if len(bestCells) != 1 else ""
    isAre = "are" if len(bestCells) != 1 else "is"

    print(f"There {isAre} {len(bestCells)} shortest route{plural} of {minCost} days to safety:")
    for cell in bestCells:
        print(createRouteToCell(cell.row, cell.col))

def showUnreachableCells():
    unreachable: List[Cell] = []
    for r in range(HEIGHT):
        for c in range(WIDTH):
            if digit(GMOOH[r][c]) == 0 and routes[r][c] == ZERO:
                unreachable.append(Cell(r, c))

    print("The following cells are unreachable:")
    print(unreachable)

def showCellsWithLongestRoute():
    maxCost = -1
    worstCells: List[Cell] = []

    for r in range(HEIGHT):
        for c in range(WIDTH):
            if digit(GMOOH[r][c]) >= 0:
                cw = routes[r][c]
                if cw != ZERO:
                    if cw.cost > maxCost:
                        maxCost = cw.cost
                        worstCells.clear()
                    if cw.cost == maxCost:
                        worstCells.append(Cell(r, c))

    plural = "s" if len(worstCells) != 1 else ""
    isAre = "are" if len(worstCells) != 1 else "is"

    print(f"There {isAre} {len(worstCells)} cell{plural} that require {maxCost} days to receive reinforcements from HQ:")
    for cell in worstCells:
        print(createRouteToCell(cell.row, cell.col))

if __name__ == "__main__":
    searchFromCell(11, 11)
    showShortestRoutes()
    print()

    searchFromCell(21, 11)
    print("The shortest route from (21, 11) to (1, 11):")
    print(createRouteToCell(1, 11))
    print()

    searchFromCell(1, 11)
    print("The shortest route from (1, 11) to (21, 11):")
    print(createRouteToCell(21, 11))
    print()

    searchFromCell(11, 11)
    showUnreachableCells()
    print()

    showCellsWithLongestRoute()
