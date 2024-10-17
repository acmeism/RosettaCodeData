use ripemd160::{Digest, Ripemd160};

/// Create a lowercase hexadecimal string using the
/// RIPEMD160 hashing algorithm
fn ripemd160(text: &str) -> String {
    // create a lowercase hexadecimal string
    // using the shortand for the format macro
    // https://doc.rust-lang.org/std/fmt/trait.LowerHex.html
    format!("{:x}", Ripemd160::digest(text.as_bytes()))
}

fn main() {
    println!("{}", ripemd160("Rosetta Code"));
}
