// bit_array.rs
pub struct BitArray {
    array: Vec<u32>,
}

impl BitArray {
    pub fn new(size: usize) -> BitArray {
        BitArray {
            array: vec![0; (size + 31) / 32],
        }
    }
    pub fn get(&self, index: usize) -> bool {
        let bit = 1 << (index & 31);
        (self.array[index >> 5] & bit) != 0
    }
    pub fn set(&mut self, index: usize, new_val: bool) {
        let bit = 1 << (index & 31);
        if new_val {
            self.array[index >> 5] |= bit;
        } else {
            self.array[index >> 5] &= !bit;
        }
    }
}
