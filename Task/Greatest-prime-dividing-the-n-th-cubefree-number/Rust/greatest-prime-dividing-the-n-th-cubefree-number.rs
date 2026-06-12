fn prime_factors(mut n: u32) -> Vec<u32> {
    let mut factors = Vec::new();

    while n % 2 == 0 {
        factors.push(2);
        n /= 2;
    }

    let mut i = 3;
    while i <= (n as f64).sqrt() as u32 {
        while n % i == 0 {
            factors.push(i);
            n /= i;
        }
        i += 2;
    }

    if n > 2 {
        factors.push(n);
    }

    factors
}

fn main() {
    const MAXIMUM: u32 = 10_000_000;
    let mut count = 1;
    let mut i = 2;
    const LOWER_LIMIT: u32 = 100;
    let mut upper_limit = 1000;
    let mut first_hundred = vec![1];

    while count < MAXIMUM {
        let factors = prime_factors(i);
        let mut cube_free = true;

        if factors.len() >= 3 {
            for j in 2..factors.len() {
                if factors[j - 2] == factors[j - 1] && factors[j - 1] == factors[j] {
                    cube_free = false;
                    break;
                }
            }
        }

        if cube_free {
            if count < LOWER_LIMIT {
                if let Some(&last_factor) = factors.last() {
                    first_hundred.push(last_factor);
                }
            }
            count += 1;

            if count == LOWER_LIMIT {
                println!("The first {} terms of a370833 are:", LOWER_LIMIT);
                for (idx, &term) in first_hundred.iter().enumerate() {
                    print!("{:3}", term);
                    if idx % 10 == 9 {
                        println!();
                    } else {
                        print!(" ");
                    }
                }
                println!();
            } else if count == upper_limit {
                if let Some(&last_factor) = factors.last() {
                    println!("The {}th term of a370833 is {}", count, last_factor);
                }
                upper_limit *= 10;
            }
        }

        i += 1;
    }
}
