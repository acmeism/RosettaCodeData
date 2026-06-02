let crc_table: [u32; 256];

fn crc32_init() {
    let crc: u32 = 1;
    for let i: u32 = 128; i; i >>= 1 {
        crc = (crc >> 1) ^ (crc & 1 ? 0xedb88320 : 0);
        for let j: u32 = 0; j < 256; j += 2 * i {
            crc_table[i + j] = crc ^ crc_table[j];
        }
    }
}

fn crc32(data: string) -> u32 {
    let data_length = strlen(data);
    let crc: u32 = 0xffffffff;
    if crc_table[255] == 0 { crc32_init(); }
    for let i: usize = 0; i < data_length; ++i {
        crc ^= data[i];
        crc = (crc >> 8) ^ crc_table[crc & 0xff];
    }
    crc ^= 0xffffffff;
    return crc;
}

fn main() {
    let crc = crc32("The quick brown fox jumps over the lazy dog");
    println "{crc:x}";
}
