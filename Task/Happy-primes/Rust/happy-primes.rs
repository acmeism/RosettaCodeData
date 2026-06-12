use primes::is_prime;

// Function to check if a number is happy.
fn is_happy(mut n: u64) -> bool {
    while n != 1 && n != 4 {
        let mut sum_sq_digits = 0;
        let s = n.to_string();
        for d_char in s.chars() {
            if d_char != '0' {
                if let Some(digit) = d_char.to_digit(10) {
                    sum_sq_digits += (digit as u64).pow(2);
                }
            }
        }
        n = sum_sq_digits;
    }
    return n == 1; // If we reach 4, it's not a happy number.
}

fn main() {
    println!("First fifty happy primes:");
    let mut happy_prime_nums_iter = (1..)
        .filter(|&x| is_happy(x) && is_prime(x));
    for i in 0..50 {
        if let Some(num) = happy_prime_nums_iter.next() {
            print!("{:4}", num);
            if (i + 1) % 10 == 0 {
                println!();
            } else {
                print!(" ");
            }
        }
    }

    println!("\n\nPrime\nFraction   Index     Value\n{}", "=".repeat(26));
    let mut idx = 1;
    let mut p_count = 0;
    let mut happy_numbers_iter = (2..).filter(|&n| is_happy(n));
    for d in 2..=15 {
        let mut n: u64;
        loop {
            idx += 1;
            n = happy_numbers_iter.next().expect("But happy numbers are infinite");
            if is_prime(n) {
                p_count += 1;
            }
            if (p_count as f64) / (idx as f64) <= 1.0 / (d as f64) {
                break;
            }
        }
        println!("1 / {d:<2}{idx:>10}{n:>10}");
    }
}
