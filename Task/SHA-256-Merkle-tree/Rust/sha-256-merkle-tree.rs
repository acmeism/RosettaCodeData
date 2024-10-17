extern crate crypto;

use crypto::digest::Digest;
use crypto::sha2::Sha256;
use std::fs::File;
use std::io::prelude::*;
use std::io::BufReader;

fn sha256_merkle_tree(filename: &str, block_size: usize) -> std::io::Result<Option<Vec<u8>>> {
    let mut md = Sha256::new();
    let mut input = BufReader::new(File::open(filename)?);
    let mut buffer = vec![0; block_size];
    let mut digest = vec![0; md.output_bytes()];
    let mut digests = Vec::new();
    loop {
        let bytes = input.read(&mut buffer)?;
        if bytes == 0 {
            break;
        }
        md.reset();
        md.input(&buffer[0..bytes]);
        md.result(&mut digest);
        digests.push(digest.clone());
    }
    let mut len = digests.len();
    if len == 0 {
        return Ok(None);
    }
    while len > 1 {
        let mut j = 0;
        let mut i = 0;
        while i < len {
            if i + 1 < len {
                md.reset();
                md.input(&digests[i]);
                md.input(&digests[i + 1]);
                md.result(&mut digests[j]);
            } else {
                digests.swap(i, j);
            }
            i += 2;
            j += 1;
        }
        len = j;
    }
    Ok(Some(digests[0].clone()))
}

fn digest_to_string(digest: &[u8]) -> String {
    let mut result = String::new();
    for x in digest {
        result.push_str(&format!("{:02x}", x));
    }
    result
}

fn main() {
    match sha256_merkle_tree("title.png", 1024) {
        Ok(Some(digest)) => println!("{}", digest_to_string(&digest)),
        Ok(None) => {}
        Err(error) => eprintln!("I/O error: {}", error),
    }
}
