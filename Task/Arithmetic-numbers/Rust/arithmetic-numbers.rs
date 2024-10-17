fn divisor_count_and_sum(mut n: u32) -> (u32, u32) {
    let mut divisor_count = 1;
    let mut divisor_sum = 1;
    let mut power = 2;
    while (n & 1) == 0 {
        divisor_count += 1;
        divisor_sum += power;
        power <<= 1;
        n >>= 1;
    }
    let mut p = 3;
    while p * p <= n {
        let mut count = 1;
        let mut sum = 1;
        power = p;
        while n % p == 0 {
            count += 1;
            sum += power;
            power *= p;
            n /= p;
        }
        divisor_count *= count;
        divisor_sum *= sum;
        p += 2;
    }
    if n > 1 {
        divisor_count *= 2;
        divisor_sum *= n + 1;
    }
    (divisor_count, divisor_sum)
}

fn main() {
    let mut arithmetic_count = 0;
    let mut composite_count = 0;
    let mut n = 1;
    while arithmetic_count <= 1000000 {
        let (divisor_count, divisor_sum) = divisor_count_and_sum(n);
        if divisor_sum % divisor_count != 0 {
            n += 1;
            continue;
        }
        arithmetic_count += 1;
        if divisor_count > 2 {
            composite_count += 1;
        }
        if arithmetic_count <= 100 {
            print!("{:3} ", n);
            if arithmetic_count % 10 == 0 {
                println!();
            }
        }
        if arithmetic_count == 1000
            || arithmetic_count == 10000
            || arithmetic_count == 100000
            || arithmetic_count == 1000000
        {
            println!("\n{}th arithmetic number is {}", arithmetic_count, n);
            println!(
                "Number of composite arithmetic numbers <= {}: {}",
                n, composite_count
            );
        }
        n += 1;
    }
}
