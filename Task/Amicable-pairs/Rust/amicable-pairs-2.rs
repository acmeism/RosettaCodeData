fn main() {
    const RANGE_MAX: u32 = 20_000;

    let proper_divs = |n: u32| -> Vec<u32> {
        (1..=(n + 1) / 2).filter(|&x| n % x == 0).collect()
    };

    let n2d: Vec<u32> = (1..=RANGE_MAX).map(|n| proper_divs(n).iter().sum()).collect();

    for (n, &div_sum) in n2d.iter().enumerate() {
        let n = n as u32 + 1;

        if n < div_sum && div_sum <= RANGE_MAX && n2d[div_sum as usize - 1] == n {
            println!("Amicable pair: {} and {} with proper divisors:", n, div_sum);
            println!("    {:?}", proper_divs(n));
            println!("    {:?}", proper_divs(div_sum));
        }
    }
}
