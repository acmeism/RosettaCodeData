fn strip_characters(original: &str, to_strip: &[char]) -> String {
    original.split(to_strip).collect()
}

fn main() {
    println!(
        "{}",
        strip_characters(
            "She was a soul stripper. She took my heart!",
            &['a', 'e', 'i']
        )
    );
}
