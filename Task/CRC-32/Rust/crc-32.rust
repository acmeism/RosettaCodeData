fn crc32_compute_table() -> [u32; 256] {
    let mut crc32_table = [0; 256];

    for n in 0..256 {
        crc32_table[n as usize] = (0..8).fold(n as u32, |acc, _| {
            match acc & 1 {
                1 => 0xedb88320 ^ (acc >> 1),
                _ => acc >> 1,
            }
        });
    }

    crc32_table
}

fn crc32(buf: &str) -> u32 {
    let crc_table = crc32_compute_table();

    !buf.bytes().fold(!0, |acc, octet| {
        (acc >> 8) ^ crc_table[((acc & 0xff) ^ octet as u32) as usize]
    })
}

fn main() {
    println!("{:x}", crc32("The quick brown fox jumps over the lazy dog"));
}
