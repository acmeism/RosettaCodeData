use ring::digest::{digest, SHA256};
use ripemd::{Digest, Ripemd160};

use hex::FromHex;

static X: &str = "50863AD64A87AE8A2FE83C1AF1A8403CB53F53E486D8511DAD8A04887E5B2352";
static Y: &str = "2CD470243453A299FA9E77237716103ABC11A1DF38855ED6F2EE187E9C582BA6";
static ALPHABET: [char; 58] = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K',
    'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e',
    'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y',
    'z',
];

fn base58_encode(bytes: &mut [u8]) -> String {
    let base = ALPHABET.len();
    if bytes.is_empty() {
        return String::from("");
    }
    let mut output: Vec<u8> = Vec::new();
    let mut num: usize;
    for _ in 0..33 {
        num = 0;
        for byte in bytes.iter_mut() {
            num = num * 256 + *byte as usize;
            *byte = (num / base) as u8;
            num %= base;
        }
        output.push(num as u8);
    }
    let mut string = String::new();
    for b in output.iter().rev() {
        string.push(ALPHABET[*b as usize]);
    }
    string
}

// stolen from address-validation/src/main.rs
/// Hashes the input with the SHA-256 algorithm twice, and returns the output.
fn double_sha256(bytes: &[u8]) -> Vec<u8> {
    let digest_1 = digest(&SHA256, bytes);

    let digest_2 = digest(&SHA256, digest_1.as_ref());
    digest_2.as_ref().to_vec()
}

fn point_to_address(x: &str, y: &str) -> String {
    let mut addrv: Vec<u8> = Vec::with_capacity(65);
    addrv.push(4u8);
    addrv.append(&mut <Vec<u8>>::from_hex(x).unwrap());
    addrv.append(&mut <Vec<u8>>::from_hex(y).unwrap());
    // hash the addresses first using SHA256
    let sha_digest = digest(&SHA256, &addrv);
    let mut ripemd_digest = Ripemd160::digest(&sha_digest.as_ref()).as_slice().to_vec();
    // prepend a 0 to the vector
    ripemd_digest.insert(0, 0);
    // calculate checksum of extended ripemd digest
    let checksum = double_sha256(&ripemd_digest);
    ripemd_digest.extend_from_slice(&checksum[..4]);
    base58_encode(&mut ripemd_digest)
}

fn main() {
    println!("{}", point_to_address(X, Y));
}
