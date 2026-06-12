/**********************************************************************
 *
 * A cube 'state' is an int array with 40 entries, the first 20
 * are a permutation of {0,...,19} and describe which cubie is at
 * a certain position (regarding the input ordering). The first
 * twelve are for edges, the last eight for corners.
 *
 * The last 20 entries are for the orientations, each describing
 * how often the cubie at a certain position has been turned
 * counterclockwise away from the correct orientation. Again the
 * first twelve are edges, the last eight are corners. The values
 * are 0 or 1 for edges and 0, 1 or 2 for corners.
 *
 **********************************************************************/

import "os" for Process
import "io" for File

var applicableMoves= [0, 262143, 259263, 74943, 74898]

var phase = 0

var affectedCubies = [
    [0,  1, 2,  3, 0, 1, 2, 3],   // U
    [4,  7, 6,  5, 4, 5, 6, 7],   // D
    [0,  9, 4,  8, 0, 3, 5, 4],   // F
    [2, 10, 6, 11, 2, 1, 7, 6],   // B
    [3, 11, 7,  9, 3, 2, 6, 5],   // L
    [1,  8, 5, 10, 1, 0, 4, 7]    // R
]

var btoi = Fn.new { |b| (b) ? 1 : 0 }

var applyMove = Fn.new { |move, origState|
    var state = origState[0..-1] // make copy so don't mutate original
    var turns = move%3 + 1
    var face = (move/3).floor
    while (turns != 0) {
        turns = turns - 1
        var oldState = state[0..-1]  // make a copy prior to mutation
        for (i in 0..7) {
            var isCorner = btoi.call(i > 3)
            var target = affectedCubies[face][i] + isCorner*12
            var temp = (i&3 == 3) ? i - 3 : i + 1
            var killer = affectedCubies[face][temp] + isCorner*12
            var orientationDelta
            if (i < 4) {
                orientationDelta = btoi.call(face > 1 && face < 4)
            } else if (face < 2) {
                orientationDelta = 0
            } else {
                orientationDelta = 2 - (i&1)
            }
            state[target] = oldState[killer]
            state[target+20] = oldState[killer+20] + orientationDelta
            if (turns == 0) state[target+20] = state[target+20] % (2 + isCorner)
        }
    }
    return state
}

var inverse = Fn.new { |move| move + 2 - 2*(move%3) }

var id = Fn.new { |state|
    //--- Phase 1: Edge orientations.
    if (phase < 2) return state[20...32]

    //--- Phase 2: Corner orientations, E slice edges.
    if (phase < 3) {
        var result = state[31...40]
        for (e in 0..11) result[0] = result[0] | ((state[e]/8).floor << e)
        return result
    }

    //--- Phase 3: Edge slices M and S, corner tetrads, overall parity.
    if (phase < 4) {
        var result = [0, 0, 0]
        for (e in 0..11) {
            var temp = ((state[e] > 7) ? 2 : state[e] & 1) << (2 * e)
            result[0] = result[0] | temp
        }
        for (c in 0..7) {
            var temp = ((state[c + 12] - 12) & 5) << (3 * c)
            result[1] = result[1] | temp
        }
        for (i in 12..18) {
            for (j in i+1..19) result[2] = result[2] ^ btoi.call(state[i] > state[j])
        }
        return result
    }

    //--- Phase 4: The rest.
    return state
}

var startTime = System.clock
var aggregateMoves = 0

//--- Define the goal.
var goal = ["UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL",
    "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR"]

//--- Load dataset (file name should be passed as a command line argument).
if (Process.arguments.count != 1) {
    Fiber.abort("The file name should be passed as a command line argument.")
}

