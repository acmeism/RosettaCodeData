use primes::is_prime;

fn satisfy1(x: u64) -> bool {
    let upper_limit = (x as f64).sqrt() as u64 + 1;
    for i in 2..upper_limit {
        if is_prime(i) && is_prime(x - i) {
            return false;
        }
    }
    return true;
}

fn satisfy2(x: u64) -> bool {
    let mut once: bool = false;
    let upper_limit = (x as f64).sqrt() as u64 + 1;
    for i in 2..upper_limit {
        if x % i == 0 {
            let j = x / i;
            if 2 < j && j < 100 && satisfy1(i + j) {
                if once {
                    return false;
                }
                once = true;
            }
        }
    }
    return once
}

fn satisfyboth(x: u64) -> u64 {
    if !satisfy1(x) {
        return 0;
    }
    let mut found = 0;
    for i in 2..=(x/2) {
        if satisfy2(i * (x - i)) {
            if found > 0 {
                return 0;
            }
            found = i;
        }
    }
    return found;
}

fn main() {
    for i in 2..100 {
        let j = satisfyboth(i);
        if j > 0 {
            println!("Solution: ({}, {})", j, i - j);
        }
    }
}
