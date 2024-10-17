fn test_division(numerator: u32, denominator: u32) {
    match numerator.checked_div(denominator) {
        Some(result) => println!("{} / {} = {}", numerator, denominator, result),
        None => println!("{} / {} results in a division by zero", numerator, denominator)
    }
}

fn main() {
    test_division(5, 4);
    test_division(4, 0);
}
