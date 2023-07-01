#![feature(inclusive_range_syntax)]

fn is_unique(a: u8, b: u8, c: u8, d: u8, e: u8, f: u8, g: u8) -> bool {
    a != b && a != c && a != d && a != e && a != f && a != g &&
    b != c && b != d && b != e && b != f && b != g &&
    c != d && c != e && c != f && c != g &&
    d != e && d != f && d != g &&
    e != f && e != g &&
    f != g
}

fn is_solution(a: u8, b: u8, c: u8, d: u8, e: u8, f: u8, g: u8) -> bool {
    a + b == b + c + d &&
        b + c + d == d + e + f &&
        d + e + f == f + g
}

fn four_squares(low: u8, high: u8, unique: bool) -> Vec<Vec<u8>> {
    let mut results: Vec<Vec<u8>> = Vec::new();

    for a in low..=high {
        for b in low..=high {
            for c in low..=high {
                for d in low..=high {
                    for e in low..=high {
                        for f in low..=high {
                            for g in low..=high {
                                if (!unique || is_unique(a, b, c, d, e, f, g)) &&
                                    is_solution(a, b, c, d, e, f, g) {
                                    results.push(vec![a, b, c, d, e, f, g]);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    results
}

fn print_results(solutions: &Vec<Vec<u8>>) {
    for solution in solutions {
        println!("{:?}", solution)
    }
}

fn print_results_summary(solutions: usize, low: u8, high: u8, unique: bool) {
    let uniqueness = if unique {
        "unique"
    } else {
        "non-unique"
    };
    println!("{} {} solutions in {} to {} range", solutions, uniqueness, low, high)
}

fn uniques(low: u8, high: u8) {
    let solutions = four_squares(low, high, true);
    print_results(&solutions);
    print_results_summary(solutions.len(), low, high, true);
}

fn nonuniques(low: u8, high: u8) {
    let solutions = four_squares(low, high, false);
    print_results_summary(solutions.len(), low, high, false);
}

fn main() {
    uniques(1, 7);
    println!();
    uniques(3, 9);
    println!();
    nonuniques(0, 9);
}
