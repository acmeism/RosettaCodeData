fn print_match(possible_match: Option<usize>) {
    match possible_match {
        Some(match_pos) => println!("Found match at pos {}", match_pos),
        None => println!("Did not find any matches")
    }
}

fn main() {
    let s1 = "abcd";
    let s2 = "abab";
    let s3 = "ab";

    // Determining if the first string starts with second string
    assert!(s1.starts_with(s3));
    // Determining if the first string contains the second string at any location
    assert!(s1.contains(s3));
    // Print the location of the match
    print_match(s1.find(s3)); // Found match at pos 0
    print_match(s1.find(s2)); // Did not find any matches
    // Determining if the first string ends with the second string
    assert!(s2.ends_with(s3));
}
