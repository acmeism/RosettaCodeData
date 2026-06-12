fn rice_encode(n: i32, k: u32, extended: bool) -> String {
    let mut value = n;
    if extended {
        value = if n < 0 { -2 * n - 1 } else { 2 * n };
    }

    assert!(value >= 0, "n must be non-negative");

    let m = 2_i32.pow(k);
    let q = value / m;
    let r = value % m;

    // Create q ones
    let ones = "1".repeat(q as usize);

    // Format r as binary with k+1 bits
    let r_binary = format!("{:0width$b}", r, width = (k + 1) as usize);

    ones + &r_binary
}

fn rice_decode(a: &str, k: u32, extended: bool) -> i32 {
    let m = 2_i32.pow(k);

    // Find the first '0'
    let q = a.find('0').unwrap_or(0);

    // Parse the remainder
    let r = i32::from_str_radix(&a[q..], 2).unwrap();

    let mut i = (q as i32) * m + r;

    if extended {
        i = if i % 2 != 0 { -((i + 1) / 2) } else { i / 2 };
    }

    i
}

fn main() {
    println!("Base Rice Coding:");
    for n in 0..=10 {
        let s = rice_encode(n, 2, false);
        println!("{} -> {} -> {}", n, s, rice_decode(&s, 2, false));
    }

    println!("Extended Rice Coding:");
    for n in -10..=10 {
        let s = rice_encode(n, 2, true);
        println!("{} -> {} -> {}", n, s, rice_decode(&s, 2, true));
    }
}
