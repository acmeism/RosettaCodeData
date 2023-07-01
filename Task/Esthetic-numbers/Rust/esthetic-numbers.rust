// [dependencies]
// radix_fmt = "1.0"

// Returns the next esthetic number in the given base after n, where n is an
// esthetic number in that base or one less than a power of base.
fn next_esthetic_number(base: u64, n: u64) -> u64 {
    if n + 1 < base {
        return n + 1;
    }
    let mut a = n / base;
    let mut b = a % base;
    if n % base + 1 == b && b + 1 < base {
        return n + 2;
    }
    a = next_esthetic_number(base, a);
    b = a % base;
    a * base + if b == 0 { 1 } else { b - 1 }
}

fn print_esthetic_numbers(min: u64, max: u64, numbers_per_line: usize) {
    let mut numbers = Vec::new();
    let mut n = next_esthetic_number(10, min - 1);
    while n <= max {
        numbers.push(n);
        n = next_esthetic_number(10, n);
    }
    let count = numbers.len();
    println!(
        "Esthetic numbers in base 10 between {} and {} ({}):",
        min, max, count
    );
    if count > 200 {
        for i in 0..numbers_per_line {
            if i != 0 {
                print!(" ");
            }
            print!("{}", numbers[i]);
        }
        println!("\n............\n");
        for i in 0..numbers_per_line {
            if i != 0 {
                print!(" ");
            }
            print!("{}", numbers[count - numbers_per_line + i]);
        }
        println!();
    } else {
        for i in 0..count {
            print!("{}", numbers[i]);
            if (i + 1) % numbers_per_line == 0 {
                println!();
            } else {
                print!(" ");
            }
        }
        if count % numbers_per_line != 0 {
            println!();
        }
    }
}

fn main() {
    for base in 2..=16 {
        let min = base * 4;
        let max = base * 6;
        println!(
            "Esthetic numbers in base {} from index {} through index {}:",
            base, min, max
        );
        let mut n = 0;
        for index in 1..=max {
            n = next_esthetic_number(base, n);
            if index >= min {
                print!("{} ", radix_fmt::radix(n, base as u8));
            }
        }
        println!("\n");
    }

    let mut min = 1000;
    let mut max = 9999;
    print_esthetic_numbers(min, max, 16);
    println!();

    min = 100000000;
    max = 130000000;
    print_esthetic_numbers(min, max, 8);
    println!();

    for i in 0..3 {
        min *= 1000;
        max *= 1000;
        let numbers_per_line = match i {
            0 => 7,
            1 => 5,
            _ => 4,
        };
        print_esthetic_numbers(min, max, numbers_per_line);
        println!();
    }
}
