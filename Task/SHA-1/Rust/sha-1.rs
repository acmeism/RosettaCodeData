use sha1::Sha1;

fn main() {
    let mut hash_msg = Sha1::new();
    hash_msg.update(b"Rosetta Code");
    println!("{}", hash_msg.digest().to_string());
}
