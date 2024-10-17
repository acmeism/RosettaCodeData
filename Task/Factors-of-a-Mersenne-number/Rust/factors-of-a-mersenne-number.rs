fn bit_count(mut n: usize) -> usize {
    let mut count = 0;
    while n > 0 {
        n >>= 1;
        count += 1;
    }
    count
}

fn mod_pow(p: usize, n: usize) -> usize {
    let mut square = 1;
    let mut bits = bit_count(p);
    while bits > 0 {
        square = square * square;
        bits -= 1;
        if (p & (1 << bits)) != 0 {
            square <<= 1;
        }
        square %= n;
    }
    return square;
}

fn is_prime(n: usize) -> bool {
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

fn find_mersenne_factor(p: usize) -> usize {
    let mut k = 0;
    loop {
        k += 1;
        let q = 2 * k * p + 1;
        if q % 8 == 1 || q % 8 == 7 {
            if mod_pow(p, q) == 1 && is_prime(p) {
                return q;
            }
        }
    }
}

fn main() {
    println!("{}", find_mersenne_factor(929));
}
