fn get_digits(mut n: u128) -> [usize; 10] {
    let mut digits = [0; 10];
    while n > 0 {
        digits[(n % 10) as usize] += 1;
        n /= 10;
    }
    digits
}

fn magic_numbers() -> impl std::iter::Iterator<Item = u128> {
    let mut magic: Vec<u128> = vec![0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
    let mut index = 0;
    let mut digits = 2;
    std::iter::from_fn(move || {
        if index == magic.len() {
            let mut magic_new: Vec<u128> = Vec::new();
            for &m in &magic {
                if m == 0 {
                    continue;
                }
                let mut n = 10 * m;
                for _ in 0..10 {
                    if n % digits == 0 {
                        magic_new.push(n);
                    }
                    n += 1;
                }
            }
            index = 0;
            digits += 1;
            magic = magic_new;
        }
        if magic.is_empty() {
            return None;
        }
        let m = magic[index];
        index += 1;
        Some(m)
    })
}

fn main() {
    let mut count = 0;
    let mut dcount = 0;
    let mut magic: u128 = 0;
    let mut p: u128 = 10;
    let digits0 = [1; 10];
    let digits1 = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1];
    let mut pandigital0: Vec<u128> = Vec::new();
    let mut pandigital1: Vec<u128> = Vec::new();
    let mut digit_count: Vec<usize> = Vec::new();
    for m in magic_numbers() {
        magic = m;
        if magic >= p {
            p *= 10;
            digit_count.push(dcount);
            dcount = 0;
        }
        let digits = get_digits(magic);
        if digits == digits0 {
            pandigital0.push(magic);
        } else if digits == digits1 {
            pandigital1.push(magic);
        }
        count += 1;
        dcount += 1;
    }
    digit_count.push(dcount);
    println!("There are {} magic numbers.\n", count);
    println!("The largest magic number is {}.\n", magic);
    println!("Magic number count by digits:");
    for (i, c) in digit_count.iter().enumerate() {
        println!("{}\t{}", i + 1, c);
    }
    println!("\nMagic numbers that are minimally pandigital in 1-9:");
    for m in pandigital1 {
        println!("{}", m);
    }
    println!("\nMagic numbers that are minimally pandigital in 0-9:");
    for m in pandigital0 {
        println!("{}", m);
    }
}
