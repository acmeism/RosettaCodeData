fn fusc_sequence() -> impl std::iter::Iterator<Item = u32> {
    let mut sequence = vec![0, 1];
    let mut n = 0;
    std::iter::from_fn(move || {
        if n > 1 {
            sequence.push(match n % 2 {
                0 => sequence[n / 2],
                _ => sequence[(n - 1) / 2] + sequence[(n + 1) / 2],
            });
        }
        let result = sequence[n];
        n += 1;
        Some(result)
    })
}

fn main() {
    println!("First 61 fusc numbers:");
    for n in fusc_sequence().take(61) {
        print!("{} ", n)
    }
    println!();

    let limit = 1000000000;
    println!(
        "Fusc numbers up to {} that are longer than any previous one:",
        limit
    );
    let mut max = 0;
    for (index, n) in fusc_sequence().take(limit).enumerate() {
        if n >= max {
            max = std::cmp::max(10, max * 10);
            println!("index = {}, fusc number = {}", index, n);
        }
    }
}
