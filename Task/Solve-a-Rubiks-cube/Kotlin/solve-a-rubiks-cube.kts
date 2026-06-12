// version 1.2.21

/**********************************************************************
 *
 * A cube 'state' is a vector<int> with 40 entries, the first 20
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

import java.util.ArrayDeque
import java.io.File

fun Boolean.toInt() = if (this) 1 else 0

typealias AI = ArrayList<Int>

val applicableMoves = intArrayOf(0, 262143, 259263, 74943, 74898)

val affectedCubies = listOf(
    intArrayOf(0,  1, 2,  3, 0, 1, 2, 3),  // U
    intArrayOf(4,  7, 6,  5, 4, 5, 6, 7),  // D
    intArrayOf(0,  9, 4,  8, 0, 3, 5, 4),  // F
    intArrayOf(2, 10, 6, 11, 2, 1, 7, 6),  // B
    intArrayOf(3, 11, 7,  9, 3, 2, 6, 5),  // L
    intArrayOf(1,  8, 5, 10, 1, 0, 4, 7)   // R
)

fun applyMove(move: Int, state: AI): AI {
    val state2 = AI(state)  // avoids mutating original 'state'.
    var turns = move % 3 + 1
    val face = move / 3
    while (turns-- != 0) {
        val oldState2 = AI(state2)
        for (i in 0..7) {
            val isCorner = (i > 3).toInt()
            val target = affectedCubies[face][i] + isCorner * 12
            val temp = if ((i and 3) == 3) i - 3 else i + 1
            val killer = affectedCubies[face][temp] + isCorner * 12
            val orientationDelta =
                if (i < 4) (face in 2..3).toInt()
                else if (face < 2) 0
                else 2 - (i and 1)
            state2[target] = oldState2[killer]
            state2[target + 20] = oldState2[killer + 20] + orientationDelta
            if (turns == 0) state2[target + 20] %= 2 + isCorner
        }
    }
    return state2
}

fun inverse(move: Int) = move + 2 - 2 * (move % 3)

var phase = 0

fun id(state: AI): AI {
    //--- Phase 1: Edge orientations.
    if (phase < 2) return AI(state.subList(20, 32))

    //-- Phase 2: Corner orientations, E slice edges.
    if (phase < 3) {
        val result =  AI(state.subList(31, 40))
        for (e in 0..11) result[0] = result[0] or ((state[e] / 8) shl e)
        return result
    }

    //--- Phase 3: Edge slices M and S, corner tetrads, overall parity.
    if (phase < 4) {
        val result = AI(3)
        repeat(3) { result.add(0) }
        for (e in 0..11) {
            val temp  = (if (state[e] > 7) 2 else (state[e] and 1)) shl (2 * e)
            result[0] = result[0] or temp
        }
        for (c in 0..7) {
            val temp =  ((state[c + 12] - 12) and 5) shl (3 * c)
            result[1] = result[1] or temp
        }
        for (i in 12..18) {
            for (j in (i + 1)..19) {
                result[2] = result[2] xor (state[i] > state[j]).toInt()
            }
        }
        return result
    }

    //--- Phase 4: The rest.
    return state
}

fun main(args: Array<String>) {
    val startTime = System.currentTimeMillis()
    var aggregateMoves = 0

    //--- Define the goal.
    val goal = listOf(
        "UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL",
        "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR"
    )

    //--- Load dataset (file name should be passed as a command line argument).
    val file = File(args[0])
    var lineCount = 0
    file.forEachLine { line ->
        val inputs = line.split(' ')
        lineCount++
        phase = 0
        var totalMoves = 0

        //--- Prepare current (start) and goal state.
        var currentState = AI(40)
        repeat(40) { currentState.add(0) }
        val goalState = AI(40)
        repeat(40) { goalState.add(0) }
        for (i in 0..19) {
            //--- Goal state.
            goalState[i] = i

            //--- Current (start) state.
            var cubie = inputs[i]
            while (true) {
                val idx = goal.indexOf(cubie)
                currentState[i] = if (idx >= 0) idx else 20
                if (currentState[i] != 20) break
                cubie = cubie.substring(1) + cubie[0]
                currentState[i + 20]++
            }
        }

        //--- Dance the funky Thistlethwaite...
        nextPhase@ while (++phase < 5) {
            //--- Compute ids for current and goal state, skip phase if equal.
            val currentId = id(currentState)
            val goalId = id(goalState)
            if (currentId == goalId) continue

            //--- Initialize the BFS queue.
            val q = ArrayDeque<AI>()
            q.addLast(currentState)
            q.addLast(goalState)

            //--- Initialize the BFS tables.
            val predecessor = mutableMapOf<AI, AI>()
            val direction = mutableMapOf<AI, Int>()
            val lastMove = mutableMapOf<AI, Int>()
            direction[currentId] = 1
            direction[goalId] = 2

            //--- Dance the funky bidirectional BFS...
            while (true) {
                //--- Get state from queue, compute its ID and get its direction.
                val oldState = q.peek()
                q.pop()
                var oldId = id(oldState)
                val oldDir = direction.getOrPut(oldId) { 0 }

                //--- Apply all applicable moves to it and handle the new state.
                var move = 0
                while (move < 18) {
                    if ((applicableMoves[phase] and (1 shl move)) != 0) {
                        //--- Apply the move.
                        val newState = applyMove(move, oldState)
                        var newId = id(newState)
                        var newDir = direction.getOrPut(newId) { 0 }

                        //--- Have we seen this state (id) from the other direction already?
                        //--- I.e. have we found a connection?
                        if ((newDir != 0) && (newDir != oldDir)) {
                            //--- Make oldId represent the forwards
                            //--- and newId the backwards search state.
                            if (oldDir > 1) {
                                val temp = newId
                                newId = oldId
                                oldId = temp
                                move = inverse(move)
                            }

                            //--- Reconstruct the connecting algorithm.
                            val algorithm = AI()
                            algorithm.add(move)
                            while (oldId != currentId) {
                                val tempI = lastMove.getOrPut(oldId) { 0 }
                                algorithm.add(0, tempI)
                                val tempAI = predecessor.getOrPut(oldId) { AI() }
                                oldId = tempAI
                            }
                            while (newId != goalId) {
                                val tempI = lastMove.getOrPut(newId) { 0 }
                                algorithm.add(inverse(tempI))
                                val tempAI = predecessor.getOrPut(newId) { AI() }
                                newId = tempAI
                            }

                            //--- Print and apply the algorithm.
                            for (i in 0 until algorithm.size) {
                                print("UDFBLR"[algorithm[i] / 3])
                                print(algorithm[i] % 3 + 1)
                                print(" ")
                                totalMoves++
                                currentState = applyMove(algorithm[i], currentState)
                            }

                            //--- Jump to the next phase.
                            continue@nextPhase
                        }

                        //--- If we've never seen this state (id) before, visit it.

                        if (newDir == 0) {
                            q.addLast(newState)
                            direction[newId] = oldDir
                            lastMove[newId] = move
                            predecessor[newId] = oldId
                        }
                    }
                    move++
                }
            }
        }
        println(" (moves $totalMoves)")
        aggregateMoves += totalMoves
    }
    val elapsedTime = System.currentTimeMillis() - startTime
    println("\nAverage number of moves = ${aggregateMoves.toDouble() / lineCount}")
    println("\nAverage time = ${elapsedTime / lineCount} milliseconds")
}
