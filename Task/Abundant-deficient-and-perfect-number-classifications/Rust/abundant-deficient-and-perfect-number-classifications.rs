fn main() {
    // deficient starts at 1 because 1 is deficient but proper_divisors returns
    // and empty Vec
    let (mut abundant, mut deficient, mut perfect) = (0u32, 1u32, 0u32);
    for i in 1..20_001 {
        if let Some(divisors) = i.proper_divisors() {
            let sum: u64 = divisors.iter().sum();
            if sum < i {
                deficient += 1
            } else if sum > i {
                abundant += 1
            } else {
                perfect += 1
            }
        }
    }
    println!("deficient:\t{:5}\nperfect:\t{:5}\nabundant:\t{:5}",
             deficient, perfect, abundant);
}
