// [dependencies]
// primal = "0.3"
// rug = "1.15.0"

fn main() {
    println!("First 100 deceptive numbers:");
    use rug::Integer;
    let mut repunit = Integer::from(11);
    let mut n: u32 = 3;
    let mut count = 0;
    while count != 100 {
        if n % 3 != 0 && n % 5 != 0 && !primal::is_prime(n as u64) && repunit.is_divisible_u(n) {
            print!("{:6}", n);
            count += 1;
            if count % 10 == 0 {
                println!();
            } else {
                print!(" ");
            }
        }
        n += 2;
        repunit *= 100;
        repunit += 11;
    }
}
