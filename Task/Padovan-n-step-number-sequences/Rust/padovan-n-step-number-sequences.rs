fn padovan(n: u64, x: u64) -> u64 {
    if n < 2 {
        return 0;
    }

    match n {
        2 if x <= n + 1 => 1,
        2 => padovan(n, x - 2) + padovan(n, x - 3),
        _ if x <= n + 1 => padovan(n - 1, x),
        _ => ((x - n - 1)..(x - 1)).fold(0, |acc, value| acc + padovan(n, value)),
    }
}
fn main() {
    (2..=8).for_each(|n| {
        print!("\nN={}: ", n);
        (1..=15).for_each(|x| print!("{},", padovan(n, x)))
    });
}
