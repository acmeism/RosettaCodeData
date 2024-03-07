extern crate itertools;

use itertools::Itertools;

fn main() {
    const N: usize = 8;

    let permutations = (0..N).permutations(N);

    let solution_count = permutations
        .filter(|p| {
            let mut diag1 = [false; 2 * N - 1];
            let mut diag2 = [false; 2 * N - 1];

            for (i, &row) in p.iter().enumerate() {
                if diag1[row + i] || diag2[N - 1 + row - i] {
                    return false; // Queens mutual threat
                }

                diag1[row + i] = true;
                diag2[N - 1 + row - i] = true;
            }

            true // No Queens mutual threat
        })
        .count();

    println!("{}", solution_count);
}
