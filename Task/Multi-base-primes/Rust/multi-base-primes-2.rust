// [dependencies]
// primal = "0.3"

fn to_string(digits: &[usize]) -> String {
    const DIGITS: [char; 62] = [
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
        'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
        'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
    ];
    let mut str = String::new();
    for d in digits {
        str.push(DIGITS[*d]);
    }
    str
}

fn increment(digits: &mut [usize], base: usize) -> bool {
    for d in digits.iter_mut().rev() {
        if *d + 1 != base {
            *d += 1;
            return true;
        }
        *d = 0;
    }
    false
}

fn multi_base_primes(max_base: usize, max_length: usize) {
    let sieve = primal::Sieve::new(max_base.pow(max_length as u32));
    for length in 1..=max_length {
        let mut most_bases = 0;
        let mut max_strings = Vec::new();
        let mut digits = vec![0; length];
        digits[0] = 1;
        let mut bases = Vec::new();
        loop {
            let mut min_base = 2;
            if let Some(max) = digits.iter().max() {
                min_base = std::cmp::max(min_base, max + 1);
            }
            if most_bases <= max_base - min_base + 1 {
                bases.clear();
                for b in min_base..=max_base {
                    if max_base - b + 1 + bases.len() < most_bases {
                        break;
                    }
                    let mut n = 0;
                    for d in &digits {
                        n = n * b + d;
                    }
                    if sieve.is_prime(n) {
                        bases.push(b);
                    }
                }
                if bases.len() > most_bases {
                    most_bases = bases.len();
                    max_strings.clear();
                }
                if bases.len() == most_bases {
                    max_strings.push((digits.clone(), bases.clone()));
                }
            }
            if !increment(&mut digits, max_base) {
                break;
            }
        }
        println!(
            "{}-character strings which are prime in most bases: {}",
            length, most_bases
        );
        for (digits, bases) in max_strings {
            println!("{} -> {:?}", to_string(&digits), bases);
        }
        println!();
    }
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let mut max_base = 36;
    let mut max_length = 4;
    let mut arg = 0;
    while arg + 1 < args.len() {
        if args[arg] == "-max_base" {
            arg += 1;
            match args[arg].parse::<usize>() {
                Ok(n) => max_base = n,
                Err(error) => {
                    eprintln!("{}", error);
                    return;
                }
            }
        } else if args[arg] == "-max_length" {
            arg += 1;
            match args[arg].parse::<usize>() {
                Ok(n) => max_length = n,
                Err(error) => {
                    eprintln!("{}", error);
                    return;
                }
            }
        }
        arg += 1;
    }
    if max_base > 62 {
        eprintln!("Maximum base cannot be greater than 62.");
    } else if max_base < 2 {
        eprintln!("Maximum base cannot be less than 2.");
    } else {
        use std::time::Instant;
        let now = Instant::now();
        multi_base_primes(max_base, max_length);
        let time = now.elapsed();
        println!("elapsed time: {} milliseconds", time.as_millis());
    }
}
