fn is_self_contained(n: i64) -> bool {
    let mut m = n;
    while m > 1 {
        m = if m % 2 == 0 { m >> 1 } else { m * 3 + 1 };
        if m % n == 0 {
            return true;
        }
    }
    false
}

fn main() {
    let result: Vec<i64> = (1..)
        .step_by(2)
        .filter(|&n| is_self_contained(n))
        .take(7)
        .collect();

    println!("{:?}", result);
}
