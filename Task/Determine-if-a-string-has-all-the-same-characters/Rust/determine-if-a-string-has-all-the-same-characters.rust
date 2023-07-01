fn test_string(input: &str) {
    println!("Checking string {:?} of length {}:", input, input.chars().count());

    let mut chars = input.chars();

    match chars.next() {
        Some(first) => {
            if let Some((character, pos)) = chars.zip(2..).filter(|(c, _)| *c != first).next() {
                println!("\tNot all characters are the same.");
                println!("\t{:?} (0x{:X}) at position {} differs.", character, character as u32, pos);

                return;
            }
        },
        None => {}
    }

    println!("\tAll characters in the string are the same");
}

fn main() {
    let tests = ["", "   ", "2", "333", ".55", "tttTTT", "4444 444k", "pépé", "🐶🐶🐺🐶", "🎄🎄🎄🎄"];

    for string in &tests {
        test_string(string);
    }
}
