fn main() {
    let key = "]kYV}(!7P$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs\"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ";

    let s = "The quick brown fox jumps over the lazy dog, who barks VERY loudly!";
    let enc = encode(s, key);
    println!("Encoded: {}", enc);
    println!("Decoded: {}", decode(&enc, key));
}

fn encode(s: &str, key: &str) -> String {
    let key_bytes = key.as_bytes();
    s.bytes()
        .map(|b| key_bytes[(b as usize) - 32] as char)
        .collect()
}

fn decode(s: &str, key: &str) -> String {
    let key_bytes = key.as_bytes();
    s.bytes()
        .map(|b| {
            let index = key_bytes.iter().position(|&k| k == b).unwrap();
            (index + 32) as u8 as char
        })
        .collect()
}
