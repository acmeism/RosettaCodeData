fn gcd(mut a: i32, mut b: i32) -> i32 {
    while b != 0 {
        let temp = b;
        b = a % b;
        a = temp;
    }
    a
}

fn duffinian(n: i32) -> bool {
    if n == 2 {
        return false;
    }

    let mut total = 1;
    let mut power = 2;
    let m = n;
    let mut n = n;

    // Handle powers of 2
    while (n & 1) == 0 {
        total += power;
        power <<= 1;
        n >>= 1;
    }

    // Handle odd prime factors
    let mut p = 3;
    while p * p <= n {
        let mut sum = 1;
        power = p;
        while n % p == 0 {
            sum += power;
            power *= p;
            n /= p;
        }
        total *= sum;
        p += 2;
    }

    // Check if n is composite
    if m == n {
        return false;
    }

    // Handle remaining prime factor
    if n > 1 {
        total *= n + 1;
    }

    gcd(total, m) == 1
}

fn main() {
    println!("First 50 Duffinian numbers:");
    let mut count = 0;
    let mut n = 1;

    while count < 50 {
        if duffinian(n) {
            print!("{:3}", n);
            count += 1;
            if count % 10 == 0 {
                println!();
            } else {
                print!(" ");
            }
        }
        n += 1;
    }

    println!("\nFirst 50 Duffinian triplets:");
    let mut n = 1;
    let mut m = 0;
    let mut count = 0;

    while count < 50 {
        if duffinian(n) {
            m += 1;
        } else {
            m = 0;
        }

        if m == 3 {
            let triplet = format!("({}, {}, {})", n - 2, n - 1, n);
            print!("{:<24}", triplet);
            count += 1;
            if count % 3 == 0 {
                println!();
            } else {
                print!(" ");
            }
        }
        n += 1;
    }
    println!();
}
