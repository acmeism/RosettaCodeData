fn strip_characters(original: &str, to_strip: &str) -> String {
    original
        .chars()
        .filter(|&c| !to_strip.contains(c))
        .collect()
}

fn strip_characters(original: &str, to_strip: &str) -> String {
    original.split(|c| to_strip.contains(c)).collect()
}
