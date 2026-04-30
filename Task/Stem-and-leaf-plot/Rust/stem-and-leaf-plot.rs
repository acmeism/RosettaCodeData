//  ================================================================                          :
// Advice: Rust with a functional approach
//       : Treats single-digit numbers as having a leading zero (stem 0)
//       : Uses the last digit as the leaf
//       : Includes all stems from 0 to 14
//       : Uses a functional approach with pure functions
//       : Produces monospaced plain text output
//  ================================================================

use std::collections::BTreeMap;

// ================================================================
//  Mathematical Helper Functions (Pure)
// ================================================================

// Conceptually expands single digit numbers.
// Numerically unchanged, included for semantic clarity.
fn expand_number(n: u32) -> u32 {
    n
}

// Returns the stem (all but the last digit).
// Example: 127 -> 12
fn stem(n: u32) -> u32 {
    n / 10
}

// Returns the leaf (last digit).
// Example: 127 -> 7
fn leaf(n: u32) -> u32 {
    n % 10
}

// ================================================================
//  Data Transformation Layer (Pure Functional Pipeline)
// ================================================================

// Builds the stem-leaf structure.
// Returns a BTreeMap so stems are automatically sorted.
// Ensures stems 0..14 always exist.
fn build_stem_leaf(data: &[u32]) -> BTreeMap<u32, Vec<u32>> {
    // Step 1: Expand and sort the data
    let mut sorted: Vec<u32> = data.iter().map(|&n| expand_number(n)).collect();

    sorted.sort();

    // Step 2: Create all stems 0..14
    (0..=14)
        .map(|s| {
            // Collect and sort leaves belonging to this stem
            let mut leaves: Vec<u32> = sorted
                .iter()
                .filter(|&&n| stem(n) == s)
                .map(|&n| leaf(n))
                .collect();

            leaves.sort();

            (s, leaves)
        })
        .collect()
}

// ================================================================
//  Formatting Layer (Pure Rendering)
// ================================================================

// Formats a stem as two digits (leading zero if necessary).
// Example: 7 -> "07"
fn format_stem(s: u32) -> String {
    format!("{:02}", s)
}

// Formats leaves as space-separated digits.
// Example: [1,3,7] -> "1 3 7"
fn format_leaves(leaves: &[u32]) -> String {
    leaves
        .iter()
        .map(|l| l.to_string())
        .collect::<Vec<String>>()
        .join(" ")
}

// Renders the complete stem-and-leaf plot as multi-line string.
fn render_plot(stem_leaf: &BTreeMap<u32, Vec<u32>>) -> String {
    stem_leaf
        .iter()
        .map(|(s, leaves)| format!("{} | {}", format_stem(*s), format_leaves(leaves)))
        .collect::<Vec<String>>()
        .join("\n")
}

// ================================================================
//  Program Entry Point
// ================================================================

fn main() {
    // ------------------------------------------------------------
    // Raw Dataset
    // ------------------------------------------------------------
    let data: Vec<u32> = vec![
        12, 127, 28, 42, 39, 113, 42, 18, 44, 118, 44, 37, 113, 124, 37, 48, 127, 36, 29, 31, 125,
        139, 131, 115, 105, 132, 104, 123, 35, 113, 122, 42, 117, 119, 58, 109, 23, 105, 63, 27,
        44, 105, 99, 41, 128, 121, 116, 125, 32, 61, 37, 127, 29, 113, 121, 58, 114, 126, 53, 114,
        96, 25, 109, 7, 31, 141, 46, 13, 27, 43, 117, 116, 27, 7, 68, 40, 31, 115, 124, 42, 128,
        52, 71, 118, 117, 38, 27, 106, 33, 117, 116, 111, 40, 119, 47, 105, 57, 122, 109, 124, 115,
        43, 120, 43, 27, 27, 18, 28, 48, 125, 107, 114, 34, 133, 45, 120, 30, 127, 31, 116, 146,
    ];

    // ------------------------------------------------------------
    // Functional Processing Pipeline
    // ------------------------------------------------------------
    let stem_leaf_structure = build_stem_leaf(&data);
    let plot = render_plot(&stem_leaf_structure);

    // ------------------------------------------------------------
    // Output (Monospaced Plain Text)
    // ------------------------------------------------------------
    println!("{}", plot);
}
