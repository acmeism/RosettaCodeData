use std::ops::{BitOrAssign, Shr};

fn set_right_adjacent_bits<E: Clone + BitOrAssign + Shr<usize, Output = E>>(b: &mut E, n: usize) {
    for _ in 1..=n {
        *b |= b.clone() >> 1;
    }
}

macro_rules! test {
    ( $t:ident, $n:expr, $e:expr, $g:ty, $b:expr, $c:expr$(,)? ) => {
        #[test]
        fn $t() {
            let n: usize = $n;
            let e: usize = $e;
            let b_original: $g = $b;
            let mut b = b_original.clone();
            set_right_adjacent_bits(&mut b, n);
            println!("n = {n}; e = {e}:");
            println!("          b = {:0>e$b}", b_original);
            println!("     output = {:0>e$b}", b);
            assert_eq!(b, $c);
        }
    };
}

test!(test_a1, 2, 4, u8, 0b1000, 0b1110);
test!(test_a2, 2, 4, u8, 0b0100, 0b0111);
test!(test_a3, 2, 4, u8, 0b0010, 0b0011);
test!(test_a4, 2, 4, u8, 0b0000, 0b0000);
test!(
    test_b1, 0, 66, u128,
    0b010000000000100000000010000000010000000100000010000010000100010010,
    0b010000000000100000000010000000010000000100000010000010000100010010,
);
test!(
    test_b2, 1, 66, u128,
    0b010000000000100000000010000000010000000100000010000010000100010010,
    0b011000000000110000000011000000011000000110000011000011000110011011,
);
test!(
    test_b3, 2, 66, u128,
    0b010000000000100000000010000000010000000100000010000010000100010010,
    0b011100000000111000000011100000011100000111000011100011100111011111,
);
test!(
    test_b4, 3, 66, u128,
    0b010000000000100000000010000000010000000100000010000010000100010010,
    0b011110000000111100000011110000011110000111100011110011110111111111,
);
