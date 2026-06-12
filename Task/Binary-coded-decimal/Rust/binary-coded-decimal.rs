#[derive(Copy, Clone)]
pub struct Bcd64 {
    bits: u64
}

use std::ops::*;

impl Add for Bcd64 {
    type Output = Self;
    fn add(self, other: Self) -> Self {
        let t1 = self.bits + 0x0666_6666_6666_6666;
        let t2 = t1.wrapping_add(other.bits);
        let t3 = t1 ^ other.bits;
        let t4 = !(t2 ^ t3) & 0x1111_1111_1111_1110;
        let t5 = (t4 >> 2) | (t4 >> 3);
        return Bcd64{ bits: t2 - t5 };
    }
}

impl Neg for Bcd64 {
    type Output = Self;
    fn neg(self) -> Self { // return 10's complement
        let t1 = -(self.bits as i64) as u64;
        let t2 = t1.wrapping_add(0xFFFF_FFFF_FFFF_FFFF);
        let t3 = t2 ^ 1;
        let t4 = !(t2 ^ t3) & 0x1111_1111_1111_1110;
        let t5 = (t4 >> 2) | (t4 >> 3);
        return Bcd64{ bits: t1 - t5 };
    }
}

impl Sub for Bcd64 {
    type Output = Self;
    fn sub(self, other: Self) -> Self {
        return self + -other;
    }
}

#[test]
fn addition_test() {
    let one = Bcd64{ bits: 0x01 };
    assert_eq!((Bcd64{ bits: 0x19 } + one).bits, 0x20);
    assert_eq!((Bcd64{ bits: 0x30 } - one).bits, 0x29);
    assert_eq!((Bcd64{ bits: 0x99 } + one).bits, 0x100);
}
