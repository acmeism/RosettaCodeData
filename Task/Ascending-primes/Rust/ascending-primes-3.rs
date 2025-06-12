/// Primality test by trial division.
///
/// This algorithm avoids using hardware `div`s for 0-24 and from then on only checks with odd
/// factors that aren't themselves divisible by 3 up until √n
fn is_prime(n: u32) -> bool {
    match n {
        0 | 1 => false,
        _ if n % 2 == 0 => n == 2,
        _ if n % 3 == 0 => n == 3,
        _ => {
            let mut factor = 5;
            while factor * factor <= n {
                if n % factor == 0 {
                    return false;
                }
                factor += 2;
                if n % factor == 0 {
                    return false;
                }
                factor += 4;
            }

            true
        }
    }
}

fn main() {
    let mut ps1 = powerset_from_recursion();
    let ps2 = powerset_from_queue();

    ps1.sort();

    assert_eq!(ps1, ps2);

    println!("There are {} ascending primes.", ps2.len());
    for row in ps2.chunks(10) {
        for col in row {
            print!("{:>9} ", col);
        }
        println!();
    }
}
