import sequtils, strformat

const Moves = [[-1, -2], [1, -2], [-2, -1], [2, -1], [-2, 1], [2, 1], [-1, 2], [1, 2]]

proc solve(pz: var seq[seq[int]]; sx, sy, idx, count: Natural): bool =

  if idx > count: return true

  var x, y: int
  for move in Moves:
    x = sx + move[0]
    y = sy + move[1]
    if x in 0..pz.high and y in 0..pz.high and pz[x][y] == 0:
      pz[x][y] = idx
      if pz.solve(x, y, idx + 1, count): return true
      pz[x][y] = 0


proc findSolution(board: openArray[string]) =
  let sz = board.len
  var pz = newSeqWith(sz, repeat(-1, sz))

  var count = 0
  var x, y: int
  for i in 0..<sz:
    for j in 0..<sz:
      case board[i][j]
      of 'x':
        pz[i][j] = 0
        inc count
      of 's':
        pz[i][j] = 1
        inc count
        (x, y) = (i, j)
      else:
        discard

  if pz.solve(x, y, 2, count):
    for i in 0..<sz:
      for j in 0..<sz:
        if pz[i][j] != -1:
          stdout.write &"{pz[i][j]:02}  "
        else:
          stdout.write "--  "
      stdout.write '\n'

when isMainModule:

  const

    Board1 = [" xxx    ",
              " x xx   ",
              " xxxxxxx",
              "xxx  x x",
              "x x  xxx",
              "sxxxxxx ",
              "  xx x  ",
              "   xxx  "]

    Board2 = [".....s.x.....",
              ".....x.x.....",
              "....xxxxx....",
              ".....xxx.....",
              "..x..x.x..x..",
              "xxxxx...xxxxx",
              "..xx.....xx..",
              "xxxxx...xxxxx",
              "..x..x.x..x..",
              ".....xxx.....",
              "....xxxxx....",
              ".....x.x.....",
              ".....x.x....."]

  Board1.findSolution()
  echo()
  Board2.findSolution()
