extern crate crypto;

use crypto::digest::Digest;
use crypto::sha2::Sha256;

const DIGITS58: [char; 58] = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];

fn main() {
    println!("{}", validate_address("1AGNa15ZQXAZUgFiqJ3i7Z2DPU2J6hW62i"));
    println!("{}", validate_address("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i"));
    println!("{}", validate_address("17NdbrSGoUotzeGCcMMCqnFkEvLymoou9j"));
    println!("{}", validate_address("17NdbrSGoUotzeGCcMMC?nFkEvLymoou9j"));
}

fn validate_address(address: &str) -> bool {
    let decoded = match from_base58(address, 25) {
        Ok(x) => x,
        Err(_) => return false
    };
    if decoded[0] != 0 {
        return false;
    }
    let mut sha = Sha256::new();
    sha.input(&decoded[0..21]);
    let mut first_round = vec![0u8; sha.output_bytes()];
    sha.result(&mut first_round);
    sha.reset();

    sha.input(&first_round);
    let mut second_round = vec![0u8; sha.output_bytes()];
    sha.result(&mut second_round);
    if second_round[0..4] != decoded[21..25] {
        return false
    }
    true
}

fn from_base58(encoded: &str, size: usize) -> Result<Vec<u8>, String> {
    let mut res: Vec<u8> = vec![0; size];
    for base58_value in encoded.chars() {
        let mut value: u32 = match DIGITS58
            .iter()
            .position(|x| *x == base58_value){
            Some(x) => x as u32,
            None => return Err(String::from("Invalid character found in encoded string."))
        };
        for result_index in (0..size).rev() {
            value += 58 * res[result_index] as u32;
            res[result_index] = (value % 256) as u8;
            value /= 256;
        }
    }
    Ok(res)
}
