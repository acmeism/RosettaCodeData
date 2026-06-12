#[
**********************************************************************
*
* A cube 'state' is a sequence of ints with 40 entries, the first
* 20 are a permutation of {0,...,19} and describe which cubie is
* at a certain position (regarding the input ordering). The first
* twelve are for edges, the last eight for corners.
*
* The last 20 entries are for the orientations, each describing
* how often the cubie at a certain position has been turned
* counterclockwise away from the correct orientation. Again the
* first twelve are edges, the last eight are corners. The values
* are 0 or 1 for edges and 0, 1 or 2 for corners.
*
**********************************************************************
]#

import deques, os, strformat, strutils, tables, times

const

  ApplicableMoves = [0, 262143, 259263, 74943, 74898]

  AffectedCubies = [[0,  1, 2,  3, 0, 1, 2, 3],  # U
                    [4,  7, 6,  5, 4, 5, 6, 7],  # D
                    [0,  9, 4,  8, 0, 3, 5, 4],  # F
                    [2, 10, 6, 11, 2, 1, 7, 6],  # B
                    [3, 11, 7,  9, 3, 2, 6, 5],  # L
                    [1,  8, 5, 10, 1, 0, 4, 7]]  # R

type State = seq[int]

func initState(n: Natural = 0): State = newSeq[int](n)


var phase: Natural


proc slicetoState(s: openArray[int]): State =
  result.setLen(40)
  for i, val in s: result[i] = val
  for i in s.len..39: result[i] = -1


proc id(state: State): State =

  case phase
  of 1: # Phase 1: Edge orientations.
    result = sliceToState(state[20..31])

  of 2: # Phase 2: Corner orientations, E slice edges.
    var res = state[31..39]
    for e in 0..11:
      res[0] = res[0] or state[e] shr 3 shl e
    result = sliceToState(res)

  of 3: # Phase 3: Edge slices M and S, corner tetrads, overall parity.
    var res = @[0, 0, 0]
    for e in 0..11:
      let temp = if state[e] > 7: 2 else: (state[e] and 1) shl (2 * e)
      res[0] = res[0] or temp
    for c in 0..7:
      res[1] = res[1] or ((state[c + 12] - 12) and 5) shl (3 * c)
    for i in 12..18:
      for j in (i + 1)..19:
        res[2] = res[2] xor ord(state[i] > state[j])
    result = sliceToState(res)

  else: # Phase 4: The rest.
    result = state


proc applyMove(move: int; state: State): State =
  result = state
  var turns = move mod 3 + 1
  let face = move div 3
  while turns != 0:
    dec turns
    var oldState = result
    for i in 0..7:
      let isCorner = ord(i > 3)
      let target = AffectedCubies[face][i] + isCorner * 12
      let temp = if (i and 3) == 3: i - 3 else: i + 1
      let killer = AffectedCubies[face][temp] + isCorner * 12
      let orientationDelta =
        if i < 4: ord(face in 2..3)
        elif face < 2: 0
        else: 2 - (i and 1)
      result[target] = oldState[killer]
      result[target + 20] = oldState[killer + 20] + orientationDelta
      if turns == 0:
          result[target + 20] = result[target + 20] mod (2 + isCorner)


func inverse(move: int): int = move + 2 - 2 * (move mod 3)


let startTime = cpuTime()
var aggregateMoves = 0

# Define the goal.
const Goal = ["UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL",
              "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR"]

# Load dataset (file name should be passed as a command line argument).
if paramCount() == 0: quit "Missing file name", QuitFailure
var lineCount = 0
for line in paramStr(1).lines():
  let inputs = line.splitWhitespace()
  inc lineCount
  var totalMoves = 0

  # Prepare current (start) and goal state.
  var currentState, goalState = initState(40)
  for i in 0..19:
    # Goal state.
    goalState[i] = i
    # Current (start) state.
    var cubie = inputs[i]
    while true:
      let idx = Goal.find(cubie)
      currentState[i] = if idx >= 0: idx else: 20
      if currentState[i] != 20: break
      cubie = cubie[1..^1] & cubie[0]
      inc currentState[i + 20]

  # Dance the funky Thistlethwaite...
  phase = 1
  while phase < 5:
    block doPhase:

      # Compute ids for current and goal state, skip phase if equal.
      let currentId = id(currentState)
      let goalId = id(goalState)
      if currentId == goalId: break doPhase

      # Initialize the BFS queue.
      var q = [currentState, goalState].toDeque

      # Initialize the BFS tables.
      var predecessor: Table[State, State]
      var direction, lastMove: Table[State, int]
      direction[currentId] = 1
      direction[goalId] = 2

      # Dance the funky bidirectional BFS.
      while true:
        # Get state from queue, compute its ID and get its direction.
        let oldState = q.popFirst()
        var oldId = id(oldState)
        let oldDir = direction[oldId]

        # Apply all applicable moves to it and handle the new state.
        var move = 0
        while move < 18:
          if (ApplicableMoves[phase] and (1 shl move)) != 0:
            # Apply the move.
            let newState = applyMove(move, oldState)
            var newId = id(newState)
            let newDir = direction.getOrDefault(newId, 0)

            # Have we seen this state (id) from the other direction already?
            # I.e. have we found a connection?
            if newDir != 0 and newDir != oldDir:
              # Make oldId represent the forwards and newId the backwards search state.
              if oldDir > 1:
                swap newId, oldId
                move = inverse(move)

              # Reconstruct the connecting algorithm.
              var algorithm: State = @[move]
              while oldId != currentId:
                algorithm.insert(lastMove.mgetOrPut(oldId, 0), 0)
                oldId = predecessor.mgetOrPut(oldId, initState())
              while newId != goalId:
                algorithm.add inverse(lastMove.mgetOrPut(newId, 0))
                newId = predecessor.mgetOrPut(newId, initState())

              # Print and apply the algorithm.
              for step in algorithm:
                stdout.write "UDFBLR"[step div 3], step mod 3 + 1, ' '
                inc totalMoves
                currentState = applyMove(step, currentState)

              # Jump to the next phase.
              break doPhase

            # If we've never seen this state (id) before, visit it.
            if newdir == 0:
              q.addLast(newState)
              direction[newId] = oldDir
              lastMove[newId] = move
              predecessor[newId] = oldId

          inc move

    inc phase

  echo &" (moves {totalMoves})"
  inc aggregateMoves, totalMoves

let elapsedTime = cpuTime() - startTime
echo &"\nAverage number of moves = {aggregateMoves / lineCount}"
echo &"\nAverage time = {elapsedTime * 1000 / lineCount.toFloat:.2f} milliseconds"
