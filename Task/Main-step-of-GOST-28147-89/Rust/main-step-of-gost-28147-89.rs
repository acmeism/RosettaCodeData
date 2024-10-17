use std::convert::TryInto;
use std::env;
use std::num::Wrapping;

const REPLACEMENT_TABLE: [[u8; 16]; 8] = [
    [4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3],
    [14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9],
    [5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11],
    [7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3],
    [6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2],
    [4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14],
    [13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12],
    [1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12],
];
const KEYS: [u32; 8] = [
    0xE2C1_04F9,
    0xE41D_7CDE,
    0x7FE5_E857,
    0x0602_65B4,
    0x281C_CC85,
    0x2E2C_929A,
    0x4746_4503,
    0xE00_CE510,
];

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        let plain_text: Vec<u8> = vec![0x04, 0x3B, 0x04, 0x21, 0x04, 0x32, 0x04, 0x30];
        println!(
            "Before one step: {}\n",
            plain_text
                .iter()
                .cloned()
                .fold("".to_string(), |b, y| b + &format!("{:02X} ", y))
        );
        let encoded_text = main_step(plain_text, KEYS[0]);
        println!(
            "After one step : {}\n",
            encoded_text
                .iter()
                .cloned()
                .fold("".to_string(), |b, y| b + &format!("{:02X} ", y))
        );
    } else {
        let mut t = args[1].clone(); // "They call him... Баба Яга"
        t += &" ".repeat((8 - t.len() % 8) % 8);
        let text_bytes = t.bytes().collect::<Vec<_>>();
        let plain_text = text_bytes.chunks(8).collect::<Vec<_>>();
        println!(
            "Plain text  : {}\n",
            plain_text.iter().cloned().fold("".to_string(), |a, x| a
                + "["
                + &x.iter()
                    .fold("".to_string(), |b, y| b + &format!("{:02X} ", y))[..23]
                + "]")
        );
        let encoded_text = plain_text
            .iter()
            .map(|c| encode(c.to_vec()))
            .collect::<Vec<_>>();
        println!(
            "Encoded text: {}\n",
            encoded_text.iter().cloned().fold("".to_string(), |a, x| a
                + "["
                + &x.into_iter()
                    .fold("".to_string(), |b, y| b + &format!("{:02X} ", y))[..23]
                + "]")
        );
        let decoded_text = encoded_text
            .iter()
            .map(|c| decode(c.to_vec()))
            .collect::<Vec<_>>();
        println!(
            "Decoded text: {}\n",
            decoded_text.iter().cloned().fold("".to_string(), |a, x| a
                + "["
                + &x.into_iter()
                    .fold("".to_string(), |b, y| b + &format!("{:02X} ", y))[..23]
                + "]")
        );
        let recovered_text =
            String::from_utf8(decoded_text.iter().cloned().flatten().collect::<Vec<_>>()).unwrap();
        println!("Recovered text: {}\n", recovered_text);
    }
}

fn encode(text_block: Vec<u8>) -> Vec<u8> {
    let mut step = text_block;
    for i in 0..24 {
        step = main_step(step, KEYS[i % 8]);
    }
    for i in (0..8).rev() {
        step = main_step(step, KEYS[i]);
    }
    step
}

fn decode(text_block: Vec<u8>) -> Vec<u8> {
    let mut step = text_block[4..].to_vec();
    let mut temp = text_block[..4].to_vec();
    step.append(&mut temp);
    for key in &KEYS {
        step = main_step(step, *key);
    }
    for i in (0..24).rev() {
        step = main_step(step, KEYS[i % 8]);
    }
    let mut ans = step[4..].to_vec();
    let mut temp = step[..4].to_vec();
    ans.append(&mut temp);
    ans
}

fn main_step(text_block: Vec<u8>, key_element: u32) -> Vec<u8> {
    let mut n = text_block;
    let mut s = (Wrapping(
        u32::from(n[0]) << 24 | u32::from(n[1]) << 16 | u32::from(n[2]) << 8 | u32::from(n[3]),
    ) + Wrapping(key_element))
    .0;
    let mut new_s: u32 = 0;
    for mid in 0..4 {
        let cell = (s >> (mid << 3)) & 0xFF;
        new_s += (u32::from(REPLACEMENT_TABLE[(mid * 2) as usize][(cell & 0x0f) as usize])
            + (u32::from(REPLACEMENT_TABLE[(mid * 2 + 1) as usize][(cell >> 4) as usize]) << 4))
            << (mid << 3);
    }
    s = ((new_s << 11) + (new_s >> 21))
        ^ (u32::from(n[4]) << 24 | u32::from(n[5]) << 16 | u32::from(n[6]) << 8 | u32::from(n[7]));
    n[4] = n[0];
    n[5] = n[1];
    n[6] = n[2];
    n[7] = n[3];
    n[0] = (s >> 24).try_into().unwrap();
    n[1] = ((s >> 16) & 0xFF).try_into().unwrap();
    n[2] = ((s >> 8) & 0xFF).try_into().unwrap();
    n[3] = (s & 0xFF).try_into().unwrap();
    n
}
