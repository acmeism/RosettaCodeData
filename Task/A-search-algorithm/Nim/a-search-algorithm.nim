# A* search algorithm.

from algorithm import reverse
import sets
import strformat
import tables

const Infinity = 1_000_000_000

type Cell = tuple[row, col: int]

const
  Barriers = [(2, 4), (2, 5), (2, 6), (3, 6), (4, 6), (5, 6),
              (5, 5), (5, 4), (5, 3), (5, 2), (4, 2), (3, 2)].toHashSet
  Moves = [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1)]

#---------------------------------------------------------------------------------------------------

iterator neighbors(cell: Cell): Cell =
  ## Yield the neighbors of "cell".
  for move in Moves:
    let next = (row: cell.row + move[0], col: cell.col + move[1])
    if next.row in 0..7 and next.col in 0..7:
      yield next

#---------------------------------------------------------------------------------------------------

func d(current, neighbor: Cell): int =
  ## Return the cost for the move from "current" to "neighbor".
  if neighbor in Barriers: 100 else: 1

#---------------------------------------------------------------------------------------------------

func h(cell, goal: Cell): int =
    ## Compute the heuristic cost for a move form the cell to the goal.
    ## We use the Chebychev distance as appropriate for this kind of move.
    max(abs(goal.row - cell.row), abs(goal.col - cell.col))

#---------------------------------------------------------------------------------------------------

func reconstructedPath(cameFrom: Table[Cell, Cell]; current: Cell): seq[Cell] =
  ## Return the shortest path from the start to the goal.
  var cell = current
  result = @[cell]
  while cell in cameFrom:
    cell = cameFrom[cell]
    result.add(cell)
  result.reverse()

#---------------------------------------------------------------------------------------------------

func search(start, goal: Cell): tuple[path: seq[Cell], cost: int] =
  ## Search the shortest path from "start" to "goal" using A* algorithm.
  ## Return the path and the cost.

  var openSet = [start].toHashSet()
  var visited: HashSet[Cell]
  var cameFrom: Table[Cell, Cell]
  var gScore, fScore: Table[Cell, int]
  gscore[start] = 0
  fScore[start] = h(start, goal)

  while openSet.len != 0:

    # Find cell in "openset" with minimal "fScore".
    var current: Cell
    var minScore = Infinity
    for cell in openSet:
      let score = fScore.getOrDefault(cell, Infinity)
      if score < minScore:
        current = cell
        minScore = score

    if current == goal:
      # Return the path and cost.
      return (reconstructedPath(cameFrom, current), fScore[goal])

    openSet.excl(current)
    visited.incl(current)

    # Update scores for neighbors.
    for neighbor in current.neighbors():
      if neighbor in visited:
        # Already processed.
        continue
      let tentative = gScore[current] + d(current, neighbor)
      if tentative < gScore.getOrDefault(neighbor, Infinity):
        cameFrom[neighbor]= current
        gScore[neighbor] = tentative
        fScore[neighbor] = tentative + h(neighbor, goal)
        openSet.incl(neighbor)

#---------------------------------------------------------------------------------------------------

proc drawBoard(path: seq[Cell]) =
  ## Draw the board and the path.

  func `$`(cell: Cell): string =
    ## Return the Unicode string to use for a cell.
    if cell in Barriers: "██" else: (if cell in path: " #" else: " ·")

  echo "████████████████████"
  for row in 0..7:
    stdout.write("██")
    for col in 0..7:
      stdout.write((row, col))
    stdout.write("██\n")
  echo "████████████████████"
  echo '\n'

#---------------------------------------------------------------------------------------------------

proc printSolution(path: seq[Cell]; cost: int) =
  ## Print the solution.
  var pathLine = "Path: "
  let start = pathLine.len
  for cell in path:
    pathLine.addSep(" → ", start)
    pathLine.add(&"({cell.row}, {cell.col})")
  echo pathLine
  echo(&"Cost: {cost}\n\n")
  drawBoard(path)

#---------------------------------------------------------------------------------------------------

let (path, cost) = search((0, 0), (7, 7))
if cost == 0:
  echo "No solution found"
else:
  printSolution(path, cost)
