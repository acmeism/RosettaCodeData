// [dependencies]
// radix_fmt = "1.0"

fn is_prime(n: u64) -> bool {
    if n < 2 {
        return false;
    }
    if n % 2 == 0 {
        return n == 2;
    }
    if n % 3 == 0 {
        return n == 3;
    }
    let mut p: u64 = 5;
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

fn undulating_numbers(base: u64) -> impl std::iter::Iterator<Item = u64> {
    let mut a = 1;
    let mut b = 0;
    let mut digits = 3;
    std::iter::from_fn(move || {
        let mut n = 0;
        for d in 0..digits {
            n = n * base + if d % 2 == 0 { a } else { b };
        }
        b += 1;
        if a == b {
            b += 1;
        }
        if b == base {
            a += 1;
            b = 0;
            if a == base {
                a = 1;
                digits += 1;
            }
        }
        Some(n)
    })
}

fn undulating(base: u64) {
    let mut count = 0;
    let limit3 = base * base * base;
    let limit4 = base * limit3;
    let mut u3 = Vec::new();
    let mut u4 = Vec::new();
    let mut umax = 0;
    let mut u600 = 0;

    for n in undulating_numbers(base).take_while(|x| *x < 1u64 << 53) {
        if n < limit3 {
            u3.push(n);
        } else if n < limit4 {
            u4.push(n);
        }
        count += 1;
        umax = n;
        if count == 600 {
            u600 = n;
        }
    }

    println!("3-digit undulating numbers in base {}:", base);
    for (i, n) in u3.iter().enumerate() {
        print!("{:3}{}", n, if (i + 1) % 9 == 0 { '\n' } else { ' ' });
    }

    println!("\n4-digit undulating numbers in base {}:", base);
    for (i, n) in u4.iter().enumerate() {
        print!("{:4}{}", n, if (i + 1) % 9 == 0 { '\n' } else { ' ' });
    }

    println!(
        "\n3-digit undulating numbers in base {} which are prime:",
        base
    );
    for n in u3 {
        if is_prime(n) {
            print!("{} ", n);
        }
    }
    println!();

    print!("\nThe 600th undulating number in base {} is {}", base, u600);
    if base != 10 {
        print!(
            "\nor expressed in base {}: {}",
            base,
            radix_fmt::radix(u600, base as u8)
        );
    }
    println!(".");

    print!(
        "\nTotal number of undulating numbers < 2^53 in base {}: {}\nof which the largest is {}",
        base, count, umax
    );
    if base != 10 {
        print!(
            "\nor expressed in base {}: {}",
            base,
            radix_fmt::radix(umax, base as u8)
        );
    }
    println!(".");
}

fn main() {
    undulating(10);
    println!();
    undulating(7);
}
