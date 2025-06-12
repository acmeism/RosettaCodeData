use std::io;

type Matrix = Vec<Vec<usize>>;

fn dlist(n: usize, start: usize) -> Matrix {
    let mut a: Vec<usize> = (0..n).collect();
    a.swap(0, start - 1); // 1-based to 0-based index, swap start-1 with first element

    let first = a[1];

    let mut result = Vec::new();

    fn recurse(a: &mut Vec<usize>, last: usize, first: usize, result: &mut Matrix) {
        if last == 1 {
            // Test if it's a derangement
            for j in 1..a.len() {
                if a[j] == j {
                    return; // Not deranged
                }
            }

            // Convert back to 1-based indexing
            result.push(a.iter().map(|&v| v + 1).collect());
            return;
        }

        for i in (1..=last).rev() {
            a.swap(i, last);
            recurse(a, last - 1, first, result);
            a.swap(i, last);
        }
    }

    let mut a_clone = a.clone();
    recurse(&mut a_clone, n - 1, first, &mut result);
    result
}

fn print_square(latin: &Matrix) {
    for row in latin {
        print!("[");
        let len = row.len();
        for (i, val) in row.iter().enumerate() {
            if i != len - 1 {
                print!("{}, ", val);
            } else {
                print!("{}", val);
            }
        }
        println!("]");
    }
    println!();
}

fn reduced_latin_squares(n: usize, echo: bool) -> u64 {
    if n == 0 {
        if echo {
            println!("[]");
        }
        return 0;
    } else if n == 1 {
        if echo {
            println!("[1]");
        }
        return 1;
    }

    // Initialize the Latin square with indices
    let mut rlatin: Matrix = (0..n)
        .map(|i| (0..n).map(|j| j + 1).collect::<Vec<usize>>())
        .collect();

    // First row is 1 to n
    for j in 0..n {
        rlatin[0][j] = j + 1;
    }

    let mut count: u64 = 0;

    fn recurse(
        i: usize,
        rlatin: &mut Matrix,
        n: usize,
        echo: bool,
        count: &mut u64,
    ) {
        let rows = dlist(n, i);

        for row in &rows {
            rlatin[i - 1] = row.clone();

            let mut conflict = false;

            for k in 0..i - 1 {
                for j in 1..n {
                    if rlatin[k][j] == rlatin[i - 1][j] {
                        conflict = true;
                        break;
                    }
                }
                if conflict {
                    break;
                }
            }

            if !conflict {
                if i < n {
                    recurse(i + 1, rlatin, n, echo, count);
                } else {
                    *count += 1;
                    if echo {
                        print_square(rlatin);
                    }
                }
            }
        }
    }

    recurse(2, &mut rlatin, n, echo, &mut count);
    count
}

fn factorial(n: u64) -> u64 {
    (1..=n).product()
}

fn main() {
    println!("The four reduced Latin squares of order 4 are:\n");
    reduced_latin_squares(4, true);

    println!("The size of the set of reduced Latin squares for the following orders");
    println!("and hence the total number of Latin squares of these orders are:\n");

    for n in 1..7 {
        let size = reduced_latin_squares(n, false);
        let fact_n_1 = factorial((n - 1) as u64);
        let total = fact_n_1 * fact_n_1 * n as u64 * size;

        println!(
            "Order {}: Size {} x {}! x {}! => Total {}",
            n, size, n, n - 1, total
        );
    }
}
