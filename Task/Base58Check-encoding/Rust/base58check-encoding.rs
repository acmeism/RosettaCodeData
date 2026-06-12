extern crate num_bigint;


use num_bigint::BigInt;
use num_traits::{Zero, ToPrimitive};

const ALPHABET: &str = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

fn convert_to_base58(hash: &str, base: u32) -> Result<String, String> {
    // Handle base 0: strip "0x" prefix for hex, otherwise treat as decimal
    let (input_str, radix) = if base == 0 {
        if let Some(hex) = hash.strip_prefix("0x").or_else(|| hash.strip_prefix("0X")) {
            (hex, 16)
        } else {
            (hash, 10)
        }
    } else {
        (hash, base)
    };

    // Parse input string into BigInt
    let mut num = BigInt::parse_bytes(input_str.as_bytes(), radix)
        .ok_or_else(|| format!("'{}' is not a valid integer in base {}", hash, radix))?;

    // Handle negative numbers
    if num < BigInt::zero() {
        return Err("Negative numbers not supported".into());
    }

    // Special case for zero
    if num.is_zero() {
        return Ok(ALPHABET[0..1].to_string());
    }

    let base58 = BigInt::from(58u32);
    let mut result = String::new();

    // Repeatedly divide by 58 and map remainders to base58 alphabet
    while num > BigInt::zero() {
        // let (quotient, remainder) = &num.div_mod_ceil(&base58);
        let quotient= (&num) / (&base58);
        let remainder= (&num) % (&base58);
        num = quotient;
        let idx = remainder.to_u8().unwrap() as usize;
        result.push(ALPHABET.chars().nth(idx).unwrap());
    }

    // Reverse the collected characters for correct order
    Ok(result.chars().rev().collect())
}

fn main() {
    let s = "25420294593250030202636073700053352635053786165627414518";
    match convert_to_base58(s, 10) {
        Ok(b) => println!("{} -> {}", s, b),
        Err(e) => eprintln!("Error: {}", e),
    }

    let hashes = [
        "0x61",
        "0x626262",
        "0x636363",
        "0x73696d706c792061206c6f6e6720737472696e67",
        "0x516b6fcd0f",
        "0xbf4f89001e670274dd",
        "0x572e4794",
        "0xecac89cad93923c02321",
        "0x10c8511e",
    ];

    for hash in &hashes {
        match convert_to_base58(hash, 0) {
            Ok(b58) => println!("{:56} -> {}", hash, b58),
            Err(e) => eprintln!("Error for {}: {}", hash, e),
        }
    }
}
