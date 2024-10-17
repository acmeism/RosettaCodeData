fn modpow(mut base: usize, mut exp: usize, n: usize) -> usize {
    if n == 1 {
        return 0;
    }
    let mut result = 1;
    base %= n;
    while exp > 0 {
        if (exp & 1) == 1 {
            result = (result * base) % n;
        }
        base = (base * base) % n;
        exp >>= 1;
    }
    result
}

fn is_curzon(n: usize, k: usize) -> bool {
    let m = k * n + 1;
    modpow(k, n, m) + 1 == m

}

fn main() {
    for k in (2..=10).step_by(2) {
        println!("Curzon numbers with base {k}:");
        let mut count = 0;
        let mut n = 1;
        while count < 50 {
            if is_curzon(n, k) {
                count += 1;
                print!("{:4}{}", n, if count % 10 == 0 { "\n" } else { " " });
            }
            n += 1;
        }
        loop {
            if is_curzon(n, k) {
                count += 1;
                if count == 1000 {
                    break;
                }
            }
            n += 1;
        }
        println!("1000th Curzon number with base {k}: {n}\n");
    }
}
