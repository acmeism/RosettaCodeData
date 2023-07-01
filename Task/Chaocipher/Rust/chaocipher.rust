const LEFT_ALPHABET_CT: &str = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
const RIGHT_ALPHABET_PT: &str = "PTLNBQDEOYSFAVZKGJRIHWXUMC";
const ZENITH: usize = 0;
const NADIR: usize = 12;
const SEQUENCE: &str = "WELLDONEISBETTERTHANWELLSAID";

fn cipher(letter: &char, left: &String, right: &String) -> (usize, char) {
    let pos = right.find(*letter).unwrap();
    let cipher = left.chars().nth(pos).unwrap();
    (pos, cipher)
}

fn main() {
    let mut left = LEFT_ALPHABET_CT.to_string();
    let mut right = RIGHT_ALPHABET_PT.to_string();

    let ciphertext = SEQUENCE.chars()
        .map(|letter| {
            let (pos, cipher_char) = cipher(&letter, &left, &right);
            left = format!("{}{}", &left[pos..], &left[..pos]);
            left = format!("{}{}{}{}", &left[ZENITH..1], &left[2..NADIR+2], &left[1..2], &left[NADIR+2..]);
            if pos != right.len() - 1 {
                right = format!("{}{}", &right[pos + 1..], &right[..pos + 1]);
            }
            right = format!("{}{}{}{}", &right[ZENITH..2], &right[3..NADIR+2], &right[2..3], &right[NADIR+2..]);
            cipher_char
        })
        .collect::<String>();

    println!("Plaintext: {}", SEQUENCE);
    println!("Ciphertext: {}", ciphertext);
}
