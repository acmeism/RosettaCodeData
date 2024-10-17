fn square_free(mut n: usize) -> bool {
    if n & 3 == 0 {
        return false;
    }
    let mut p: usize = 3;
    while p * p <= n {
        let mut count = 0;
        while n % p == 0 {
            count += 1;
            if count > 1 {
                return false;
            }
            n /= p;
        }
        p += 2;
    }
    true
}

fn print_square_free_numbers(from: usize, to: usize) {
    println!("Square-free numbers between {} and {}:", from, to);
    let mut line = String::new();
    for i in from..=to {
        if square_free(i) {
            if !line.is_empty() {
                line.push_str(" ");
            }
            line.push_str(&i.to_string());
            if line.len() >= 80 {
                println!("{}", line);
                line.clear();
            }
        }
    }
    if !line.is_empty() {
        println!("{}", line);
    }
}

fn print_square_free_count(from: usize, to: usize) {
    let mut count = 0;
    for i in from..=to {
        if square_free(i) {
            count += 1;
        }
    }
    println!(
        "Number of square-free numbers between {} and {}: {}",
        from, to, count
    )
}

fn main() {
    print_square_free_numbers(1, 145);
    print_square_free_numbers(1000000000000, 1000000000145);
    let mut n: usize = 100;
    while n <= 1000000 {
        print_square_free_count(1, n);
        n *= 10;
    }
}
