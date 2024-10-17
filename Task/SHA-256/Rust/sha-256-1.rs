use sha2::{Digest, Sha256};

fn hex_string(input: &[u8]) -> String {
    input.as_ref().iter().map(|b| format!("{:x}", b)).collect()
}

fn main() {
    // create a Sha256 object
    let mut hasher = Sha256::new();

    // write input message
    hasher.update(b"Rosetta code");

    // read hash digest and consume hasher
    let result = hasher.finalize();

    let hex = hex_string(&result);

    assert_eq!(
        hex,
        "764faf5c61ac315f1497f9dfa542713965b785e5cc2f707d6468d7d1124cdfcf"
    );

    println!("{}", hex);
}
