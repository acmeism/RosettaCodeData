//-------------------------------------------------------------
// Advice                    : Functional design principles used in Rust:
//                           : - Pure functions (no side effects)
//                           : - Immutable values
//                           : - Clear separation between logic and I/O
//                           : - Small composable functions
//-------------------------------------------------------------


//-------------------------------------------------------------
// Pure function that returns the square of a number.
//-------------------------------------------------------------
fn square(number: u64) -> u64 {
    number * number
}

//-------------------------------------------------------------
// Pure function that computes the difference: n^2 - (n-1)^2
//-------------------------------------------------------------
fn square_difference(n: u64) -> u64 {
    square(n) - square(n - 1)
}

//-------------------------------------------------------------
// Checks whether the square difference is greater
// than a given limit.
//-------------------------------------------------------------
fn difference_greater_than_limit(n: u64, limit: u64) -> bool {
    square_difference(n) > limit
}

//-------------------------------------------------------------
// Pure function that finds the smallest positive integer
// satisfying the condition.
//
// This uses Rust's iterator system which fits
// well with functional programming.
//
// Steps:
// 1. Create an infinite sequence starting from 1
// 2. Filter numbers that satisfy the condition
// 3. Take the first one
//-------------------------------------------------------------
fn find_smallest_n(limit: u64) -> u64 {
    (1..)
        .find(|&n| difference_greater_than_limit(n, limit))
        .unwrap()
}

//-------------------------------------------------------------
// Program entry point.
// Handles I/O but delegates all calculations to pure functions.
//-------------------------------------------------------------
fn main() {
    let limit = 1000;
    let n = find_smallest_n(limit);
    let difference = square_difference(n);

    println!("Limit: {}", limit);
    println!("Smallest n: {}", n);
    println!("Square difference: {}", difference);
}

