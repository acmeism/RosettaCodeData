fn is_vile(n: u64) -> bool {
    n.trailing_zeros() % 2 == 0
}

fn is_dopey(n: u64) -> bool {
    n.trailing_zeros() % 2 != 0
}

fn main() {
    let vile_numbers: Vec<u64> = (1..=100)
        .filter(|&n| is_vile(n))
        .take(25)
        .collect();
    println!("First 25 vile numbers:");
    println!("{:?}", vile_numbers);

    let dopey_numbers: Vec<u64> = (1..=100)
        .filter(|&n| is_dopey(n))
        .take(25)
        .collect();
    println!("\nFirst 25 dopey numbers:");
    println!("{:?}", dopey_numbers);

    println!("\n   N   Viles Dopeys");
    println!("{}", "_".repeat(18));
    for i in 0..10 {
        let n = 2u64 << i;
        let viles_count = (1..=n).filter(|&x| is_vile(x)).count();
        let dopey_count = n as usize - viles_count;
        println!("{:>4} {:>6} {:>6}", n, viles_count, dopey_count);
    }
}
