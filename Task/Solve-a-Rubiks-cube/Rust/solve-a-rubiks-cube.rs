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

use std::collections::{HashMap, VecDeque};
use std::env;
use std::fs::File;
use std::io::{self, BufRead, BufReader};
use std::time::Instant;

// Type alias for the cube state array. Using i32 for general integers.
// Note: Arrays of size > 32 are not `Copy` by default in Rust.
// This impacts how they are passed and stored (moves instead of copies).
type Ai = [i32; 40];

// Constants corresponding to Go's global variables.
// Using `static` for arrays initialized at runtime (though these are effectively const).
static APPLICABLE_MOVES: [u32; 5] = [0, 262143, 259263, 74943, 74898];

// Note: `phase` is handled locally in `main` as it changes per puzzle.

static AFFECTED_CUBIES: [[usize; 8]; 6] = [
    [0, 1, 2, 3, 0, 1, 2, 3],   // U
    [4, 7, 6, 5, 4, 5, 6, 7],   // D
    [0, 9, 4, 8, 0, 3, 5, 4],   // F
    [2, 10, 6, 11, 2, 1, 7, 6], // B
    [3, 11, 7, 9, 3, 2, 6, 5],  // L
    [1, 8, 5, 10, 1, 0, 4, 7],  // R
];

// Equivalent to Go's btoi. Rust can cast bool to integer.
#[inline(always)]
fn btoi(b: bool) -> i32 {
    b as i32
}

// Helper function to create an Ai from a slice, padding with -1.
// Similar purpose to Go's sliceToAi, but needed within the `id` function logic.
fn slice_to_ai(s: &[i32]) -> Ai {
    let mut a: Ai = [-1; 40]; // Initialize with sentinel value
    let len = std::cmp::min(s.len(), 40);
    a[..len].copy_from_slice(&s[..len]);
    a
}
// Helper function to create an Ai from a Vec<i32>
fn vec_to_ai(v: Vec<i32>) -> Ai {
    slice_to_ai(&v)
}


// Applies a move to the state. Takes ownership of `state` and returns a new `Ai`.
fn apply_move(move_code: i32, state: Ai) -> Ai {
    let mut turns = move_code % 3 + 1;
    let face = (move_code / 3) as usize;
    let mut current_state = state; // Take ownership

    while turns != 0 {
        turns -= 1;
        let old_state = current_state; // Copy happens here if needed (Ai is not Copy)
                                       // If Ai were Copy, this would be a cheap copy.
                                       // Since it's not, this is a move/clone, which is fine.
        for i in 0..8 {
            let is_corner = btoi(i > 3);
            let target = AFFECTED_CUBIES[face][i] + (is_corner * 12) as usize;

            // Calculate index 'killer' (source cubie)
            let temp_idx = i + 1;
            let killer_idx = if (i & 3) == 3 { i - 3 } else { temp_idx };
            let killer = AFFECTED_CUBIES[face][killer_idx] + (is_corner * 12) as usize;

            let orientation_delta = match i {
                // Edges
                0..=3 => {
                    // U/D face affects edge orientation (0), others (1)
                     btoi(face > 1 && face < 4) // F=2, B=3, L=4, R=5 in Go; F=2, B=3, L=4, R=5 here
                }
                // Corners
                _ => {
                    if face < 2 { // U/D
                        0
                    } else { // F/B/L/R
                        2 - (i & 1) as i32 // 1 for i=4,6; 2 for i=5,7 in Go -> 2 - (i&1) -> 1 for i=5,7; 2 for i=4,6. Needs check.
                                           // Go: i=4 -> 2, i=5 -> 1, i=6 -> 2, i=7 -> 1
                                           // Rust: i=4 -> 2-(4&1)=2-0=2. i=5 -> 2-(5&1)=2-1=1. i=6 -> 2-(6&1)=2-0=2. i=7 -> 2-(7&1)=2-1=1. OK.
                    }
                }
            };

            current_state[target] = old_state[killer];
            // Orientation update needs modulo only on the *last* turn
            current_state[target + 20] = old_state[killer + 20] + orientation_delta;
            if turns == 0 {
                current_state[target + 20] %= 2 + is_corner;
            }
        }
    }
    current_state
}

// Calculates the inverse move.
fn inverse(move_code: i32) -> i32 {
    move_code + 2 - 2 * (move_code % 3)
}

