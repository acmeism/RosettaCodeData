// For random number generation
use rand::{RngExt, rngs::ThreadRng};
// For std::mem::swap
use std::mem;

// Equivalent to the C++ cSort class
struct CSort {
    sq: Vec<u32>, // The vector to be sorted (equivalent to vector<unsigned>)
    wr: u32,      // Write counter (equivalent to unsigned)
}

impl CSort {
    // Constructor (optional, but good practice)
    fn new() -> Self {
        CSort {
            sq: Vec::new(),
            wr: 0,
        }
    }

    // Equivalent to the doIt method
    // Takes ownership of the input vector 's'
    fn do_it(&mut self, s: Vec<u32>) {
        self.sq = s; // Move 's' into the struct's 'sq' field
        println!("Initial:");
        self.display();
        self.c_sort();
        println!("Writes: {}", self.wr);
        println!("Sorted:");
        self.display();
    }

    // Equivalent to the display method
    fn display(&self) {
        // Iterate and print elements with spaces
        for (i, &val) in self.sq.iter().enumerate() {
            if i > 0 {
                print!(" ");
            }
            print!("{}", val);
        }
        println!(); // Newline at the end
    }

    // Equivalent to the c_sort method (Cycle Sort implementation)
    fn c_sort(&mut self) {
        self.wr = 0;
        let vlen = self.sq.len();
        if vlen < 2 {
            return; // Nothing to sort for 0 or 1 elements
        }

        // Iterate through the vector to find cycles
        for c in 0..vlen - 1 {
            // The item to place correctly
            let mut item = self.sq[c];
            // Find the correct position 'p' for 'item'
            let mut p = c;
            for d in c + 1..vlen {
                if self.sq[d] < item {
                    p += 1;
                }
            }

            // If the item is already in its correct position, skip
            if p == c {
                continue;
            }

            // Skip duplicates -- find the first position *after* p
            // that doesn't contain the same item value.
            while p < vlen && self.sq[p] == item {
                p += 1;
                // Need to check bounds again if p potentially reached vlen
                if p == vlen {
                    // This case should ideally not happen if logic is correct
                    // but safety first. If it happens, it means all remaining elements
                    // were equal to item, but p should have been found earlier.
                    // Let's break or handle error - for now, just break loop for safety.
                    eprintln!("Warning: Unexpected condition p == vlen in duplicate check.");
                    // Re-evaluate if this break is the right recovery.
                    // It likely implies item should have stayed at c.
                    // Let's try continuing the outer loop instead.
                    continue; // Go to next c
                }
            }
            // If after handling duplicates, we end up back at the start,
            // it means all elements between c and the original p were duplicates.
            // The element at c is effectively in the right spot relative to non-duplicates.
            if p == c {
                // Added check after duplicate handling
                continue;
            }

            // Perform the swap: place 'item' into its correct position sq[p].
            // 'item' is updated with the value originally at sq[p].
            mem::swap(&mut item, &mut self.sq[p]);
            self.wr += 1;

            // Continue rotating the cycle until the element originally from index 'c'
            // is placed back at index 'c'.
            while p != c {
                // Find the correct position 'p' for the *new* 'item' (the one swapped out)
                p = c;
                for e in c + 1..vlen {
                    if self.sq[e] < item {
                        p += 1;
                    }
                }

                // Skip duplicates again for the current 'item'
                while p < vlen && self.sq[p] == item {
                    p += 1;
                    if p == vlen {
                        eprintln!(
                            "Warning: Unexpected condition p == vlen in cycle duplicate check."
                        );
                        // This likely means the cycle completed unexpectedly due to duplicates.
                        // The item should probably end up back at 'c' eventually.
                        // Let's break the inner while loop here, assuming cycle finished.
                        break; // Break while p != c loop
                    }
                }

                // Perform the swap, updating 'item' again
                // Check added to prevent infinite loop if p ended up >= vlen somehow
                if p < vlen {
                    mem::swap(&mut item, &mut self.sq[p]);
                    self.wr += 1;
                } else {
                    // Safety break if p went out of bounds, should not happen
                    eprintln!("Error: p {} out of bounds (len {})", p, vlen);
                    break; // Break while p != c loop
                }
            }
        }
    }
    // Note: The doSwap method is integrated into c_sort in this Rust version
    // because modifying the local 'item' variable directly with mem::swap is cleaner
    // than passing mutable references around complexly.
}

fn main() {
    let mut rng = ThreadRng::default();
    let mut s: Vec<u32> = Vec::new();

    // Generate random numbers (equivalent to C++ loop)
    for _ in 0..20 {
        // rand() % 100 + 21 -> range [21, 120] inclusive
        s.push(rng.random_range(21..=120));
    }

    // Create a CSort instance and run the sort
    let mut sorter = CSort::new();
    sorter.do_it(s); // s is moved into sorter here
}
