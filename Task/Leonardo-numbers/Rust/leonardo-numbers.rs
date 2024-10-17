fn leonardo(mut n0: u32, mut n1: u32, add: u32) -> impl std::iter::Iterator<Item = u32> {
    std::iter::from_fn(move || {
        let n = n0;
        n0 = n1;
        n1 += n + add;
        Some(n)
    })
}

fn main() {
    println!("First 25 Leonardo numbers:");
    for i in leonardo(1, 1, 1).take(25) {
        print!("{} ", i);
    }
    println!();
    println!("First 25 Fibonacci numbers:");
    for i in leonardo(0, 1, 0).take(25) {
        print!("{} ", i);
    }
    println!();
}
