fn list_prime_reciprocals(limit: i32) -> Vec<f64> {
    let half_limit = if limit % 2 == 0 { limit / 2 } else { 1 + limit / 2 };
    let mut composite = vec![false; half_limit as usize];

    for i in 1..half_limit as usize {
        let p = 3 + 2 * (i as i32 - 1);
        if !composite[i] {
            let mut a = i + p as usize;
            while a < half_limit as usize {
                composite[a] = true;
                a += p as usize;
            }
        }
    }

    let mut result = Vec::with_capacity(half_limit as usize);
    result.push(0.5); // Add 1/2 for prime number 2

    for i in 1..half_limit as usize {
        let p = 3 + 2 * (i as i32 - 1);
        if !composite[i] {
            result.push(1.0 / p as f64);
        }
    }

    result
}

fn main() {
    let prime_reciprocals = list_prime_reciprocals(100000000);
    let euler = 0.577215664901532861;

    let sum: f64 = prime_reciprocals.iter()
        .map(|&reciprocal| reciprocal + (1.0 - reciprocal).ln())
        .sum();

    let meissel_mertens = euler + sum;
    println!("The Meissel-Mertens constant = {:.8}", meissel_mertens);
}
