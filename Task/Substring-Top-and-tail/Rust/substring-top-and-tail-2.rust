fn main() {
    let s = "žluťoučký kůň";

    println!(
        "{}",
        s.char_indices()
            .nth(1)
            .map(|(i, _)| &s[i..])
            .unwrap_or_default()
    );

    println!(
        "{}",
        s.char_indices()
            .nth_back(0)
            .map(|(i, _)| &s[..i])
            .unwrap_or_default()
    );

    println!(
        "{}",
        s.char_indices()
            .nth(1)
            .and_then(|(i, _)| s.char_indices().nth_back(0).map(|(j, _)| i..j))
            .map(|range| &s[range])
            .unwrap_or_default()
    );
}
