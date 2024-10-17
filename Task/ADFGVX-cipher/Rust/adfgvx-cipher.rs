// This version formats the encrypted text in 5 character blocks, as the historical version apparently did.

use fastrand::shuffle;
use std::collections::HashMap;

static ADFGVX: &str = "ADFGVX";

#[derive(Clone, Eq, Hash, PartialEq)]
struct CPair(char, char);

/// The WWI German ADFGVX cipher.
struct AdfgvxCipher {
    polybius: Vec<char>,
    key: Vec<char>,
    encode: HashMap<char, CPair>,
    decode: HashMap<CPair, char>,
}

/// Set up the encoding and decoding for the ADFGVX cipher.
fn cipher(allowed_chars: String, encrypt_key: String) -> AdfgvxCipher {
    let alphabet = allowed_chars.to_uppercase().chars().collect::<Vec<_>>();
    assert!(alphabet.len() == ADFGVX.len() * ADFGVX.len());
    let mut polybius = alphabet.clone();
    shuffle(&mut polybius);
    let key = encrypt_key.to_uppercase().chars().collect::<Vec<_>>();
    let adfgvx: Vec<char> = String::from(ADFGVX).chars().collect();
    let mut pairs: Vec<CPair> = [CPair(' ', ' '); 0].to_vec();
    for c1 in &adfgvx {
        for c2 in &adfgvx {
            pairs.push(CPair(*c1, *c2));
        }
    }
    let mut encode: HashMap<char, CPair> = HashMap::new();
    for i in 0..pairs.len() {
        encode.insert(polybius[i], pairs[i].clone());
    }
    let mut decode = HashMap::new();
    for (k, v) in &encode {
        decode.insert(v.clone(), *k);
    }
    return AdfgvxCipher {
        polybius,
        key,
        encode,
        decode,
    };
}

/// Encrypt with the ADFGVX cipher.
fn encrypt(a: &AdfgvxCipher, msg: String) -> String {
    let umsg: Vec<char> = msg
        .clone()
        .to_uppercase()
        .chars()
        .filter(|c| a.polybius.contains(c))
        .collect();
    let mut fractionated = vec![' '; 0].to_vec();
    for c in umsg {
        let cp = a.encode.get(&c).unwrap();
        fractionated.push(cp.0);
        fractionated.push(cp.1);
    }
    let ncols = a.key.len();
    let extra = fractionated.len() % ncols;
    if extra > 0 {
        fractionated.append(&mut vec!['\u{00}'; ncols - extra]);
    }
    let nrows = fractionated.len() / ncols;
    let mut sortedkey = a.key.clone();
    sortedkey.sort();
    let mut ciphertext = String::from("");
    let mut textlen = 0;
    for j in 0..ncols {
        let k = a.key.iter().position(|c| *c == sortedkey[j]).unwrap();
        for i in 0..nrows {
            let ch: char = fractionated[i * ncols + k];
            if ch != '\u{00}' {
                ciphertext.push(ch);
                textlen += 1;
                if textlen % 5 == 0 {
                    ciphertext.push(' ');
                }
            }
        }
    }
    return ciphertext;
}

/// Decrypt with the ADFGVX cipher. Does not depend on spacing of encoded text
fn decrypt(a: &AdfgvxCipher, cod: String) -> String {
    let chars: Vec<char> = cod.chars().filter(|c| *c != ' ').collect();
    let mut sortedkey = a.key.clone();
    sortedkey.sort();
    let order: Vec<usize> = sortedkey
        .iter()
        .map(|c| a.key.iter().position(|kc| kc == c).unwrap())
        .collect();
    let originalorder: Vec<usize> = a
        .key
        .iter()
        .map(|c| sortedkey.iter().position(|kc| kc == c).unwrap())
        .collect();
    let q = chars.len() / a.key.len();
    let r = chars.len() % a.key.len();
    let strides: Vec<usize> = order
        .iter()
        .map(|i| {q + {if r > *i {1} else {0}}}).collect();
    let mut starts: Vec<usize> = vec![0_usize; 1].to_vec();
    let mut stridesum = 0;
    for i in 0..strides.len() - 1 {
        stridesum += strides[i];
        starts.push(stridesum);
    }
    let ends: Vec<usize> = (0..a.key.len()).map(|i| (starts[i] + strides[i])).collect(); // shuffled ends of columns
    let cols: Vec<Vec<char>> = originalorder
        .iter()
        .map(|i| (chars[starts[*i]..ends[*i]]).to_vec())
        .collect(); // get reordered columns
    let nrows = (chars.len() - 1) / a.key.len() + 1;
    let mut fractionated = vec![' '; 0].to_vec();
    for i in 0..nrows {
        for j in 0..a.key.len() {
            if i < cols[j].len() {
                fractionated.push(cols[j][i]);
            }
        }
    }
    let mut decoded = String::from("");
    for i in 0..fractionated.len() - 1 {
        if i % 2 == 0 {
            let cp = CPair(fractionated[i], fractionated[i + 1]);
            decoded.push(*a.decode.get(&cp).unwrap());
        }
    }
    return decoded;
}

fn main() {
    let msg = String::from("ATTACKAT1200AM");
    let encrypt_key = String::from("volcanism");
    let allowed_chars: String = String::from("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
    let adf = cipher(allowed_chars, encrypt_key.clone());
    println!("Message: {msg}");
    println!("Polybius: {:?}", adf.polybius.iter().collect::<String>());
    println!("Key: {encrypt_key}");
    let encrypted_message = encrypt(&adf, msg.clone());
    println!("Encoded: {encrypted_message}");
    let decoded = decrypt(&adf, encrypted_message);
    println!("Decoded: {decoded:?}");
}
