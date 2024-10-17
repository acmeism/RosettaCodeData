fn nth(num: isize) -> String {
    format!("{}{}", num, match (num % 10, num % 100) {
        (1, 11) | (2, 12) | (3, 13) => "th",
        (1, _) => "st",
        (2, _) => "nd",
        (3, _) => "rd",
        _ => "th",
    })
}

fn main() {
    let ranges = [(0, 26), (250, 266), (1000, 1026)];
    for &(s, e) in &ranges {
        println!("[{}, {}) :", s, e);
        for i in s..e {
            print!("{}, ", nth(i));
        }
        println!();
    }
}
