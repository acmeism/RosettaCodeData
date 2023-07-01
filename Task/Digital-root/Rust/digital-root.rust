fn sum_digits(mut n: u64, base: u64) -> u64 {
    let mut sum = 0u64;
    while n > 0 {
        sum = sum + (n % base);
        n = n / base;
    }
    sum
}

// Returns tuple of (additive-persistence, digital-root)
fn digital_root(mut num: u64, base: u64) -> (u64, u64) {
    let mut pers = 0;
    while num >= base {
        pers = pers + 1;
        num = sum_digits(num, base);
    }
    (pers, num)
}

fn main() {

    // Test base 10
    let values = [627615u64, 39390u64, 588225u64, 393900588225u64];
    for &value in values.iter() {
        let (pers, root) = digital_root(value, 10);
        println!("{} has digital root {} and additive persistance {}",
                 value,
                 root,
                 pers);
    }

    println!("");

    // Test base 16
    let values_base16 = [0x7e0, 0x14e344, 0xd60141, 0x12343210];
    for &value in values_base16.iter() {
        let (pers, root) = digital_root(value, 16);
        println!("0x{:x} has digital root 0x{:x} and additive persistance 0x{:x}",
                 value,
                 root,
                 pers);
    }
}