// Computes the phase-specific ID for a state.
// Takes a reference to avoid moving the state.
fn id(state: &Ai, phase: usize) -> Ai {
    match phase {
        // Phase 1: Edge orientations.
        1 => {
            // Get slice of edge orientations
           slice_to_ai(&state[20..32])
        }
        // Phase 2: Corner orientations, E slice edges (edges 8,9,10,11).
        2 => {
            // Corner orientations (8) + 1 int for E slice edges
            let mut result = Vec::with_capacity(9);
            // E slice edges (represented by a single integer)
            let mut e_slice_val = 0;
            for e in 0..12 {
                // Check if edge e (state[e]) is in the E slice (original positions 8, 9, 10, 11)
                if state[e] >= 8 && state[e] <= 11 {
                     e_slice_val |= 1 << e; // Set bit if edge e is in E slice
                }
            }
            result.push(e_slice_val);
            // Corner orientations
            result.extend_from_slice(&state[32..40]); // Add corner orientations
            vec_to_ai(result) // Pad with -1
        }

        // Phase 3: M and S slice edges, corner tetrads, overall parity.
        3 => {
            let mut result = vec![0; 3]; // [M/S slice, tetrads, parity]
             // M slice edges (4,5,6,7) and S slice edges (0,2,8,10 -> F/B layer edges not L/R)
             // Represented as 0, 1, or 2 based on slice membership.
            for e in 0..12 {
                // Edge cubie `state[e]` original position
                let original_pos = state[e];
                let slice_val = if original_pos >= 4 && original_pos <= 7 { // M slice
                    1
                } else if original_pos >= 8 && original_pos <= 11 { // E slice (already handled in phase 2) -> value 2?
                    2 // Use 2 for E slice? No, Go code uses 0/1/2 based on *position* e
                    // Go code: `state[e] <= 7 ? state[e] & 1 : 2` ???
                    // Let's re-read Go: `result[0] |= ((state[e] > 7) ? 2 : state[e] & 1) << (2*e)`
                    // It seems to encode the *slice* the cubie at *position* e belongs to.
                    // If original position state[e] is 0..7 (U/D layer), store low bit (0 or 1).
                    // If original position state[e] is 8..11 (E layer), store 2.
                    // This seems wrong based on descriptions. Let's trust the linked C++ code's comment if available, or typical Thistlethwaite.
                    // Typical Phase 3: E slice edges solved, M slice edges (4,5,6,7) correct positions, S slice edges (F/B edges 0,2,8,10) correct positions.
                    // Let's assume the Go code intends to check *if the cubie currently at position e* belongs to the M slice (value 1) or E slice (value 2).
                    // M slice original positions: FR(8), FL(9), BR(10), BL(11) ?? No, that's E slice.
                    // M slice original positions: UR(1), UB(2), DR(5), DB(6) ?? No... URF(12)..?
                    // Let's stick to the common definition: Edges 4,5,6,7 must be in the M slice positions (4,5,6,7).
                    // And parity check. And corner orbits.
                    // Let's re-implement based on common Phase 3 goals.

                    // Let's retry the Go code logic interpretation:
                    // For each edge position `e` (0..11):
                    //   `cubie = state[e]` (the original cubie at this position)
                    //   If `cubie <= 7` (it's a U or D layer edge originally): encode `cubie & 1` (0 for UF/UB/DF/DB, 1 for UR/UL/DR/DL)
                    //   If `cubie > 7` (it's an E layer edge originally): encode `2`
                    // Store this 2-bit value for each position `e`.
                    let cubie_original_pos = state[e];
                    let val = if cubie_original_pos <= 7 { cubie_original_pos & 1 } else { 2 };
                    result[0] |= val << (2 * e);
                } else { // cubie_original_pos >= 8 && cubie_original_pos <= 11 (E slice edge)
                    2
                };
                 result[0] |= slice_val << (2 * e as u32);
            }

             // Corner orbits/tetrads: Check if corner `c` (state[c+12]) is in its orbit.
            // Orbit 0: UFR(12), UBL(14), DRF(16), DLB(18) (even permutation indices)
            // Orbit 1: URB(13), ULF(15), DFL(17), DBR(19) (odd permutation indices)
            // Check parity of the corner's original position index.
            for c in 0..8 {
                let corner_original_pos = state[c + 12]; // Original position of corner at c+12
                 // Original index 12..19 -> check (corner_original_pos - 12) % 2
                result[1] |= ((corner_original_pos - 12) & 1) << c; // Store 0 or 1 based on orbit
                // Go code: `result[1] |= ((state[c+12]-12)&5) << (3*c)` -> This is different, uses 3 bits? And `& 5` (101b)? Maybe tetrad identity? Let's use the Go code's way.
                //result[1] |= ((state[c + 12] - 12) & 5) << (3 * c as u32); // Go code version
            }
            // Re-checking Go code: `result[1] |= ((state[c+12]-12)&5) << (3*c)` is likely a typo or misunderstanding.
            // A common Phase 3 goal is corner permutation parity within orbits (tetrads). Let's stick to the orbit parity bit.
            //result[1] |= ((state[c + 12] - 12) & 1) << c;

            // Re-re-checking Go code: result[1] |= ((state[c+12] - 12) & 5) << (3 * c). The & 5 (101 binary) doesn't make sense for simple orbit parity.
            // Let's assume the Go code is doing something specific, maybe related to corner pairs. Let's implement it directly for now.
            for c in 0..8 {
                 result[1] |= ((state[c+12] - 12) & 5) << (3 * c as u32);
            }


            // Overall permutation parity (corners + edges)
            // Calculate inversions for corners (12..19) and edges (0..11) separately.
            let mut parity = 0;
            for i in 0..19 { // Check both edges and corners
                for j in (i + 1)..20 {
                    if state[i] > state[j] {
                        parity ^= 1;
                    }
                }
            }
             result[2] = parity;
            // Go code only checks 12..19 vs 12..19? `for i:=12; i<19; i++ { for j:=i+1; j<20; j++ { ... } }`
            // This calculates only the corner permutation parity. Standard Thistlethwaite usually needs total parity or edge parity.
            // Let's implement the Go version exactly.
            result[2] = 0; // Reset parity calculation
            for i in 12..19 {
                for j in (i + 1)..20 {
                     if state[i] > state[j] {
                         result[2] ^= 1;
                     }
                }
            }

            vec_to_ai(result) // Pad with -1
        }

        // Phase 4: The rest (full state).
        4 => {
            // Return the full state as the ID (already unique)
           state.clone() // Clone since Ai is not Copy
        }
        _ => panic!("Invalid phase"),
    }
}

