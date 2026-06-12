// [dependencies]
// hmac = "0.12.1"
// sha1 = "0.10.5"
// rand = "0.8.5"

use hmac::{Hmac, Mac};
use rand::RngCore;
use sha1::Sha1;
use std::time::{SystemTime, UNIX_EPOCH};

type HmacSha1 = Hmac<Sha1>;

struct TotpSha1 {
    k: Vec<u8>,
}

impl TotpSha1 {
    fn new() -> Self {
        let mut totp = TotpSha1 { k: Vec::new() };
        totp.generate_key();
        totp
    }

    fn generate_key(&mut self) {
        // Keys SHOULD be of the length of the HMAC output to facilitate
        // interoperability.
        let mut key = vec![0u8; 20]; // SHA-1 output size is 20 bytes
        rand::thread_rng().fill_bytes(&mut key);
        self.k = key;
    }

    fn hotp(&self, c: u64, digits: u32) -> u32 {
        let mut mac = HmacSha1::new_from_slice(&self.k)
            .expect("HMAC can take key of any size");
        mac.update(&c.to_be_bytes());
        let hmac_result = mac.finalize().into_bytes();
        self.truncate(&hmac_result, digits)
    }

    fn counter_now(&self, t1: u64) -> u64 {
        let seconds_since_epoch = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .expect("Time went backwards")
            .as_secs();
        seconds_since_epoch / t1
    }

    fn _dt(&self, hmac_result: &[u8]) -> u32 {
        let offset = (hmac_result[19] & 0xf) as usize;
        let bin_code = ((hmac_result[offset] & 0x7f) as u32) << 24
            | ((hmac_result[offset + 1] & 0xff) as u32) << 16
            | ((hmac_result[offset + 2] & 0xff) as u32) << 8
            | ((hmac_result[offset + 3] & 0xff) as u32);
        bin_code
    }

    fn truncate(&self, hmac_result: &[u8], digits: u32) -> u32 {
        let snum = self._dt(hmac_result);
        snum % 10u32.pow(digits)
    }
}

fn main() {
    let totp = TotpSha1::new();
    println!("{}", totp.hotp(totp.counter_now(30), 6));
}
