use std::ascii::AsciiExt;

static A: u8 = 'A' as u8;

fn uppercase_and_filter(input: &str) -> Vec<u8> {
    let alphabet = b"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    let mut result = Vec::new();

    for c in input.chars() {
        // Ignore anything that is not in our short list of chars. We can then safely cast to u8.
        if alphabet.iter().any(|&x| x as char == c) {
            result.push(c.to_ascii_uppercase() as u8);
        }
    }

    return result;
}

fn vigenere(key: &str, text: &str, is_encoding: bool) -> String {

    let key_bytes = uppercase_and_filter(key);
    let text_bytes = uppercase_and_filter(text);

    let mut result_bytes = Vec::new();

    for (i, c) in text_bytes.iter().enumerate() {
        let c2 = if is_encoding {
            (c + key_bytes[i % key_bytes.len()] - 2 * A) % 26 + A
        } else {
            (c + 26 - key_bytes[i % key_bytes.len()]) % 26 + A
        };
        result_bytes.push(c2);
    }

    String::from_utf8(result_bytes).unwrap()
}

fn main() {
    let text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!";
    let key = "VIGENERECIPHER";

    println!("Text: {}", text);
    println!("Key:  {}", key);

    let encoded = vigenere(key, text, true);
    println!("Code: {}", encoded);
    let decoded = vigenere(key, &encoded, false);
    println!("Back: {}", decoded);
}
