#=**********************************************************************
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
 *********************************************************************=#

const applicablemoves = [0, 262143, 259263, 74943, 74898]

const affectedcubies = [
0 1 2 3 0 1 2 3;   # U
4 7 6 5 4 5 6 7;   # D
0 9 4 8 0 3 5 4;   # F
2 10 6 11 2 1 7 6; # B
3 11 7 9 3 2 6 5;  # L
1 8 5 10 1 0 4 7]  # R

function applymove(move, state)
    state2, oldstate2 = deepcopy(state), zeros(Int, length(state))
    face, turns = divrem(move, 3) .+ 1
    while turns != 0
        turns -= 1
        oldstate2 .= state2
        for i in 1:8
            iscorner = i > 4
            target = affectedcubies[face, i] + iscorner * 12 + 1
            temp = ((i-1) & 3) == 3 ? i - 3 : i + 1
            killer = affectedcubies[face, temp] + iscorner * 12 + 1
            orientationdelta = i < 5 ? Int(face in [3, 4]) : face < 3 ? 0 : 2 - ((i-1) & 1)
            state2[target] = oldstate2[killer]
            state2[target + 20] = oldstate2[killer + 20] + orientationdelta
            (turns == 0) && (state2[target + 20] %= 2 + iscorner)
        end
    end
    return state2
end

inverse(move) = move + 2 - 2 * (move % 3)

function id(state::Vector{Int}, phase::Int)
    #--- Phase 1: Edge orientations.
    if phase < 2
        return state[21:32]
    elseif phase < 3
    #-- Phase 2: Corner orientations, E slice edges.
        result =  state[32:40]
        for e in 0:11
            result[1] |= ((state[e + 1] ÷ 8) << e)
        end
        return result
    elseif phase < 4
    #--- Phase 3: Edge slices M and S, corner tetrads, overall parity.
        result = zeros(Int, 3)
        for e in 0:11
            result[1] |= state[e + 1] > 7 ? 2 : (state[e + 1] & 1) << (2 * e)
        end
        for c in 0:7
            result[2] |= ((state[c + 12 + 1] - 12) & 5) << (3 * c)
        end
        for i in 13:19, j in i+1:20
            result[3] ⊻= Int(state[i] > state[j])
        end
        return result
    end
    #--- Phase 4: The rest.
    return state
end

function pochmann(fname)
    starttime = time_ns() ÷ 1000000
    aggregatemoves = 0
    #--- Define the goal.
    goal = ["UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL",
        "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR"]

    #--- Load dataset (file name should be passed as a command line argument).
    file = read(fname, String)
    linecount = 0
    for line in split(strip(file), "\n")
        inputs = split(line)
        linecount += 1
        totalmoves = 0
        #--- Prepare current (start) and goal state.
        state, goalstate, phase = zeros(Int, 40), zeros(Int, 40), 0
        for i in 1:20
            #--- Goal state.
            goalstate[i] = i - 1

            #--- Current (start) state.
            cubie = inputs[i]
            while true
                state[i] = something(findfirst(x -> x .== cubie, goal), 21) - 1
                (state[i] != 20) && break
                cubie = cubie[2:end] * cubie[1]
                state[i + 20] += 1
            end
        end
        #--- Dance the funky Thistlethwaite...
    @label nextphase    # preserves phase value, but restarts while loop
        while (phase += 1) < 5
            #--- Compute ids for current and goal state, skip phase if equal.
            currentid = id(state, phase)
            goalid = id(goalstate, phase)
            currentid == goalid && continue

            #--- Initialize the BFS queue.
            q = [state, goalstate]
            #--- Initialize the BFS tables.
            predecessor = Dict{Vector{Int}, Vector{Int}}()
            direction = Dict{Vector{Int}, Int}()
            lastmove = Dict{Vector{Int}, Int}()
            direction[currentid] = 1
            direction[goalid] = 2

            #--- Dance the funky bidirectional BFS...
            while true
                #--- Get state from queue, compute its ID and get its direction.
                oldstate = popfirst!(q)
                oldid = id(oldstate, phase)
                olddir = get!(direction, oldid, 0)

                #--- Apply all applicable moves to it and handle the new state.
                for move in 0:17
                    if applicablemoves[phase + 1] & (1 << UInt(move)) != 0
                        #--- Apply the move.
                        newstate = applymove(move, oldstate)
                        newid = id(newstate, phase)
                        newdir = get!(direction, newid, 0)

                        #--- Have we seen this state (id) from the other direction already?
                        #--- I.e. have we found a connection?
                        if (newdir != 0) && (newdir != olddir)
                            #--- Make oldid represent the forwards
                            #--- and newid the backwards search state.
                            if olddir > 1
                                newid, oldid = oldid, newid
                                move = inverse(move)
                            end

                            #--- Reconstruct the connecting algorithm.
                            algorithm = [move]
                            while oldid != currentid
                                pushfirst!(algorithm, get(lastmove, oldid, 0))
                                oldid = get!(predecessor, oldid, Int[])
                            end
                            while newid != goalid
                                push!(algorithm, inverse(get!(lastmove, newid, 0)))
                                newid = get!(predecessor, newid, Int[])
                            end

                            #--- Print and apply the algorithm.
                            for i in 1:length(algorithm)
                                print("UDFBLR"[algorithm[i] ÷ 3 + 1])
                                print(algorithm[i] % 3 + 1)
                                print(" ")
                                totalmoves += 1
                                state = applymove(algorithm[i], state)
                            end

                            #--- Jump to the next phase.
                            @goto nextphase
                        end
                        #--- If we've never seen this state (id) before, visit it.
                        if newdir == 0
                            push!(q, newstate)
                            direction[newid] = olddir
                            lastmove[newid] = move
                            predecessor[newid] = oldid
                        end
                    end
                    move += 1
                end
            end
        end
        println(" (moves $totalmoves)")
        aggregatemoves += totalmoves
    end
    elapsedtime = time_ns() ÷ 1000000 - starttime
    println("\nAverage number of moves = $(aggregatemoves / linecount)")
    println("\nAverage time = $(elapsedtime / linecount) milliseconds")
end

pochmann("rubikdata.txt")
