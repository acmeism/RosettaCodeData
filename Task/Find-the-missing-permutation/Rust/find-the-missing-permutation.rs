const GIVEN_PERMUTATIONS: [&str; 23] = [
    "ABCD",
    "CABD",
    "ACDB",
    "DACB",
    "BCDA",
    "ACBD",
    "ADCB",
    "CDAB",
    "DABC",
    "BCAD",
    "CADB",
    "CDBA",
    "CBAD",
    "ABDC",
    "ADBC",
    "BDCA",
    "DCBA",
    "BACD",
    "BADC",
    "BDAC",
    "CBDA",
    "DBCA",
    "DCAB"
];

fn main() {

    const PERMUTATION_LEN: usize = GIVEN_PERMUTATIONS[0].len();
    let mut bytes_result: [u8; PERMUTATION_LEN] = [0; PERMUTATION_LEN];

    for permutation in &GIVEN_PERMUTATIONS {
        for (i, val) in permutation.bytes().enumerate() {
            bytes_result[i] ^= val;
        }
    }
    println!("{}", std::str::from_utf8(&bytes_result).unwrap());
}
