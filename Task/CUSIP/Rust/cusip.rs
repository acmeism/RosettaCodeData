fn cusip_check(cusip: &str) -> bool {
    if cusip.len() != 9 {
        return false;
    }

    let mut v = 0;
    let capital_cusip = cusip.to_uppercase();
    let char_indices = capital_cusip.as_str().char_indices().take(7);

    let total = char_indices.fold(0, |total, (i, c)| {
        v = match c {
            '*' => 36,
            '@' => 37,
            '#' => 38,
            _ if c.is_digit(10) => c.to_digit(10).unwrap() as u8,
            _ if c.is_alphabetic() => (c as u8) - b'A' + 1 + 9,
            _ => v,
        };

        if i % 2 != 0 {
            v *= 2
        }
        total + (v / 10) + v % 10
    });

    let check = (10 - (total % 10)) % 10;
    (check.to_string().chars().nth(0).unwrap()) == cusip.chars().nth(cusip.len() - 1).unwrap()
}

fn main() {
    let codes = [
        "037833100",
        "17275R102",
        "38259P508",
        "594918104",
        "68389X106",
        "68389X105",
    ];
    for code in &codes {
        println!("{} -> {}", code, cusip_check(code))
    }
}