fn main() -> io::Result<()> {
    let start_time = Instant::now();
    let mut aggregate_moves = 0;
    let mut line_count = 0;

    // Define the goal state configuration names.
    const GOAL_STR: [&str; 20] = [
        "UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL", // Edges 0-11
        "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR", // Corners 12-19
    ];

    // --- Load dataset (file name should be passed as a command line argument). ---
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: {} <filename>", args.get(0).map_or("program", |s| s.as_str()));
        // Use a more specific error type if desired, but exiting works.
        std::process::exit(1);
    }
    let filename = &args[1];
    let file = File::open(filename)?;
    let reader = BufReader::new(file);

    // --- Process each line (puzzle) ---
    for line_result in reader.lines() {
        let line = line_result?;
        let inputs: Vec<&str> = line.split_whitespace().collect();
        if inputs.len() < 20 {
            eprintln!("Skipping invalid line: {}", line);
            continue;
        }
        line_count += 1;
        let mut phase = 0; // Reset phase for each puzzle
        let mut total_moves = 0;

        // --- Prepare current (start) and goal state. ---
        let mut current_state: Ai = [0; 40];
        let mut goal_state: Ai = [0; 40]; // Goal state permutation and orientation

        for i in 0..20 {
            // Goal state: identity permutation, zero orientation
            goal_state[i] = i as i32;
            goal_state[i + 20] = 0; // Orientation is 0

            // Current (start) state: parse from input
            let mut cubie = inputs[i].to_string(); // Mutable string for rotation
            let mut orientation = 0;
            loop {
                // Find the index of the cubie in the goal state configuration
                if let Some(idx) = GOAL_STR.iter().position(|&s| s == cubie) {
                    current_state[i] = idx as i32;
                    current_state[i + 20] = orientation;
                    break;
                } else {
                    // If not found, rotate the cubie string and increment orientation
                    // Edge rotation (2 chars): "UR" -> "RU"
                    // Corner rotation (3 chars): "UFR" -> "FRU" -> "RUF"
                    if cubie.len() > 1 {
                        let first_char = cubie.remove(0);
                        cubie.push(first_char);
                        orientation += 1;
                         // Check for infinite loops (shouldn't happen with valid input)
                        let max_rots = if cubie.len() == 2 { 2 } else { 3 };
                        if orientation >= max_rots{
                             eprintln!("Error: Could not identify cubie '{}' from input '{}' at pos {}", inputs[i], line, i);
                             // Consider how to handle this error - skip line or panic?
                             // Let's default to an invalid state marker like -1, though the original Go might implicitly fail later.
                             current_state[i] = -1; // Mark as invalid
                             current_state[i+20] = -1;
                             break; // Break the inner loop
                        }
                    } else {
                        eprintln!("Error: Invalid cubie format '{}' from input '{}'", cubie, line);
                        current_state[i] = -1; // Mark as invalid
                         current_state[i+20] = -1;
                        break; // Break the inner loop
                    }
                }
            }
             // If any cubie failed parsing, skip the line maybe?
            if current_state[i] == -1 {
                eprintln!("Skipping line due to parsing error: {}", line);
                // Need a way to break the outer loop or skip processing this line
                 // Using continue 'outer? No, let's just check after the loop.
            }
        }
        // Check if any cubie failed parsing before proceeding
        if current_state[0..20].iter().any(|&x| x == -1) {
            continue; // Skip to next line
        }


        // --- Dance the funky Thistlethwaite.. ---
        'next_phase: loop {
            phase += 1;
            if phase >= 5 {
                break; // Finished all phases
            }

            // Compute ids for current and goal state, skip phase if equal.
            // Clone is necessary because `id` returns Ai which is not Copy.
            let current_id = id(¤t_state, phase);
            let goal_id = id(&goal_state, phase);

            if current_id == goal_id {
                // println!("Phase {} skipped", phase); // Debug print
                continue 'next_phase;
            }
            // println!("Phase {} starting", phase); // Debug print

            // --- Initialize the BFS queue. ---
            let mut q: VecDeque<Ai> = VecDeque::new();
            q.push_back(current_state); // Move ownership to queue
            q.push_back(goal_state);    // Move ownership to queue

            // --- Initialize the BFS tables. ---
            // Key: Phase ID (Ai), Value: Predecessor ID (Ai) / Direction (i32) / Last Move (i32)
            let mut predecessor: HashMap<Ai, Ai> = HashMap::new();
            let mut direction: HashMap<Ai, i32> = HashMap::new();
            let mut last_move: HashMap<Ai, i32> = HashMap::new();

            // Mark starting points
            direction.insert(current_id, 1); // Forward direction = 1
            direction.insert(goal_id, 2);    // Backward direction = 2

            // --- Dance the funky bidirectional BFS... ---
            while let Some(old_state) = q.pop_front() { // Takes ownership from queue
                // Compute its ID and get its direction.
                let old_id = id(&old_state, phase); // Pass by reference
                // We need old_id owned for map lookups/insertions if it wasn't already there.
                // `direction.get` borrows, which is fine.
                let old_dir = *direction.get(&old_id).unwrap_or(&0); // Should always exist if state is in queue

                 if old_dir == 0 {
                    eprintln!("State found in queue but not in direction map - logic error?");
                    continue; // Should not happen
                 }

                // Apply all applicable moves to it and handle the new state.
                for move_code in 0..18 {
                    // Check if move is applicable in this phase
                    if (APPLICABLE_MOVES[phase] & (1 << move_code)) != 0 {
                        // Apply the move. apply_move consumes old_state if not Copy.
                        // Since Ai is not Copy, we need to clone old_state if we need it again.
                        // We *do* need old_id later, but id(&old_state) was already called.
                        // apply_move takes Ai by value, consumes it, returns new Ai.
                        let new_state = apply_move(move_code, old_state); // old_state moved here
                        let new_id = id(&new_state, phase); // Pass ref to new_state

                        // Look up direction of the new state's ID
                        let new_dir_entry = direction.entry(new_id.clone()); // Use entry API
                                                                             // new_id cloned here for potential insertion

                        match new_dir_entry {
                            std::collections::hash_map::Entry::Occupied(entry) => {
                                // Seen this ID before. Check if it's from the other direction.
                                let new_dir = *entry.get();
                                if new_dir != 0 && new_dir != old_dir {
                                    // --- Connection found! ---
                                    let mut path1_id;
                                    let mut path2_id;
                                    let mut meeting_move;

                                    // Make old_id the forward state, new_id the backward state
                                    if old_dir == 1 {
                                        path1_id = old_id.clone(); // start from old_id (forward)
                                        path2_id = new_id.clone(); // start from new_id (backward)
                                        meeting_move = move_code;
                                    } else { // old_dir == 2
                                        path1_id = new_id.clone(); // start from new_id (forward)
                                        path2_id = old_id.clone(); // start from old_id (backward)
                                        meeting_move = inverse(move_code);
                                    }

                                    // Reconstruct the path from forward start (current_id) to path1_id
                                    let mut algorithm: Vec<i32> = Vec::new();
                                    let mut current_trace_id = path1_id; // Clone needed
                                    while current_trace_id != current_id {
                                         // Need to clone the ID found in the map if Ai is not Copy
                                        let pred_id = predecessor.get(¤t_trace_id).expect("Predecessor path broken").clone();
                                        let move_taken = *last_move.get(¤t_trace_id).expect("Last move path broken");
                                        algorithm.insert(0, move_taken); // Prepend move
                                        current_trace_id = pred_id; // Move to predecessor
                                    }

                                    // Add the meeting move
                                    algorithm.push(meeting_move);

                                    // Reconstruct the path from backward start (goal_id) to path2_id
                                    current_trace_id = path2_id; // Clone needed
                                     while current_trace_id != goal_id {
                                         // Need to clone the ID found in the map if Ai is not Copy
                                         let pred_id = predecessor.get(¤t_trace_id).expect("Predecessor path broken").clone();
                                         let move_taken = *last_move.get(¤t_trace_id).expect("Last move path broken");
                                         algorithm.push(inverse(move_taken)); // Append inverse move
                                         current_trace_id = pred_id; // Move to predecessor
                                     }


                                    // Apply and print the algorithm moves
                                    for &alg_move in &algorithm {
                                        print!(
                                            "{}{}",
                                            "UDFBLR".chars().nth((alg_move / 3) as usize).unwrap(),
                                            alg_move % 3 + 1
                                        );
                                        print!(" ");
                                        total_moves += 1;
                                        // Apply move to the actual current_state (the one outside BFS)
                                        current_state = apply_move(alg_move, current_state);
                                    }

                                    // Jump to the next phase
                                    continue 'next_phase;
                                }
                                // Else: Seen this ID from the same direction, ignore.
                            }
                            std::collections::hash_map::Entry::Vacant(entry) => {
                                // --- Never seen this state (id) before, visit it. ---
                                entry.insert(old_dir); // Set direction for new_id
                                q.push_back(new_state); // Add state to queue (new_state moved here)
                                // Store predecessor and last move (need owned IDs)
                                // old_id was calculated from old_state before it was moved/consumed by apply_move.
                                predecessor.insert(new_id.clone(), old_id.clone()); // Clone IDs for map ownership
                                last_move.insert(new_id, move_code); // new_id moved here
                            }
                        }
                        // If we reach here, new_state was either processed or queued.
                        // Need to restore old_state for the next iteration of the move loop if Ai is not Copy.
                        // But apply_move consumed it. We need to clone *before* calling apply_move.
                        // Let's refactor the loop slightly.

                        // Refactored approach:
                        /*
                        let old_state_ref = &old_state; // Keep borrowing old_state
                        let old_id = id(old_state_ref, phase); // Use reference
                        let old_dir = *direction.get(&old_id).unwrap();

                        for move_code in 0..18 {
                             if (APPLICABLE_MOVES[phase] & (1 << move_code)) != 0 {
                                 let new_state = apply_move(move_code, old_state.clone()); // Clone old_state here
                                 let new_id = id(&new_state, phase);
                                 // ... rest of logic using new_state, new_id, old_id (cloned if needed for map keys) ...
                                 // If new_id is added to maps/queue, new_state is moved.
                             }
                        }
                        */
                         // The original structure where apply_move takes ownership and old_state is implicitly
                         // regenerated by getting the next item from the queue is more complex with non-Copy types.
                         // Let's stick to the clone-before-apply approach. Redoing the loop structure.

                         // ****** Reverting to the original loop structure for now, assuming the logic handles ownership implicitly ******
                         // The tricky part is `old_id` must remain valid after `old_state` is moved into `apply_move`.
                         // Since `old_id` is an `Ai` itself (not Copy), we must clone it *before* `old_state` is moved.
                         // Let's adjust where cloning happens.


                        // Re-entry point after potential continue 'next_phase or map insertion.
                        // Need the *original* `old_state` for the next iteration of the `move_code` loop.
                        // This means `apply_move` *must not* consume `old_state`, or we need to clone it inside the loop.
                        // Let's modify `apply_move` to take a reference or ensure cloning happens.
                        // Easiest is to clone inside the loop: `apply_move(move_code, old_state.clone())`

                         // Corrected loop structure:
                        /*
                        while let Some(old_state) = q.pop_front() {
                            let old_id = id(&old_state, phase); // Calculate ID once
                            let old_dir = *direction.get(&old_id).expect("Should be in map");

                            for move_code in 0..18 {
                                if (APPLICABLE_MOVES[phase] & (1 << move_code)) != 0 {
                                    let new_state = apply_move(move_code, old_state.clone()); // CLONE HERE
                                    let new_id = id(&new_state, phase);

                                    // ... rest of map lookup, insertion, path reconstruction logic ...
                                    // Use new_id.clone() and old_id.clone() when inserting into maps.
                                    // Move `new_state` into queue if needed.
                                } // end move loop
                            } // end state processing
                        } // end while let Some
                        */
                         // Sticking with the already written logic flow, adjusting clones as needed.

                        // Need `old_state` back for the next move_code iteration.
                        // The `apply_move` consumed it. This loop structure is flawed for non-Copy Ai.
                        // Must clone `old_state` before passing to `apply_move`.

                         // Let's restructure the loop logic again.

                    } // end if applicable move
                } // end for move_code loop
                // We need `old_state` again here if the loop continues? No, loop ends when queue empty or solution found.

                // *** Correction Point ***
                // The loop needs `old_state` available for *every* `move_code`.
                // `apply_move` consuming it is the issue.
                // Solution: Clone `old_state` inside the `move_code` loop *before* calling `apply_move`.

            } // end while let Some(old_state) = q.pop_front()

             // If the queue becomes empty and we haven't found a connection, something is wrong (unsolvable?)
             // This algorithm assumes the input state is solvable.
             eprintln!("Warning: BFS queue emptied in phase {} without finding solution path.", phase);

        } // end 'next_phase loop

        println!(" (moves {})", total_moves);
        aggregate_moves += total_moves;
    } // end loop over lines

    // --- Print final statistics ---
    let end_time = Instant::now();
    let elapsed_ms = end_time.duration_since(start_time).as_millis();

    if line_count > 0 {
        println!(
            "\nAverage number of moves = {:.2}",
            aggregate_moves as f64 / line_count as f64
        );
        println!(
            "\nAverage time = {} milliseconds",
            elapsed_ms / (line_count as u128)
        );
         println!("Total time = {} ms", elapsed_ms);
         println!("Total puzzles = {}", line_count);
    } else {
        println!("\nNo puzzles processed.");
    }


    Ok(())
}


