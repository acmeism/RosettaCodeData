use std::io::{self, Write}; // Import Write trait for flush

const DX: [i32; 8] = [-2, -2,  2, 2, -3, 3,  0, 0];
const DY: [i32; 8] = [-2,  2, -2, 2,  0, 0, -3, 3];

// Equivalent to C++ 'node' struct
#[derive(Clone, Copy, Debug, Default)]
struct Node {
    val: i32,       // -1 for obstacle, 0 for empty, >0 for number
    neighbors: u8, // Bitmask of valid moves (indices into DX/DY)
}

// Equivalent to C++ 'nSolver' class
struct NSolver {
    wid: usize,
    hei: usize,
    max_val: i32, // The highest number to place (number of non-obstacle cells)
    arr: Vec<Node>,
}

impl NSolver {
    // Main function to set up and run the solver
    // Modifies the input 'puzz' vector in place
    pub fn solve_puzzle(puzz: &mut Vec<String>, max_wid: usize) {
        if puzz.is_empty() {
            return;
        }

        let wid = max_wid;
        if wid == 0 {
             eprintln!("Error: Width cannot be zero.");
             return;
        }
        let hei = puzz.len() / wid;
        if hei * wid != puzz.len() {
             eprintln!("Error: Puzzle size ({}) must be a multiple of width ({}).", puzz.len(), wid);
             return;
        }

        let len = wid * hei;

        // --- START FIX ---
        // Create a record of which cells were originally "." BEFORE creating the solver/modifying arr
        let was_originally_dot: Vec<bool> = puzz.iter().map(|s| s == ".").collect();
        // --- END FIX ---

        let mut arr = vec![Node::default(); len];
        let mut max_val = 0; // Count non-obstacle cells

        // Initialize 'arr' based on the initial 'puzz' state
        for (c, item) in puzz.iter().enumerate() {
             if c >= len { break; } // Should not happen with the size check above, but safe

             // Match the C++ logic: '*' is obstacle (-1), others are parsed or default to 0.
             // Count non-obstacles towards the max value to be filled.
             if item == "*" {
                 arr[c].val = -1;
             } else {
                 // atoi returns 0 for non-numeric strings like ".".
                 arr[c].val = item.parse::<i32>().unwrap_or(0);
                 max_val += 1;
             }
        }

        // Check if there's anything to solve
        if max_val == 0 {
            println!("\nNo valid cells to fill (all obstacles?).");
            return; // Nothing to solve
        }

        let mut solver = NSolver {
            wid,
            hei,
            max_val,
            arr,
        };

        // Find start and solve
        solver.solve_it();

        // Update the original puzz vector with results
        // Now use the 'was_originally_dot' vector for the check
        for (c, item) in puzz.iter_mut().enumerate() {
             if c >= solver.arr.len() { break; } // Safety break

             // --- Use the pre-calculated boolean ---
             if was_originally_dot[c] {
                 let node_val = solver.arr[c].val;
                 // Only update if the solver actually put a positive number there?
                 // C++ seems to update with whatever is in arr[c] (could be 0 if not reached).
                 // Let's stick to that behavior.
                 if node_val >= 0 { // Avoid writing "-1" into a "." cell
                     *item = node_val.to_string();
                 } else {
                     // If for some reason the solver put -1 here, leave it as "."?
                     // This case seems unlikely if logic is correct.
                      eprintln!("Warning: Obstacle value (-1) found at index {} which was originally '.'", c);
                      *item = ".".to_string(); // Keep it as dot? Or maybe solver.arr[c].val.to_string()?
                 }

             }
             // Cells that were not originally "." remain unchanged.
        }
    }

    // Internal function to orchestrate the solving process

    fn solve_it(&mut self) {
        match self.find_start() {
            Some((x, y, start_val)) => {
                if !self.search(x, y, start_val + 1) {
                    println!("\nSearch failed to find a complete path from start ({}, {}). Board may be partially filled.", x, y);
                }
                // else: Search succeeded, board is filled (or should be)
            }
            None => {
                // Check if already solved (no zeros found) or impossible
                let has_zero = self.arr.iter().any(|node| node.val == 0);
                 if !has_zero && self.max_val > 0 {
                     // This case could happen if the input already contained a partial or full solution
                     // and find_start requires a 0 to begin.
                     println!("\nPuzzle seems pre-filled or already solved. No empty cell (0) found to start search.");
                 } else if self.max_val > 0 {
                    // This means find_start iterated through all cells and none were 0.
                    // Could happen if the board is all obstacles, or already fully numbered.
                    println!("\nCan't find start point (an empty cell with value 0)! Check input puzzle.");
                 }
                 // The max_val == 0 case is handled earlier in solve_puzzle
            }
        }
    }

