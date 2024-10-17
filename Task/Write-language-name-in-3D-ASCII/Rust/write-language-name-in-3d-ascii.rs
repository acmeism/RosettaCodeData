pub fn char_from_id(id: u8) -> char {
    [' ', '#', '/', '_', 'L', '|', '\n'][id as usize]
}

const ID_BITS: u8 = 3;

pub fn decode(code: &[u8]) -> String {
    let mut ret = String::new();
    let mut carry = 0;
    let mut carry_bits = 0;
    for &b in code {
        let mut bit_pos = ID_BITS - carry_bits;
        let mut cur = b >> bit_pos;
        let mask = (1 << bit_pos) - 1;
        let id = carry | (b & mask) << carry_bits;
        ret.push(char_from_id(id));
        while bit_pos + ID_BITS < 8 {
            ret.push(char_from_id(cur & ((1 << ID_BITS) - 1)));
            cur >>= ID_BITS;
            bit_pos += ID_BITS;
        }
        carry = cur;
        carry_bits = 8 - bit_pos;
    }
    ret
}

fn main() {
    let code = [
        72, 146, 36, 0, 0, 0, 0, 0, 0, 0, 128, 196, 74, 182, 41, 1, 0, 0, 0, 0, 0, 0, 160, 196, 77, 0,
        52, 1, 18, 0, 9, 144, 36, 9, 146, 36, 113, 147, 36, 9, 160, 4, 80, 130, 100, 155, 160, 41, 145,
        155, 108, 74, 128, 38, 64, 19, 41, 73, 2, 160, 137, 155, 0, 84, 130, 38, 64, 19, 112, 155, 18,
        160, 137, 155, 0, 160, 18, 42, 73, 18, 36, 73, 2, 128, 74, 76, 1, 0, 40, 128, 219, 38, 104, 219,
        4, 0, 160, 0
    ];

    println!("{}", decode(&code));
}
