fn format_with_radix(mut n: u32, radix: u32) -> String {
    assert!(2 <= radix && radix <= 36);

    let mut result = String::new();

    loop {
        result.push(std::char::from_digit(n % radix, radix).unwrap());
        n /= radix;
        if n == 0 {
            break;
        }
    }

    result.chars().rev().collect()
}

#[cfg(test)]
#[test]
fn test() {
    for value in 0..100u32 {
        for radix in 2..=36 {
            let s = format_with_radix(value, radix);
            let v = u32::from_str_radix(s.as_str(), radix).unwrap();
            assert_eq!(value, v);
        }
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("{}", format_with_radix(0xdeadbeef, 2));
    println!("{}", format_with_radix(0xdeadbeef, 36));
    println!("{}", format_with_radix(0xdeadbeef, 16));
    println!("{}", u32::from_str_radix("DeadBeef", 16)?);
    Ok(())
}