    // Find the first empty cell (value 0), set it to 1, and return its info
    fn find_start(&mut self) -> Option<(usize, usize, i32)> {
        for y in 0..self.hei {
            for x in 0..self.wid {
                let index = x + y * self.wid;
                // Ensure we don't try to access out of bounds if arr size is wrong
                if index < self.arr.len() && self.arr[index].val == 0 {
                    self.arr[index].val = 1; // Set start value to 1
                    return Some((x, y, 1)); // Return coords and the value assigned (1)
                }
            }
        }
        None // No cell with value 0 found
    }

    // Recursive backtracking search function
    fn search(&mut self, x: usize, y: usize, w: i32) -> bool {
        if w > self.max_val {
            return true; // Successfully placed all numbers
        }

        let current_index = x + y * self.wid;
        // Calculate and store neighbors for the current node
        self.arr[current_index].neighbors = self.get_neighbors(x, y);
        let neighbors_mask = self.arr[current_index].neighbors;

        for d in 0..8 { // Iterate through 8 possible moves
            if (neighbors_mask & (1 << d)) != 0 { // Check if the d-th neighbor is valid
                let next_x_i32 = (x as i32) + DX[d];
                let next_y_i32 = (y as i32) + DY[d];

                // Bounds check (redundant if get_neighbors is correct, but safe)
                if next_x_i32 >= 0 && next_x_i32 < self.wid as i32 &&
                   next_y_i32 >= 0 && next_y_i32 < self.hei as i32
                {
                    let next_x = next_x_i32 as usize;
                    let next_y = next_y_i32 as usize;
                    let next_index = next_x + next_y * self.wid;

                    // Check bounds on arr access too
                    if next_index < self.arr.len() && self.arr[next_index].val == 0 {
                        self.arr[next_index].val = w; // Place the next number

                        if self.search(next_x, next_y, w + 1) { // Recurse
                            return true; // Found a valid path
                        }

                        // Backtrack: If the recursive call failed, undo the move
                        // Check index before backtracking write too
                         if next_index < self.arr.len() {
                            self.arr[next_index].val = 0;
                         }
                    }
                }
            }
        }
        false // If no neighbor leads to a solution
    }

    // Calculate the neighbor bitmask for a given cell (x, y)
    fn get_neighbors(&self, x: usize, y: usize) -> u8 {
        let mut c = 0u8;
        for d in 0..8 { // Check all 8 potential moves
            let nx_i32 = (x as i32) + DX[d];
            let ny_i32 = (y as i32) + DY[d];

            // Check bounds
            if nx_i32 >= 0 && nx_i32 < self.wid as i32 &&
               ny_i32 >= 0 && ny_i32 < self.hei as i32
            {
                let index = (nx_i32 as usize) + (ny_i32 as usize) * self.wid;
                // Check bounds on arr access
                if index < self.arr.len() && self.arr[index].val > -1 { // Check not obstacle
                    c |= 1 << d; // Set the d-th bit
                }
            }
        }
        c
    }
} // end impl NSolver




fn main() {
    let p = "* . . * . . * . . . . . . . . . . . . . . * . . . . . * * * . . . * * * * * . * * *";
    let wid = 7;

    let mut puzz: Vec<String> = p.split_whitespace().map(String::from).collect();

    NSolver::solve_puzzle(&mut puzz, wid);

    println!("Solved Puzzle:");
    for (c, item) in puzz.iter().enumerate() {
        match item.as_str() {
            "*" => print!("   "), // Obstacle
            "." => print!(" . "), // Unfilled cell
             _ => {
                match item.parse::<i32>() {
                    Ok(n) => {
                         // Handle 0 specifically - it means a '.' cell wasn't reached by the solver
                         if n == 0 {
                             print!(" . ");
                         } else if n < 10 {
                             print!("0{} ", n); // Pad single digits
                         } else {
                             print!("{} ", n);
                         }
                    }
                    Err(_) => { // Should ideally not happen if we only write numbers or "." back
                        print!(" ? ");
                    }
                }
            }
        }
        if (c + 1) % wid == 0 {
            println!();
        }
    }
    println!("\n");

    println!("Press Enter to exit...");
    let _ = io::stdout().flush();
    let mut buffer = String::new();
    io::stdin().read_line(&mut buffer).expect("Failed to read line");
}
