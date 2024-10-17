fn main() {
    let isbns = ["978-0596528126", "978-0596528120", "978-1788399081", "978-1788399083"];
    isbns.iter().for_each(|isbn| println!("{}: {}", isbn, check_isbn(isbn)));
}

fn check_isbn(isbn: &str) -> bool {
    if isbn.chars().filter(|c| c.is_digit(10)).count() != 13 {
            return false;
    }
    let checksum = isbn.chars().filter_map(|c| c.to_digit(10))
        .zip([1, 3].iter().cycle())
        .fold(0, |acc, (val, fac)| acc + val * fac);
    checksum % 10 == 0
}
