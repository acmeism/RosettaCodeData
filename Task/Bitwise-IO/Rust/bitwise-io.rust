pub trait Codec<Input = u8> {
    type Output: Iterator<Item = u8>;

    fn accept(&mut self, input: Input) -> Self::Output;
    fn finish(self) -> Self::Output;
}

#[derive(Debug)]
pub struct BitDiscard {
    buf: u16,      // Use the higher byte for storing the leftovers
    buf_bits: u8,  // How many bits are valid in the buffer
    valid_len: u8, // How many bits to keep from the input
    shift_len: u8, // Pre-computed shift of the input byte
}

impl BitDiscard {
    pub fn new(discard: u8) -> Self {
        assert!(discard < 8);

        BitDiscard {
            buf: 0,
            buf_bits: 0,
            valid_len: 8 - discard,
            shift_len: 8 + discard,
        }
    }
}

impl Codec<u8> for BitDiscard {
    type Output = std::option::IntoIter<u8>;

    fn accept(&mut self, input: u8) -> Self::Output {
        let add = ((input as u16) << self.shift_len) >> self.buf_bits;
        self.buf |= add;
        self.buf_bits += self.valid_len;

        let result = if self.buf_bits >= 8 {
            let result = (self.buf >> 8) as u8;
            self.buf <<= 8;
            self.buf_bits -= 8;
            Some(result)
        } else {
            None
        };

        result.into_iter()
    }

    fn finish(self) -> Self::Output {
        let result = if self.buf_bits > 0 {
            Some((self.buf >> 8) as u8)
        } else {
            None
        };

        result.into_iter()
    }
}

#[derive(Debug)]
pub struct BitExpand {
    buf: u16,      // For storing the leftovers
    buf_bits: u8,  // How many bits are valid in the buffer
    valid_len: u8, // How many bits are valid in the input
    shift_len: u8, // How many bits to shift when expanding
}

impl BitExpand {
    pub fn new(expand: u8) -> Self {
        assert!(expand < 8);

        Self {
            buf: 0,
            buf_bits: 0,
            valid_len: 8 - expand,
            shift_len: 8 + expand,
        }
    }
}

impl Codec<u8> for BitExpand {
    type Output = BitExpandIter;

    fn accept(&mut self, input: u8) -> Self::Output {
        let add = ((input as u16) << 8) >> self.buf_bits;
        self.buf |= add;
        self.buf_bits += 8;
        let buf = self.buf;
        let leftover = self.buf_bits % self.valid_len;
        let buf_bits = self.buf_bits - leftover;
        self.buf <<= buf_bits;
        self.buf_bits = leftover;

        Self::Output {
            buf,
            buf_bits,
            shift_len: self.shift_len,
            valid_len: self.valid_len,
        }
    }

    fn finish(self) -> Self::Output {
        Self::Output {
            buf: 0,
            buf_bits: 0,
            shift_len: 0,
            valid_len: self.valid_len,
        }
    }
}

#[derive(Debug)]
pub struct BitExpandIter {
    buf: u16,
    buf_bits: u8,
    valid_len: u8,
    shift_len: u8,
}

impl Iterator for BitExpandIter {
    type Item = u8;

    fn next(&mut self) -> Option<u8> {
        if self.buf_bits < self.valid_len {
            None
        } else {
            let result = (self.buf >> self.shift_len) as u8;
            self.buf <<= self.valid_len;
            self.buf_bits -= self.valid_len;
            Some(result)
        }
    }
}

fn process_bytes<C: Codec>(mut codec: C, bytes: &[u8]) -> Vec<u8> {
    let mut result: Vec<u8> = bytes.iter().flat_map(|byte| codec.accept(*byte)).collect();
    codec.finish().for_each(|byte| result.push(byte));
    result
}

fn print_bytes(bytes: &[u8]) {
    for byte in bytes {
        print!("{:08b} ", byte);
    }
    println!();

    for byte in bytes {
        print!("{:02x} ", byte);
    }
    println!();
}

fn main() {
    let original = b"STRINGIFY!";
    let discard = 1;
    print_bytes(&original[..]);
    let compressed = process_bytes(BitDiscard::new(discard), &original[..]);
    print_bytes(&compressed);
    let decompressed = process_bytes(BitExpand::new(discard), &compressed);
    print_bytes(&decompressed);
}
