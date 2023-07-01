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

fn is_left_truncatable(p: u32) -> bool {
    let mut n = 10;
    let mut q = p;
    while p > n {
        if !is_prime(p % n) || q == p % n {
            return false;
        }
        q = p % n;
        n *= 10;
    }
    true
}

fn is_right_truncatable(p: u32) -> bool {
    let mut q = p / 10;
    while q > 0 {
        if !is_prime(q) {
            return false;
        }
        q /= 10;
    }
    true
}

fn main() {
    let limit = 1000000;
    let mut largest_left = 0;
    let mut largest_right = 0;
    let mut p = limit;
    while p >= 2 {
        if is_prime(p) && is_left_truncatable(p) {
            largest_left = p;
            break;
        }
        p -= 1;
    }
    println!("Largest left truncatable prime is {}", largest_left);
    p = limit;
    while p >= 2 {
        if is_prime(p) && is_right_truncatable(p) {
            largest_right = p;
            break;
        }
        p -= 1;
    }
    println!("Largest right truncatable prime is {}", largest_right);
}
