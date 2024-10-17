fn stripped(tostrip: &str) -> String {
    return tostrip
        .chars()
        .filter(|c| (*c as u32) < 127 && *c as u32 > 31)
        .collect();
}

fn main() {
    println!("{}", stripped("\x08a\x00b\n\rc\x0cd\u{00c3}"));
}
