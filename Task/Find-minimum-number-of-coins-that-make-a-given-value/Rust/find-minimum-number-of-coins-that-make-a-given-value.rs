fn main() {
    let denoms = vec![200, 100, 50, 20, 10, 5, 2, 1];
    let mut coins = 0;
    let amount = 988;
    let mut remaining = 988;
    println!("The minimum number of coins needed to make a value of {} is as follows:", amount);
    for denom in denoms.iter() {
        let n = remaining / denom;
        if n > 0 {
            coins += n;
            println!("  {} x {}", denom, n);
            remaining %= denom;
            if remaining == 0 {
                break;
            }
        }
    }
    println!("\nA total of {} coins in all.", coins);
}
