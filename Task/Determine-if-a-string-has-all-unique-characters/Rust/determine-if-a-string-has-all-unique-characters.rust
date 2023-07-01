fn unique(s: &str) -> Option<(usize, usize, char)> {
    s.chars().enumerate().find_map(|(i, c)| {
        s.chars()
            .enumerate()
            .skip(i + 1)
            .find(|(_, other)| c == *other)
            .map(|(j, _)| (i, j, c))
    })
}

fn main() {
    let strings = [
        "",
        ".",
        "abcABC",
        "XYZ ZYX",
        "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",
        "01234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ0X",
        "hétérogénéité",
        "🎆🎃🎇🎈",
        "😍😀🙌💃😍🙌",
        "🐠🐟🐡🦈🐬🐳🐋🐡",
    ];

    for string in &strings {
        print!("\"{}\" (length {})", string, string.chars().count());
        match unique(string) {
            None => println!(" is unique"),
            Some((i, j, c)) => println!(
                " is not unique\n\tfirst duplicate: \"{}\" (U+{:0>4X}) at indices {} and {}",
                c, c as usize, i, j
            ),
        }
    }
}
