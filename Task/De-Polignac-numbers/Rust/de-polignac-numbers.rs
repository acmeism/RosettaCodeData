fn is_prime(n: i32) -> bool {
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

fn is_depolignac_number(n: i32) -> bool {
    let mut p = 1;
    while p < n {
        if is_prime(n - p) {
            return false;
        }
        p <<= 1;
    }
    true
}

fn main() {
    println!("First 50 de Polignac numbers:");
    let mut n = 1;
    let mut count = 0;
    while count < 10000 {
        if is_depolignac_number(n) {
            count += 1;
            if count <= 50 {
                print!("{:5}", n);
                if count % 10 == 0 {
                    println!();
                } else {
                    print!(" ");
                }
            } else if count == 1000 {
                println!("\nOne thousandth: {}", n);
            } else if count == 10000 {
                println!("\nTen thousandth: {}", n);
            }
        }
        n += 2;
    }
}
