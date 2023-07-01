import strformat

const Connections = [(1, 3), (1, 4), (1, 5),  # A to C, D, E
                     (2, 4), (2, 5), (2, 6),  # B to D, E, F
                     (7, 3), (7, 4), (7, 5),  # G to C, D, E
                     (8, 4), (8, 5), (8, 6),  # H to D, E, F
                     (3, 4), (4, 5), (5, 6)]  # C-D, D-E, E-F

type
  Peg = 1..8
  Pegs = array[1..8, Peg]


func valid(pegs: Pegs): bool =
  for (src, dst) in Connections:
    if abs(pegs[src] - pegs[dst]) == 1:
      return false
  result = true


proc print(pegs: Pegs; num: Positive) =
  echo &"----- {num} -----"
  echo &"  {pegs[1]} {pegs[2]}"
  echo &"{pegs[3]} {pegs[4]} {pegs[5]} {pegs[6]}"
  echo &"  {pegs[7]} {pegs[8]}"
  echo()


proc findSolution(pegs: var Pegs; left, right: Natural; solCount = 0): Natural =
  var solCount = solCount
  if left == right:
    if pegs.valid():
      inc solCount
      pegs.print(solCount)
  else:
    for i in left..right:
      swap pegs[left], pegs[i]
      solCount = pegs.findSolution(left + 1, right, solCount)
      swap pegs[left], pegs[i]
  result = solCount


when isMainModule:

  var pegs = [Peg 1, 2, 3, 4, 5, 6, 7, 8]
  discard pegs.findSolution(1, 8)