var lines = File.read(Process.arguments[0]).split("\n")
if (lines[-1] == "") lines.removeAt(-1) // if there's a final blank line remove it
var lineCount = lines.count
for (line in lines) {
    var inputs = line.split(" ")
    phase = 0
    var totalMoves = 0

    //--- Prepare current (start) and goal state.
    var currentState = List.filled(40, 0)
    var goalState = List.filled(40, 0)
    for (i in 0..19) {
        //--- Goal state.
        goalState[i] = i

        //--- Current (start) state.
        var cubie = inputs[i]
        while (true) {
            var idx = -1
            for (c in 0...goal.count) {
                if (goal[c] == cubie) {
                    idx = c
                    break
                }
            }
            currentState[i] = (idx >= 0) ? idx : 20
            if (currentState[i] != 20) break
            cubie = cubie[1..-1] + cubie[0]
            currentState[i+20] = currentState[i+20] + 1
        }
    }

    //--- Dance the funky Thistlethwaite..
    phase = phase + 1
    while (phase < 5) {
        var nextPhase = false
        //--- Compute ids for current and goal state, skip phase if equal.
        var currentId = id.call(currentState).join(" ")
        var goalId = id.call(goalState).join(" ")
        if (currentId != goalId) {
            //--- Initialize the BFS queue.
            var q = [currentState, goalState]

            //--- Initialize the BFS tables.
            var predecessor = {}
            var direction = {}
            var lastMove = {}
            direction[currentId] = 1
            direction[goalId] = 2

            //--- Dance the funky bidirectional BFS...
            while (true) {
                //--- Get state from queue, compute its ID and get its direction.
                var oldState = q[0]
                q = q[1..-1]
                var oldId = id.call(oldState).join(" ")
                var oldDir = direction[oldId]
                if (oldDir == null) {
                    oldDir = 0
                    direction[oldId] = 0
                }

                //--- Apply all applicable moves to it and handle the new state.
                var move = 0
                while (move < 18) {
                    if ((applicableMoves[phase] & (1 << move)) != 0) {
                        //--- Apply the move.
                        var newState = applyMove.call(move, oldState)
                        var newId = id.call(newState).join(" ")
                        var newDir = direction[newId]
                        if (newDir == null) {
                            newDir = 0
                            direction[newId] = 0
                        }

                        //--- Have we seen this state (id) from the other direction already?
                        //--- I.e. have we found a connection?
                        if (newDir != 0 && newDir != oldDir) {
                            //--- Make oldId represent the forwards
                            //--- and newId the backwards search state.
                            if (oldDir > 1) {
                                var t = newId
                                newId = oldId
                                oldId = t
                                move = inverse.call(move)
                            }

                            //--- Reconstruct the connecting algorithm.
                            var algorithm = [move]
                            while (oldId != currentId) {
                                var t = lastMove[oldId]
                                if (t == null) {
                                    t = 0
                                    lastMove[oldId] = 0
                                }
                                algorithm.insert(0, t)
                                oldId = predecessor[oldId]
                                if (oldId == null) {
                                    oldId = ""
                                    predecessor[oldId] = ""
                                }
                            }
                            while (newId != goalId) {
                                var t = lastMove[newId]
                                if (t == null) {
                                    t = 0
                                    lastMove[newId] = 0
                                }
                                algorithm.add(inverse.call(t))
                                newId = predecessor[newId]
                                if (newId == null) {
                                    newId = ""
                                    predecessor[newId] = ""
                                }
                            }

                            //--- Print and apply the algorithm.
                            for (i in 0...algorithm.count) {
                                System.write("UDFBLR"[(algorithm[i]/3).floor])
                                System.write(algorithm[i]%3 + 1)
                                System.write(" ")
                                totalMoves = totalMoves + 1
                                currentState = applyMove.call(algorithm[i], currentState)
                            }

                            nextPhase = true
                            break
                        }

                        //--- If we've never seen this state (id) before, visit it.
                        if (newDir == 0) {
                            q.add(newState)
                            direction[newId] = oldDir
                            lastMove[newId] = move
                            predecessor[newId] = oldId
                        }
                    }
                    move  = move + 1
                }
                if (nextPhase) break
            }
        }
        phase = phase + 1
    }
    System.print(" (moves %(totalMoves))")
    aggregateMoves = aggregateMoves + totalMoves
}
var endTime = System.clock
var elapsedTime = ((endTime - startTime) * 1000).round
System.print("\nAverage number of moves = %(aggregateMoves/lineCount)")
System.print("\nAverage time = %(elapsedTime/lineCount) milliseconds")
