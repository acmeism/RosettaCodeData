fn lpd(n: u32) -> u32 {
    if n <= 1 {
        1
    } else {
        (1..n).rev().find(|&i| n % i == 0).unwrap_or(1)
    }
}

fn main() {
    for i in 1..=100 {
        print!("{:3}", lpd(i));

        if i % 10 == 0 {
            println!();
        }
    }
}
