fn ramanujan_maximum(number: i32) -> i32 {
    (4.0 * number as f64 * (4.0 * number as f64).ln()).ceil() as i32
}

fn initialise_prime_pi(limit: i32) -> Vec<i32> {
    let mut result = vec![1; limit as usize];
    result[0] = 0;
    result[1] = 0;

    // Mark even numbers as composite
    for i in (4..limit).step_by(2) {
        result[i as usize] = 0;
    }

    // Sieve of Eratosthenes for odd numbers
    let mut p = 3;
    let mut square = 9;
    while square < limit {
        if result[p as usize] != 0 {
            let mut q = square;
            while q < limit {
                result[q as usize] = 0;
                q += p << 1;
            }
        }
        square += (p + 1) << 2;
        p += 2;
    }

    // Convert to cumulative sum (prime counting function)
    for i in 1..result.len() {
        result[i] += result[i - 1];
    }

    result
}

fn ramanujan_prime(prime_pi: &[i32], number: i32) -> i32 {
    let mut maximum = ramanujan_maximum(number);
    if (maximum & 1) == 1 {
        maximum -= 1;
    }

    let mut index = maximum;
    while prime_pi[index as usize] - prime_pi[(index / 2) as usize] >= number {
        index -= 1;
    }
    index + 1
}

fn list_primes_less_than(limit: i32) -> Vec<i32> {
    let mut composite = vec![false; limit as usize];
    let mut n = 3;
    let mut n_squared = 9;

    while n_squared <= limit {
        if !composite[n as usize] {
            let mut k = n_squared;
            while k < limit {
                composite[k as usize] = true;
                k += 2 * n;
            }
        }
        n_squared += (n + 1) << 2;
        n += 2;
    }

    let mut result = Vec::new();
    result.push(2);
    for i in (3..limit).step_by(2) {
        if !composite[i as usize] {
            result.push(i);
        }
    }

    result
}

fn main() {
    const LIMIT: i32 = 1_000_000;
    let prime_pi = initialise_prime_pi(ramanujan_maximum(LIMIT) + 1);
    let millionth_ramanujan_prime = ramanujan_prime(&prime_pi, LIMIT);
    println!("The 1,000,000th Ramanujan prime is {}", millionth_ramanujan_prime);

    let primes = list_primes_less_than(millionth_ramanujan_prime);
    let mut ramanujan_prime_indexes: Vec<i32> = primes
        .iter()
        .map(|&p| prime_pi[p as usize] - prime_pi[(p / 2) as usize])
        .collect();

    // Filter ramanujan prime indexes to keep only strictly decreasing values
    let mut lower_limit = ramanujan_prime_indexes[ramanujan_prime_indexes.len() - 1];
    for i in (0..ramanujan_prime_indexes.len() - 1).rev() {
        if ramanujan_prime_indexes[i] < lower_limit {
            lower_limit = ramanujan_prime_indexes[i];
        } else {
            ramanujan_prime_indexes[i] = 0;
        }
    }

    // Collect the actual Ramanujan primes
    let ramanujan_primes: Vec<i32> = primes
        .iter()
        .enumerate()
        .filter_map(|(i, &prime)| {
            if ramanujan_prime_indexes[i] != 0 {
                Some(prime)
            } else {
                None
            }
        })
        .collect();

    // Count twin primes
    let twins_count = ramanujan_primes
        .windows(2)
        .filter(|pair| pair[0] + 2 == pair[1])
        .count();

    println!("There are {} twins in the first {} Ramanujan primes.", twins_count, LIMIT);
}
