import std/[monotimes, sequtils, strformat, strutils, times]

const
  None = -1
  NoPosition = (None, None)

type
  Value = None..6
  Domino = (Value, Value)
  Position = (int, int)
  Tableau = array[7, array[8, Value]]
  Pattern = (seq[seq[Value]], seq[Domino], seq[Position])

const

  Tableau1 = [[Value 0, 5, 1, 3, 2, 2, 3, 1],
              [Value 0, 5, 5, 0, 5, 2, 4, 6],
              [Value 4, 3, 0, 3, 6, 6, 2, 0],
              [Value 0, 6, 2, 3, 5, 1, 2, 6],
              [Value 1, 1, 3, 0, 0, 2, 4, 5],
              [Value 2, 1, 4, 3, 3, 4, 6, 6],
              [Value 6, 4, 5, 1, 5, 4, 1, 4]]

  Tableau2 = [[Value 6, 4, 2, 2, 0, 6, 5, 0],
              [Value 1, 6, 2, 3, 4, 1, 4, 3],
              [Value 2, 1, 0, 2, 3, 5, 5, 1],
              [Value 1, 3, 5, 0, 5, 6, 1, 0],
              [Value 4, 2, 6, 0, 4, 0, 1, 1],
              [Value 4, 4, 2, 0, 5, 3, 6, 3],
              [Value 6, 6, 5, 2, 5, 3, 3, 4]]


func domino(v1, v2: Value): Domino =
  if v1 > v2: (v2, v1) else: (v1, v2)

func findLayouts(tab: Tableau; domCount: Positive): seq[Pattern] =
  let nrows = tab.len
  let ncols = tab[0].len
  var m = newSeqWith(nrows, repeat(Value None, ncols))
  result = @[(m, newSeq[Domino](), newSeq[Position]())]
  while true:
    var newpats: seq[Pattern]
    for pat in result:
      let (ut, ud, up) = pat
      var pos = NoPosition
      block Outer:
        for j in 0..<ncols:
          for i in 0..<nrows:
            if ut[i][j] == None:
              pos = (i, j)
              break Outer
      if pos == NoPosition:
        continue
      let (row , col) = pos
      if row < nrows - 1 and ut[row+1][col] == None:
        let dom = domino(tab[row][col], tab[row+1][col])
        if dom notin ud:
          var newUt = ut
          newut[row][col] = tab[row][col]
          newut[row+1][col] = tab[row+1][col]
          newpats.add (newut,
                       ud & domino(tab[row][col], tab[row+1][col]),
                       up & @[(row, col), (row+1, col)])
      if col < ncols - 1 and ut[row][col+1] == None:
        let dom = domino(tab[row][col], tab[row][col+1])
        if dom notin ud:
          var newUt = ut
          newut[row][col] = tab[row][col]
          newut[row][col+1] = tab[row][col+1]
          newpats.add (newut,
                       ud & domino(tab[row][col], tab[row][col+1]),
                       up & @[(row, col), (row, col+1)])
    if newPats.len == 0: break
    result = move(newPats)
    if result[0][2].len == domCount:
      break

proc printLayout(pattern: Pattern) =
  let (tab, _, pos) = pattern
  var output = newSeqWith(2 * tab.len, repeat(' ', tab[0].len * 2 - 1))
  var idx = 0
  while idx < pos.len - 1:
    let
      (x1, y1) = pos[idx]
      (x2, y2) = pos[idx+1]
    let
      n1 = tab[x1][y1]
      n2 = tab[x2][y2]
    output[x1*2][y1*2] = chr(48 + n1)
    output[x2*2][y2*2] = chr(48 + n2)
    if x1 == x2:
      output[x1*2][y1*2+1] = '+'
    elif y1 == y2:
      output[x1*2+1][y1*2] = '+'
    inc idx, 2
  for i in 0..output.high:
    echo output[i]

var domCount: Positive
for j in 0..Tableau1[0].high:
  for i in 0..Tableau1.high:
    if i <= j:
      inc domCount

for t in [Tableau1, Tableau2]:
  let start = getMonoTime()
  let lays = t.findLayouts(domCount)
  lays[0].printLayout()
  let lc = lays.len
  let pl = if lc > 1: "s" else: ""
  let fo = if lc > 1: " (first one shown)" else: ""
  echo &"{lc} layout{pl} found{fo}."
  echo &"Took {(getMonoTime() - start).inMilliseconds} ms.\n"
