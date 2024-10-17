fn is_narcissistic(x: u32) -> bool {
    let digits: Vec<u32> = x
        .to_string()
        .chars()
        .map(|c| c.to_digit(10).unwrap())
        .collect();

    digits
        .iter()
        .map(|d| d.pow(digits.len() as u32))
        .sum::<u32>()
        == x
}

fn main() {
    let mut counter = 0;
    let mut i = 0;
    while counter < 25 {
        if is_narcissistic(i) {
            println!("{}", i);
            counter += 1;
        }
        i += 1;
    }
}
