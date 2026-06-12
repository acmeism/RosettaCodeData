#!/usr/bin/env node

/**********************************************************************
 *
 * A cube 'state' is an array <number> with 40 entries, the first 20
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

const fs = require('fs');

// Helper to serialize array keys for Map usage
const serialize = (arr) => arr.join(',');
// Helper for boolean to int conversion (less verbose)
const boolToInt = (b) => b ? 1 : 0;

// Note: AI (ArrayList<Int>) is just Array<number> in JS

const applicableMoves = [0, 262143, 259263, 74943, 74898];

const affectedCubies = [
    [0,  1, 2,  3, 0, 1, 2, 3],  // U
    [4,  7, 6,  5, 4, 5, 6, 7],  // D
    [0,  9, 4,  8, 0, 3, 5, 4],  // F
    [2, 10, 6, 11, 2, 1, 7, 6],  // B
    [3, 11, 7,  9, 3, 2, 6, 5],  // L
    [1,  8, 5, 10, 1, 0, 4, 7]   // R
];

function applyMove(move, state) {
    const state2 = [...state]; // Create a copy to avoid mutating original 'state'.
    let turns = move % 3 + 1;
    const face = Math.floor(move / 3);

    while (turns-- !== 0) {
        const oldState2 = [...state2]; // Copy state for this turn application
        for (let i = 0; i < 8; i++) {
            const isCorner = boolToInt(i > 3);
            const target = affectedCubies[face][i] + isCorner * 12;
            const temp = (i & 3) === 3 ? i - 3 : i + 1; // Equivalent to Kotlin's logic
            const killer = affectedCubies[face][temp] + isCorner * 12;

            let orientationDelta = 0;
            if (i < 4) { // Edge
                orientationDelta = boolToInt(face >= 2 && face <= 3); // F or B face affects edge orientation
            } else if (face >= 2) { // Corner on F, B, L, R face
                 orientationDelta = 2 - (i & 1); // Corners on F/B/L/R need orientation change based on position
            } // else: Corner on U/D face -> orientationDelta = 0

            state2[target] = oldState2[killer];
            state2[target + 20] = oldState2[killer + 20] + orientationDelta;

            if (turns === 0) { // Apply modulo only on the final state of the move
                state2[target + 20] %= (2 + isCorner); // Mod 2 for edges, Mod 3 for corners
            }
        }
    }
    return state2;
}

function inverse(move) {
    return move + 2 - 2 * (move % 3);
}

let phase = 0; // Global phase variable

function id(state) {
    //--- Phase 1: Edge orientations.
    if (phase < 2) {
        // Slice creates a new array [20, 32) -> indices 20 to 31
        return state.slice(20, 32);
    }

    //-- Phase 2: Corner orientations, E slice edges.
    if (phase < 3) {
        // Get corner orientations (indices 32 to 39)
        const result = state.slice(32, 40); // Corner orientations [0..7]
        // Add space for the E slice edge info
        result.unshift(0); // result now has 9 elements, result[0] holds E slice info

        for (let e = 0; e < 12; e++) {
             // Check if edge 'e' is in the E slice (pieces 8, 9, 10, 11)
             // state[e] contains the *piece number* at position 'e'
             // Math.floor(state[e] / 8) is 1 if piece is 8,9,10,11, otherwise 0
            result[0] |= Math.floor(state[e] / 8) << e;
        }
        return result; // Array of 9 numbers
    }

    //--- Phase 3: Edge slices M and S, corner tetrads, overall parity.
    if (phase < 4) {
        const result = [0, 0, 0]; // Initialize with 3 zeros

        // M and S slices edge info
        for (let e = 0; e < 12; e++) {
             // state[e] > 7 means edge piece is 8,9,10,11 (E slice) -> value 2
             // else check if piece is odd (1,3,5,7) -> value 1
             // else piece is even (0,2,4,6) -> value 0
             // Map {0,2,4,6} -> 0, {1,3,5,7} -> 1, {8,9,10,11} -> 2
            const sliceMembership = (state[e] > 7) ? 2 : (state[e] & 1);
            result[0] |= sliceMembership << (2 * e); // Store 2 bits per edge
        }

        // Corner tetrads info
        for (let c = 0; c < 8; c++) {
            // (state[c + 12] - 12) gives the corner piece number (0-7) relative to goal state
            // & 5 (binary 101) extracts bits 0 and 2. This likely encodes tetrad membership.
            const cornerInfo = (state[c + 12] - 12) & 5;
            result[1] |= cornerInfo << (3 * c); // Store 3 bits per corner
        }

        // Overall parity (permutation parity of corners + edges)
        for (let i = 12; i < 20; i++) { // Check corners first (12-19)
            for (let j = i + 1; j < 20; j++) {
                result[2] ^= boolToInt(state[i] > state[j]);
            }
        }
         for (let i = 0; i < 12; i++) { // Then check edges (0-11) - Note: Kotlin code only checked corners 12-19? Let's stick to Kotlin version.
             // The Kotlin code only iterates i=12..18 and j=i+1..19. This calculates corner permutation parity.
             // Let's match Kotlin exactly:
             // result[2] = 0; // Re-initialize if we were adding edge parity
             // for (let i = 12; i < 20; i++) { // Corrected loop bounds based on Kotlin code
             //    for (let j = i + 1; j < 20; j++) {
             //        result[2] ^= boolToInt(state[i] > state[j]);
             //    }
             // }
             // Wait, the Kotlin code *did* iterate 12..19. i <= 18 means i goes up to 18. j <= 19 means j goes up to 19.
             // The original nested loop `for (i in 12..18) { for (j in (i + 1)..19) {` is correct for checking pairs (12,13)..(12,19), (13,14)..(13,19) ... (18,19)
             // So the JS translation above `for (let i = 12; i < 20; i++)` was correct. Let's keep it.
        }
        // Thistlethwaite doesn't usually calculate full parity until phase 4, maybe this `result[2]` captures something else or just corner parity.
        // Based on common Thistlethwaite implementations, this often represents combined M/S slice + corner parity.

        return result; // Array of 3 numbers
    }

    //--- Phase 4: The rest. (ID is the full state)
    return state; // Return the full state array (40 numbers)
}

function main() {
    const startTime = Date.now();
    let aggregateMoves = 0;
    let lineCount = 0;

    //--- Define the goal cubie names.
    const goal = [
        "UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL",
        "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR"
    ];

    //--- Load dataset (file name should be passed as a command line argument).
    const filename = process.argv[2];
    if (!filename) {
        console.error("Usage: node script.js <filename>");
        process.exit(1);
    }

    let fileContent;
    try {
        fileContent = fs.readFileSync(filename, 'utf8');
    } catch (err) {
        console.error(`Error reading file: ${filename}`, err);
        process.exit(1);
    }

    const lines = fileContent.split('\n').filter(line => line.trim() !== ''); // Split lines and remove empty ones

    lines.forEach(line => {
        const inputs = line.trim().split(/\s+/); // Split by whitespace
        if (inputs.length < 20) {
            console.warn(`Skipping malformed line: ${line}`);
            return; // Skip lines that don't have enough cubies
        }
        lineCount++;
        phase = 0; // Reset phase for each puzzle
        let totalMoves = 0;

        //--- Prepare current (start) and goal state.
        let currentState = Array(40).fill(0);
        const goalState = Array(40).fill(0);

        for (let i = 0; i < 20; i++) {
            //--- Goal state.
            goalState[i] = i; // Piece 'i' is at position 'i', orientation 0

            //--- Current (start) state.
            let cubie = inputs[i];
            let orientation = 0;
            let positionIndex = -1;

            // Find the piece and its orientation by rotating the input string
            for (let tries = 0; tries < 3; tries++) { // Max 3 rotations needed
                 positionIndex = goal.indexOf(cubie);
                 if (positionIndex !== -1) {
                     break; // Found the piece
                 }
                 // Rotate cubie string (e.g., "ULF" -> "LFU" -> "FUL")
                 cubie = cubie.substring(1) + cubie[0];
                 orientation++;
            }

            if (positionIndex === -1) {
                 console.error(`Error: Could not find cubie '${inputs[i]}' in goal definition.`);
                 // Handle error appropriately, maybe skip this line or exit
                 currentState[i] = 20; // Mark as invalid/unknown?
            } else {
                currentState[i] = positionIndex; // Set permutation
                currentState[i + 20] = orientation; // Set orientation
            }
        }

        //--- Dance the funky Thistlethwaite...
        nextPhase: // Label for continuing outer loop
        while (++phase < 5) {
            //--- Compute ids for current and goal state, skip phase if equal.
            const currentIdArr = id(currentState);
            const goalIdArr = id(goalState);

            // Serialize IDs for comparison and map keys
            const currentId = serialize(currentIdArr);
            const goalId = serialize(goalIdArr);

            if (currentId === goalId) {
                 // console.log(`Phase ${phase}: Already solved.`); // Optional debug log
                continue nextPhase;
            }

            //--- Initialize the BFS queue.
            // Queue stores full states [stateArray]
            const q = [currentState, goalState];

            //--- Initialize the BFS tables. Keys are *serialized* IDs (strings).
            // Map<string, string> : serializedId -> serializedPredecessorId
            const predecessor = new Map();
            // Map<string, number> : serializedId -> direction (1=forward, 2=backward)
            const direction = new Map();
             // Map<string, number> : serializedId -> move leading to this state
            const lastMove = new Map();

            direction.set(currentId, 1);
            direction.set(goalId, 2);
            // Predecessor and lastMove for starting points are not needed

            //--- Dance the funky bidirectional BFS...
            searchLoop: // Label for breaking inner search loop
            while (q.length > 0) {
                //--- Get state from queue, compute its ID and get its direction.
                const oldState = q.shift(); // Dequeue
                if (!oldState) break; // Should not happen if q.length > 0, but safety check

                const oldIdArr = id(oldState);
                const oldId = serialize(oldIdArr);
                // We know the direction exists because we only add states with directions set
                const oldDir = direction.get(oldId);

                //--- Apply all applicable moves to it and handle the new state.
                for (let move = 0; move < 18; move++) {
                    // Check if the move is allowed in this phase
                    if ((applicableMoves[phase] & (1 << move)) !== 0) {

                        //--- Apply the move.
                        const newState = applyMove(move, oldState);
                        const newIdArr = id(newState);
                        const newId = serialize(newIdArr);
                        const newDir = direction.get(newId); // Check if seen before

                        //--- Have we seen this state (id) from the other direction already?
                        //--- I.e. have we found a connection?
                        if (newDir !== undefined && newDir !== oldDir) {
                            let meetingMove = move;
                            let forwardId = oldId;
                            let backwardId = newId;

                            //--- Make oldId represent the forwards (dir=1)
                            //--- and newId the backwards (dir=2) search state.
                            if (oldDir === 2) { // oldState came from the goal search
                                forwardId = newId;
                                backwardId = oldId;
                                meetingMove = inverse(move); // The move needs to be inverted
                            }

                            //--- Reconstruct the connecting algorithm.
                            const algorithm = [];

                            // Trace back from the meeting point on the forward path
                            let currentTraceId = forwardId;
                            while (currentTraceId !== currentId) {
                                const moveApplied = lastMove.get(currentTraceId);
                                if (moveApplied === undefined) {
                                    console.error("Error reconstructing forward path! Missing move.");
                                    break searchLoop; // Abort search for this puzzle
                                }
                                algorithm.unshift(moveApplied); // Add to beginning
                                const predId = predecessor.get(currentTraceId);
                                 if (predId === undefined) {
                                    console.error("Error reconstructing forward path! Missing predecessor.");
                                    break searchLoop; // Abort search for this puzzle
                                }
                                currentTraceId = predId;
                            }

                            // Add the meeting move
                            algorithm.push(meetingMove);

                            // Trace back from the meeting point on the backward path (inverting moves)
                            currentTraceId = backwardId;
                             while (currentTraceId !== goalId) {
                                const moveApplied = lastMove.get(currentTraceId);
                                if (moveApplied === undefined) {
                                    console.error("Error reconstructing backward path! Missing move.");
                                    break searchLoop; // Abort search for this puzzle
                                }
                                algorithm.push(inverse(moveApplied)); // Add inverted move to end
                                const predId = predecessor.get(currentTraceId);
                                 if (predId === undefined) {
                                    console.error("Error reconstructing backward path! Missing predecessor.");
                                    break searchLoop; // Abort search for this puzzle
                                }
                                currentTraceId = predId;
                            }


                            //--- Print and apply the algorithm.
                            for (let i = 0; i < algorithm.length; i++) {
                                const currentMove = algorithm[i];
                                process.stdout.write("UDFBLR"[Math.floor(currentMove / 3)]);
                                process.stdout.write((currentMove % 3 + 1).toString());
                                process.stdout.write(" ");
                                totalMoves++;
                                currentState = applyMove(currentMove, currentState);
                            }

                            //--- Jump to the next phase.
                            continue nextPhase; // Continue the outer 'phase' loop
                        }

                        //--- If we've never seen this state (id) before, visit it.
                        if (newDir === undefined) {
                            q.push(newState); // Enqueue the full state
                            direction.set(newId, oldDir);
                            lastMove.set(newId, move);
                            predecessor.set(newId, oldId); // Store the *serialized* predecessor ID
                        }
                    } // end if applicable move
                } // end for move
            } // end while q.length > 0 (BFS loop)
            // If the queue becomes empty and we haven't found a solution, something is wrong.
             console.error(`Phase ${phase} BFS failed to find a connection for line: ${line}`);
             break; // Break out of phase loop for this puzzle

        } // end while phase < 5

        console.log(` (moves ${totalMoves})`);
        aggregateMoves += totalMoves;
    }); // end forEach line

    const elapsedTime = Date.now() - startTime;
    if (lineCount > 0) {
        console.log(`\nAverage number of moves = ${aggregateMoves / lineCount}`);
        console.log(`Average time = ${elapsedTime / lineCount} milliseconds`);
    } else {
        console.log("\nNo valid lines processed.");
    }
}

// Run the main function
main();
