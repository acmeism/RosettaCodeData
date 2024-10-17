// [dependencies]
// radix_fmt = "1.0"

fn digit_product(base: u32, mut n: u32) -> u32 {
    let mut product = 1;
    while n != 0 {
        product *= n % base;
        n /= base;
    }
    product
}

fn prime_factor_sum(mut n: u32) -> u32 {
    let mut sum = 0;
    while (n & 1) == 0 {
        sum += 2;
        n >>= 1;
    }
    let mut p = 3;
    while p * p <= n {
        while n % p == 0 {
            sum += p;
            n /= p;
        }
        p += 2;
    }
    if n > 1 {
        sum += n;
    }
    sum
}

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

fn is_rhonda(base: u32, n: u32) -> bool {
    digit_product(base, n) == base * prime_factor_sum(n)
}

fn main() {
    let limit = 15;
    for base in 2..=36 {
        if is_prime(base) {
            continue;
        }
        println!("First {} Rhonda numbers to base {}:", limit, base);
        let numbers: Vec<u32> = (1..).filter(|x| is_rhonda(base, *x)).take(limit).collect();
        print!("In base 10:");
        for n in &numbers {
            print!(" {}", n);
        }
        print!("\nIn base {}:", base);
        for n in &numbers {
            print!(" {}", radix_fmt::radix(*n, base as u8));
        }
        print!("\n\n");
    }
}
