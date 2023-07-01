fn is_prime(n: u32) -> bool {
    if n < 2 {
        return false;
    }
    if n % 2 == 0 {
        return n == 2;
    }
    if n % 3 == 0 {
        return n == 3;
    }
    let mut p = 5;
    while p * p <= n {
        if n % p == 0 {
            return false;
        }
        p += 2;
        if n % p == 0 {
            return false;
        }
        p += 4;
    }
    true
}

fn find_primes(from: u32, to: u32) -> Vec<u32> {
    let mut primes: Vec<u32> = Vec::new();
    for p in from..=to {
        if is_prime(p) {
            primes.push(p);
        }
    }
    primes
}

fn find_nsmooth_numbers(n: u32, count: usize) -> Vec<u128> {
    let primes = find_primes(2, n);
    let num_primes = primes.len();
    let mut result = Vec::with_capacity(count);
    let mut queue = Vec::with_capacity(num_primes);
    let mut index = Vec::with_capacity(num_primes);
    for i in 0..num_primes {
        index.push(0);
        queue.push(primes[i] as u128);
    }
    result.push(1);
    for i in 1..count {
        for p in 0..num_primes {
            if queue[p] == result[i - 1] {
                index[p] += 1;
                queue[p] = result[index[p]] * primes[p] as u128;
            }
        }
        let mut min_index: usize = 0;
        for p in 1..num_primes {
            if queue[min_index] > queue[p] {
                min_index = p;
            }
        }
        result.push(queue[min_index]);
    }
    result
}

fn print_nsmooth_numbers(n: u32, begin: usize, count: usize) {
    let numbers = find_nsmooth_numbers(n, begin + count);
    print!("{}: {}", n, &numbers[begin]);
    for i in 1..count {
        print!(", {}", &numbers[begin + i]);
    }
    println!();
}

fn main() {
    println!("First 25 n-smooth numbers for n = 2 -> 29:");
    for n in 2..=29 {
        if is_prime(n) {
            print_nsmooth_numbers(n, 0, 25);
        }
    }
    println!();
    println!("3 n-smooth numbers starting from 3000th for n = 3 -> 29:");
    for n in 3..=29 {
        if is_prime(n) {
            print_nsmooth_numbers(n, 2999, 3);
        }
    }
    println!();
    println!("20 n-smooth numbers starting from 30,000th for n = 503 -> 521:");
    for n in 503..=521 {
        if is_prime(n) {
            print_nsmooth_numbers(n, 29999, 20);
        }
    }
}
