// [dependencies]
// rust-crypto = "0.2.36"
// num_cpus = "1.7.0"
// hex = "0.2.0"

extern crate crypto;
extern crate num_cpus;
extern crate hex;

use std::thread;
use std::cmp::min;
use crypto::sha2::Sha256;
use crypto::digest::Digest;
use hex::{FromHex, ToHex};

fn main() {
    let hashes = vec![
        decode("1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad"),
        decode("3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b"),
        decode("74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"),
    ];

    let mut threads = Vec::new();
    let mut ranges = distribute_work();

    while let Some(range) = ranges.pop() {
        let hashes = hashes.clone();
        threads.push(thread::spawn(
            move || search(range.0, range.1, hashes.clone()),
        ));
    }

    while let Some(t) = threads.pop() {
        t.join().ok();
    }
}

fn search(from: [u8; 5], to: [u8; 5], hashes: Vec<[u8; 256 / 8]>) {

    let mut password = from.clone();

    while password <= to {
        let mut sha256 = Sha256::new();
        sha256.input(&password);
        let mut result = [0u8; 256 / 8];
        sha256.result(&mut result);

        for hash in hashes.iter() {
            if *hash == result {
                println!(
                    "{}{}{}{}{} {}",
                    password[0] as char,
                    password[1] as char,
                    password[2] as char,
                    password[3] as char,
                    password[4] as char,
                    hash.to_hex()
                );
            }
        }

        password = next(&password);
    }

}

fn next(password: &[u8; 5]) -> [u8; 5] {
    let mut result = password.clone();
    for i in (0..result.len()).rev() {
        if result[i] == b'z' {
            if i == 0 {
                result[i] = b'z' + 1;
            } else {
                result[i] = b'a';
            }
        } else {
            result[i] += 1;
            break;
        }
    }
    result.clone()
}

fn distribute_work() -> Vec<([u8; 5], [u8; 5])> {
    let mut ranges = Vec::new();
    let num_cpus = min(num_cpus::get(), 26) as u8;

    let div = 25 / num_cpus;
    let mut remainder = 25 % num_cpus;
    let mut from = b'a';
    while from < b'z' {

        let to = from + div +
            if remainder > 0 {
                remainder -= 1;
                1
            } else {
                0
            };

        ranges.push((
            [from, from, from, from, from + 1].clone(),
            [to, to, to, to, to].clone(),
        ));

        from = to;
    }
    ranges[0].0[4] = b'a';

    ranges.clone()
}

fn decode(string: &str) -> [u8; 256 / 8] {
    let mut result = [0; 256 / 8];
    let vec = Vec::from_hex(string).unwrap();
    for i in 0..result.len() {
        result[i] = vec[i];
    }
    result.clone()
}
