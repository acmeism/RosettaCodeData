fn main() {
    println!(
        "Parse from plain decimal: {}",
        "123".parse::<u32>().unwrap()
    );

    println!(
        "Parse with a given radix (2-36 supported): {}",
        u32::from_str_radix("deadbeef", 16).unwrap()
    );
}
