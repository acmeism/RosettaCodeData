// [dependencies]
// chrono = "0.4.44"

fn is_palindrome(s: &str) -> bool {
    s.chars().rev().eq(s.chars())
}

fn main() {
    let mut date = chrono::Utc::now().date_naive();
    let mut count = 0;
    while count < 15 {
        if is_palindrome(&date.format("%Y%m%d").to_string()) {
            println!("{}", date.format("%F"));
            count += 1;
        }
        date = date.succ_opt().unwrap();
    }
}
