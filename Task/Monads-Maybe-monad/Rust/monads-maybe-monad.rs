use std::collections::HashMap;

/// Returns the arithmetic square root of x, if it exists
fn arithmetic_square_root(x: u8) -> Option<u8> {
    // the number of perfect squares for u8 is so low you can just fit the entire list in memory
    let perfect_squares: HashMap<u8, u8> = HashMap::from([
        (0, 0),
        (1, 1),
        (4, 2),
        (9, 3),
        (16, 4),
        (25, 5),
        (36, 6),
        (49, 7),
        (64, 8),
        (81, 9),
        (100, 10),
        (121, 11),
        (144, 12),
        (169, 13),
        (196, 14),
        (225, 15),
    ]);

    // `HashMap::<K, V>::get(&self, &Q)` also returns a `Option<&V>`, we then turn it to `Option<V>`
    perfect_squares.get(&x).copied()
}


/// If x in base 10 is also a valid number when looking upside down, return a string slice for that
/// number upside down
fn upside_down_num(x: u8) -> Option<&'static str> {
    match x {
        0 => Some("0"),
        1 => Some("1"),
        6 => Some("9"),
        8 => Some("8"),
        9 => Some("6"),
        10 => Some("01"),
        11 => Some("11"),
        16 => Some("91"),
        _ => None
    }
}

fn main() {
    // if the number from 0 to 36 inclusive, is a perfect square and its square root is also a
    // valid number when looking upside down, then we will get a Some containing the string slice,
    // otherwise we get a None, indicating it's not a perfect square or the square root is not a
    // valid number while looking upside down
    (0..=36)
        .map(|x| arithmetic_square_root(x).and_then(upside_down_num))
        .enumerate()
        .for_each(|(i, upside_down_square_root)|
            println!("i = {i:02}, upside down square root = {upside_down_square_root:?}"));
}
