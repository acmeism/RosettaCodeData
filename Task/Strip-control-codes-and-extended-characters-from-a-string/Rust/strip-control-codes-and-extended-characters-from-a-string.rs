fn stripped(tostrip: &str) -> String {
    return tostrip
        .chars()
        .filter(|c| !c.is_ascii_control() && c.is_ascii())
        .collect();
}

fn main() {
    println!("{}", stripped("\x08a\x00b\n\rc\x0cd\u{00c3}"));
}
