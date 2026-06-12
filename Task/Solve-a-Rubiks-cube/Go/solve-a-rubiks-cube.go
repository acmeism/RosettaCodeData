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

package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strings"
    "time"
)

type ai = [40]int

var applicableMoves = [5]int{0, 262143, 259263, 74943, 74898}

var phase = 0

var affectedCubies = [6][8]int{
    {0, 1, 2, 3, 0, 1, 2, 3},   // U
    {4, 7, 6, 5, 4, 5, 6, 7},   // D
    {0, 9, 4, 8, 0, 3, 5, 4},   // F
    {2, 10, 6, 11, 2, 1, 7, 6}, // B
    {3, 11, 7, 9, 3, 2, 6, 5},  // L
    {1, 8, 5, 10, 1, 0, 4, 7},  // R
}

func btoi(b bool) int {
    if b {
        return 1
    }
    return 0
}

func sliceToAi(s []int) ai {
    var a ai
    copy(a[:], s)
    for i := len(s); i < 40; i++ {
        a[i] = -1
    }
    return a
}

func applyMove(move int, state ai) ai {
    turns := move%3 + 1
    face := move / 3
    for turns != 0 {
        turns--
        oldState := state
        for i := 0; i < 8; i++ {
            isCorner := btoi(i > 3)
            target := affectedCubies[face][i] + isCorner*12
            temp := i + 1
            if (i & 3) == 3 {
                temp = i - 3
            }
            killer := affectedCubies[face][temp] + isCorner*12
            var orientationDelta int
            switch {
            case i < 4:
                orientationDelta = btoi(face > 1 && face < 4)
            case face < 2:
                orientationDelta = 0
            default:
                orientationDelta = 2 - (i & 1)
            }
            state[target] = oldState[killer]
            state[target+20] = oldState[killer+20] + orientationDelta
            if turns == 0 {
                state[target+20] %= 2 + isCorner
            }
        }
    }
    return state
}

func inverse(move int) int {
    return move + 2 - 2*(move%3)
}

func id(state ai) ai {
    //--- Phase 1: Edge orientations.
    if phase < 2 {
        return sliceToAi(state[20:32])
    }

    //-- Phase 2: Corner orientations, E slice edges.
    if phase < 3 {
        result := state[31:40]
        for e := uint(0); e < 12; e++ {
            result[0] |= (state[e] / 8) << e
        }
        return sliceToAi(result)
    }

    //--- Phase 3: Edge slices M and S, corner tetrads, overall parity.
    if phase < 4 {
        result := []int{0, 0, 0}
        for e := uint(0); e < 12; e++ {
            temp := 2
            if state[e] <= 7 {
                temp = state[e] & 1
            }
            result[0] |= temp << (2 * e)
        }
        for c := uint(0); c < 8; c++ {
            result[1] |= ((state[c+12] - 12) & 5) << (3 * c)
        }
        for i := 12; i < 19; i++ {
            for j := i + 1; j < 20; j++ {
                result[2] ^= btoi(state[i] > state[j])
            }
        }
        return sliceToAi(result)
    }

    //--- Phase 4: The rest.
    return state
}

func main() {
    startTime := time.Now()
    aggregateMoves := 0

    //--- Define the goal.
    goal := [20]string{
        "UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL",
        "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR",
    }

    //--- Load dataset (file name should be passed as a command line argument).
    if len(os.Args) != 2 {
        log.Fatal("the file name should be passed as a command line argument")
    }
    file, err := os.Open(os.Args[1])
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()

    var lineCount = 0
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()
        inputs := strings.Fields(line)
        lineCount++
        phase = 0
        totalMoves := 0

        //--- Prepare current (start) and goal state.
        var currentState ai
        var goalState ai
        for i := 0; i < 20; i++ {
            //--- Goal state.
            goalState[i] = i

            //--- Current (start) state.
            cubie := inputs[i]
            for {
                idx := -1
                for c := 0; c < len(goal); c++ {
                    if goal[c] == cubie {
                        idx = c
                        break
                    }
                }
                if idx >= 0 {
                    currentState[i] = idx
                } else {
                    currentState[i] = 20
                }
                if currentState[i] != 20 {
                    break
                }
                cubie = cubie[1:] + cubie[:1]
                currentState[i+20]++
            }
        }

        //--- Dance the funky Thistlethwaite..
    nextPhase:
        for phase++; phase < 5; phase++ {

            //--- Compute ids for current and goal state, skip phase if equal.
            currentId := id(currentState)
            goalId := id(goalState)
            if currentId == goalId {
                continue
            }

            //--- Initialize the BFS queue.
            q := []ai{currentState, goalState}

            //--- Initialize the BFS tables.
            predecessor := make(map[ai]ai)
            direction := make(map[ai]int)
            lastMove := make(map[ai]int)
            direction[currentId] = 1
            direction[goalId] = 2

            //--- Dance the funky bidirectional BFS...
            for {
                //--- Get state from queue, compute its ID and get its direction.
                oldState := q[0]
                q = q[1:]
                oldId := id(oldState)
                oldDir := direction[oldId]

                //--- Apply all applicable moves to it and handle the new state.
                for move := 0; move < 18; move++ {
                    if (applicableMoves[phase] & (1 << uint(move))) != 0 {
                        //--- Apply the move.
                        newState := applyMove(move, oldState)
                        newId := id(newState)
                        newDir := direction[newId]

                        //--- Have we seen this state (id) from the other direction already?
                        //--- I.e. have we found a connection?
                        if (newDir != 0) && (newDir != oldDir) {
                            //--- Make oldId represent the forwards
                            //--- and newId the backwards search state.
                            if oldDir > 1 {
                                newId, oldId = oldId, newId
                                move = inverse(move)
                            }

                            //--- Reconstruct the connecting algorithm.
                            algorithm := []int{move}
                            for oldId != currentId {
                                algorithm = append(algorithm, 0)
                                copy(algorithm[1:], algorithm[0:])
                                algorithm[0] = lastMove[oldId]
                                oldId = predecessor[oldId]
                            }
                            for newId != goalId {
                                algorithm = append(algorithm, inverse(lastMove[newId]))
                                newId = predecessor[newId]
                            }

                            //--- Print and apply the algorithm.
                            for i := 0; i < len(algorithm); i++ {
                                fmt.Printf("%c", "UDFBLR"[algorithm[i]/3])
                                fmt.Print(algorithm[i]%3 + 1)
                                fmt.Print(" ")
                                totalMoves++
                                currentState = applyMove(algorithm[i], currentState)
                            }

                            //--- Jump to the next phase.
                            continue nextPhase
                        }

                        //--- If we've never seen this state (id) before, visit it.
                        if newDir == 0 {
                            q = append(q, newState)
                            direction[newId] = oldDir
                            lastMove[newId] = move
                            predecessor[newId] = oldId
                        }
                    }
                }
            }
        }
        fmt.Printf(" (moves %d)\n", totalMoves)
        aggregateMoves += totalMoves
    }
    if err := scanner.Err(); err != nil {
        log.Fatal(err)
    }
    endTime := time.Now()
    elapsedTime := endTime.Sub(startTime).Nanoseconds() / 1000000
    fmt.Println("\nAverage number of moves =", float64(aggregateMoves)/float64(lineCount))
    fmt.Println("\nAverage time =", elapsedTime/int64(lineCount), "milliseconds")
}
