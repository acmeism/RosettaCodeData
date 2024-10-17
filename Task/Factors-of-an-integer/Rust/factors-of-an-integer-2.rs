fn factor(n: i32) -> Vec<i32> {
    (1..=n).filter(|i| n % i == 0).collect()
}
