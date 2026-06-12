import time
import sys

ai = list[int]

applicable_moves = [0, 262143, 259263, 74943, 74898]

phase = 0

affected_cubies = [
    [0, 1, 2, 3, 0, 1, 2, 3],   # U
    [4, 7, 6, 5, 4, 5, 6, 7],   # D
    [0, 9, 4, 8, 0, 3, 5, 4],   # F
    [2, 10, 6, 11, 2, 1, 7, 6], # B
    [3, 11, 7, 9, 3, 2, 6, 5],  # L
    [1, 8, 5, 10, 1, 0, 4, 7],  # R
]

def btoi(b: bool) -> int:
    """Converts a boolean to an integer (1 for True, 0 for False)."""
    return 1 if b else 0

def slice_to_ai(s: list[int]) -> ai:
    """Converts a slice to an ai (list of 40 ints)."""
    a: ai = [0] * 40
    a[:len(s)] = s
    for i in range(len(s), 40):
        a[i] = -1
    return a

def apply_move(move: int, state: ai) -> ai:
    """Applies a given move to the given state."""
    turns = move % 3 + 1
    face = move // 3
    new_state = state[:]  # Create a copy of the state
    for _ in range(turns):
        old_state = new_state[:]
        for i in range(8):
            is_corner = btoi(i > 3)
            target = affected_cubies[face][i] + is_corner * 12
            temp = i + 1
            if (i & 3) == 3:
                temp = i - 3
            killer = affected_cubies[face][temp] + is_corner * 12
            orientation_delta = 0
            if i < 4:
                orientation_delta = btoi(face > 1 and face < 4)
            elif face < 2:
                orientation_delta = 0
            else:
                orientation_delta = 2 - (i & 1)

            new_state[target] = old_state[killer]
            new_state[target + 20] = (old_state[killer + 20] + orientation_delta) % (2 + is_corner)
    return new_state

def inverse(move: int) -> int:
    """Calculates the inverse of a given move."""
    return move + 2 - 2 * (move % 3)

def id(state: ai) -> ai:
    """Calculates the ID of a given state based on the current phase."""
    global phase

    #--- Phase 1: Edge orientations.
    if phase < 2:
        return slice_to_ai(state[20:32])

    #-- Phase 2: Corner orientations, E slice edges.
    if phase < 3:
        result = state[31:40][:] # Copy the relevant slice
        for e in range(12):
            result[0] |= (state[e] // 8) << e
        return slice_to_ai(result)

    #--- Phase 3: Edge slices M and S, corner tetrads, overall parity.
    if phase < 4:
        result = [0, 0, 0]
        for e in range(12):
            temp = 2
            if state[e] <= 7:
                temp = state[e] & 1
            result[0] |= temp << (2 * e)
        for c in range(8):
            result[1] |= ((state[c + 12] - 12) & 5) << (3 * c)
        for i in range(12, 19):
            for j in range(i + 1, 20):
                result[2] ^= btoi(state[i] > state[j])
        return slice_to_ai(result)

    #--- Phase 4: The rest.
    return state

def main():
    """Main function to solve the cube."""
    global phase
    start_time = time.time()
    aggregate_moves = 0

    #--- Define the goal.
    goal = [
        "UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL",
        "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR",
    ]

    #--- Load dataset (file name should be passed as a command line argument).
    if len(sys.argv) != 2:
        print("the file name should be passed as a command line argument")
        sys.exit(1)

    try:
        with open(sys.argv[1], 'r') as file:
            lines = file.readlines()
    except FileNotFoundError:
        print(f"Error: File '{sys.argv[1]}' not found.")
        sys.exit(1)
    except Exception as e:
        print(f"Error: An error occurred while reading the file: {e}")
        sys.exit(1)

    line_count = 0
    for line in lines:
        inputs = line.strip().split()
        line_count += 1
        phase = 0
        total_moves = 0

        #--- Prepare current (start) and goal state.
        current_state: ai = [0] * 40
        goal_state: ai = [0] * 40
        for i in range(20):
            #--- Goal state.
            goal_state[i] = i

            #--- Current (start) state.
            cubie = inputs[i]
            current_state[i+20] = 0
            while True:
                idx = -1
                for c in range(len(goal)):
                    if goal[c] == cubie:
                        idx = c
                        break
                if idx >= 0:
                    current_state[i] = idx
                else:
                    current_state[i] = 20
                if current_state[i] != 20:
                    break
                cubie = cubie[1:] + cubie[:1]
                current_state[i+20] += 1
            current_state[i+20] %= (2 + (i > 11))
        #--- Dance the funky Thistlethwaite..
        phase = 0
        while phase < 4:
            phase += 1

            #--- Compute ids for current and goal state, skip phase if equal.
            current_id = id(current_state)
            goal_id = id(goal_state)
            if current_id == goal_id:
                continue

            #--- Initialize the BFS queue.
            q = [current_state[:], goal_state[:]]

            #--- Initialize the BFS tables.
            predecessor: dict[tuple[int], tuple[int]] = {}
            direction: dict[tuple[int], int] = {}
            last_move: dict[tuple[int], int] = {}
            direction[tuple(id(current_state))] = 1
            direction[tuple(id(goal_state))] = 2

            #--- Dance the funky bidirectional BFS...
            while q:
                #--- Get state from queue, compute its ID and get its direction.

                old_state = q.pop(0)
                old_id = tuple(id(old_state))  # needs to be hashable
                old_dir = direction[old_id]

                #--- Apply all applicable moves to it and handle the new state.
                for move in range(18):
                    if (applicable_moves[phase] & (1 << move)) != 0:
                        #--- Apply the move.
                        new_state = apply_move(move, old_state)
                        new_id = tuple(id(new_state))
                        new_dir = direction.get(new_id, 0)

                        #--- Have we seen this state (id) from the other direction already?
                        #--- I.e. have we found a connection?
                        if (new_dir != 0) and (new_dir != old_dir):
                            #--- Make oldId represent the forwards
                            #--- and newId the backwards search state.
                            if old_dir > 1:
                                new_id, old_id = old_id, new_id
                                move = inverse(move)

                            #--- Reconstruct the connecting algorithm.
                            algorithm = [move]
                            while old_id != tuple(id(current_state)):
                                algorithm.insert(0, last_move[old_id])
                                old_id = predecessor[old_id]
                            while new_id != tuple(id(goal_state)):
                                algorithm.append(inverse(last_move[new_id]))
                                new_id = predecessor[new_id]

                            #--- Print and apply the algorithm.
                            for i in range(len(algorithm)):
                                print("UDFBLR"[algorithm[i] // 3], algorithm[i] % 3 + 1, end=" ")
                                total_moves += 1
                                current_state = apply_move(algorithm[i], current_state)

                            #--- Jump to the next phase.
                            goto_next_phase = True
                            break
                else:
                    continue
                break  # inner loop break, goto the next phase.

            print(f" (moves {total_moves})")
            aggregate_moves += total_moves

    end_time = time.time()
    elapsed_time = (end_time - start_time) * 1000
    print("\nAverage number of moves =", aggregate_moves / line_count)
    print("\nAverage time =", elapsed_time / line_count, "milliseconds")

if __name__ == "__main__":
    main()
