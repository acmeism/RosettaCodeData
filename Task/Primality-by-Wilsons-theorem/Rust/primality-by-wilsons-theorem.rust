fn factorial_mod(mut n: u32, p: u32) -> u32 {
    let mut f = 1;
    while n != 0 && f != 0 {
        f = (f * n) % p;
        n -= 1;
    }
    f
}

fn is_prime(p: u32) -> bool {
    p > 1 && factorial_mod(p - 1, p) == p - 1
}

fn main() {
    println!("  n | prime?\n------------");
    for p in vec![2, 3, 9, 15, 29, 37, 47, 57, 67, 77, 87, 97, 237, 409, 659] {
        println!("{:>3} | {}", p, is_prime(p));
    }
    println!("\nFirst 120 primes by Wilson's theorem:");
    let mut n = 0;
    let mut p = 1;
    while n < 120 {
        if is_prime(p) {
            n += 1;
            print!("{:>3}{}", p, if n % 20 == 0 { '\n' } else { ' ' });
        }
        p += 1;
    }
    println!("\n1000th through 1015th primes:");
    let mut i = 0;
    while n < 1015 {
        if is_prime(p) {
            n += 1;
            if n >= 1000 {
                i += 1;
                print!("{:>3}{}", p, if i % 16 == 0 { '\n' } else { ' ' });
            }
        }
        p += 1;
    }
}
