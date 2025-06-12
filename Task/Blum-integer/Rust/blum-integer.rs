fn is_prime_mod4(n: u32) -> bool {
    match n {
        0..3 => false,
        _ if n % 2 == 0 => false,
        _ if n % 3 == 0 => n == 3,
        _ if n % 4 == 3 => {
            for d in (5..).step_by(2).take_while(|&d| d * d <= n) {
                if n % d == 0 {
                    return false;
                }
            }

            true
        }
        _ => false,
    }
}

fn least_prime_factor(n: u32) -> u32 {
    match n {
        1 => 1,
        _ if n % 3 == 0 => 3,
        _ if n % 5 == 0 => 5,
        _ => {
            for d in (7..).step_by(2).take_while(|&d| d * d <= n) {
                if n % d == 0 {
                    return d;
                }
            }

            n
        }
    }
}

fn blums() -> Blum {
    Blum { number: 1 }
}

struct Blum {
    number: u32,
}

impl Iterator for Blum {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        loop {
            let number = self.number;
            let p = least_prime_factor(number);

            self.number = number.checked_add(if number % 5 == 3 { 4 } else { 2 })?;

            if p % 4 == 3 {
                let q = number / p;

                if p != q && is_prime_mod4(q) {
                    return Some(number);
                }
            }
        }
    }
}

fn main() {
    println!("First 50 Blum integers:");

    let last_digit_counts = blums()
        .zip(1..=400_000)
        .inspect(|&(blum, i)| match i {
            1..=50 => print!("{blum:>3}{}", if i % 10 != 0 { " " } else { "\n" }),
            51 => println!(),
            26_828 | 100_000 | 200_000 | 300_000 | 400_000 => {
                println!("The {i:>6}th Blum integer is: {blum:>7}");
            }
            _ => {}
        })
        .fold([0; 10], |mut acc, (blum, _)| {
            acc[blum as usize % 10] += 1;

            acc
        });

    println!("\nPercent distribution of the first 400000 Blum integers:");
    for i in [1, 3, 7, 9] {
        println!(
            "\t{:2.3}% end in {i}",
            last_digit_counts[i] as f64 / 4_000.0
        );
    }
}
