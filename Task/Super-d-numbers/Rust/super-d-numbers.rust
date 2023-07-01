// [dependencies]
// rug = "1.9"

fn print_super_d_numbers(d: u32, limit: u32) {
    use rug::Assign;
    use rug::Integer;

    println!("First {} super-{} numbers:", limit, d);
    let digits = d.to_string().repeat(d as usize);
    let mut count = 0;
    let mut n = 1;
    let mut s = Integer::new();
    while count < limit {
        s.assign(Integer::u_pow_u(n, d));
        s *= d;
        if s.to_string().contains(&digits) {
            print!("{} ", n);
            count += 1;
        }
        n += 1;
    }
    println!();
}

fn main() {
    for d in 2..=9 {
        print_super_d_numbers(d, 10);
    }
}