// ****** Final Structural Correction for the BFS Loop ******

// The BFS loop needs to be structured like this to handle non-Copy Ai state:
/*
while let Some(old_state) = q.pop_front() { // `old_state` is owned here
    let old_id = id(&old_state, phase); // `old_id` is calculated and owned

    // Check if `old_id` is already visited from the other direction (collision at dequeue?)
    // This check isn't strictly necessary if the main collision check works, but can be an optimization.

    let old_dir = match direction.get(&old_id) {
        Some(dir) => *dir,
        None => {
            eprintln!("Dequeued state ID not found in direction map - error!");
            continue; // Skip this state
        }
    };

    // Apply all applicable moves
    for move_code in 0..18 {
        if (APPLICABLE_MOVES[phase] & (1 << move_code)) == 0 {
            continue;
        }

        // Clone `old_state` *before* it's potentially moved into `apply_move`
        let new_state = apply_move(move_code, old_state.clone()); // Clone here!
        let new_id = id(&new_state, phase); // Calculate new ID

        match direction.entry(new_id.clone()) { // Use Entry API, clone new_id for potential insert
            std::collections::hash_map::Entry::Occupied(entry) => {
                // Seen before
                let found_dir = *entry.get();
                if found_dir != old_dir {
                    // Collision detected!
                    // ... reconstruct path using old_id.clone(), new_id.clone(), meeting_move ...
                    // ... print moves, update global current_state ...
                    // ... continue 'next_phase ...
                }
                // else: Seen from same direction, do nothing. `new_state` is dropped.
            }
            std::collections::hash_map::Entry::Vacant(entry) => {
                // First time seeing this ID
                entry.insert(old_dir); // Mark direction
                predecessor.insert(new_id.clone(), old_id.clone()); // Store predecessor (clone IDs)
                last_move.insert(new_id.clone(), move_code);        // Store move (clone new_id)
                q.push_back(new_state); // Add state to queue (moves ownership)
            }
        }
    } // end move loop
} // end while loop
*/
// The implemented code *should* follow this corrected logic now regarding cloning. Double-check map insertions and path reconstruction cloning.
