fn is_own_digits_power_sum(n: u32) -> bool {
    let n_str = n.to_string();
    n_str.chars()
        .map(|c| {
            let digit = c.to_digit(10).unwrap();
            digit.pow(n_str.len() as u32)
        })
        .sum::<u32>()
        == n
}

fn main() {
    let result: Vec<u32> = (10u32.pow(2)..10u32.pow(9))
        .filter(|&n| is_own_digits_power_sum(n))
        .collect();

    println!("{:?}", result);
}
