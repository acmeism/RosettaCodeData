// Returns a vector containing the number of ways each possible sum of face
// values can occur.
fn get_totals(dice: usize, faces: usize) -> Vec<f64> {
    let mut result = vec![1.0; faces + 1];
    for d in 2..=dice {
        let mut tmp = vec![0.0; d * faces + 1];
        for i in d - 1..result.len() {
            for j in 1..=faces {
                tmp[i + j] += result[i];
            }
        }
        result = tmp;
    }
    result
}

fn probability(dice1: usize, faces1: usize, dice2: usize, faces2: usize) -> f64 {
    let totals1 = get_totals(dice1, faces1);
    let totals2 = get_totals(dice2, faces2);
    let mut wins = 0.0;
    let mut total = 0.0;
    for i in dice1..totals1.len() {
        for j in dice2..totals2.len() {
            let n = totals1[i] * totals2[j];
            total += n;
            if j < i {
                wins += n;
            }
        }
    }
    wins / total
}

fn main() {
    println!("{}", probability(9, 4, 6, 6));
    println!("{}", probability(5, 10, 6, 7));
}
