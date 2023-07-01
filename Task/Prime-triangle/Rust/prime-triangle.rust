fn is_prime(n: u32) -> bool {
    assert!(n < 64);
    ((1u64 << n) & 0x28208a20a08a28ac) != 0
}

fn prime_triangle_row(a: &mut [u32]) -> bool {
    if a.len() == 2 {
        return is_prime(a[0] + a[1]);
    }
    for i in (1..a.len() - 1).step_by(2) {
        if is_prime(a[0] + a[i]) {
            a.swap(i, 1);
            if prime_triangle_row(&mut a[1..]) {
                return true;
            }
            a.swap(i, 1);
        }
    }
    false
}

fn prime_triangle_count(a: &mut [u32]) -> u32 {
    let mut count = 0;
    if a.len() == 2 {
        if is_prime(a[0] + a[1]) {
            count += 1;
        }
    } else {
        for i in (1..a.len() - 1).step_by(2) {
            if is_prime(a[0] + a[i]) {
                a.swap(i, 1);
                count += prime_triangle_count(&mut a[1..]);
                a.swap(i, 1);
            }
        }
    }
    count
}

fn print(a: &[u32]) {
    if a.is_empty() {
        return;
    }
    print!("{:2}", a[0]);
    for x in &a[1..] {
        print!(" {:2}", x);
    }
    println!();
}

fn main() {
    use std::time::Instant;
    let start = Instant::now();
    for n in 2..21 {
        let mut a: Vec<u32> = (1..=n).collect();
        if prime_triangle_row(&mut a) {
            print(&a);
        }
    }
    println!();
    for n in 2..21 {
        let mut a: Vec<u32> = (1..=n).collect();
        if n > 2 {
            print!(" ");
        }
        print!("{}", prime_triangle_count(&mut a));
    }
    println!();
    let time = start.elapsed();
    println!("\nElapsed time: {} milliseconds", time.as_millis());
}
