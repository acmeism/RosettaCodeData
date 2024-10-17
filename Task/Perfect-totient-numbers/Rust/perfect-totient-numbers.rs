use num::integer::gcd;

static mut CACHE:[i32;10000] = [0; 10000];

fn is_perfect_totient(n: i32) -> bool {
    let mut  tot = 0;
    for i in 1..n {
        if gcd(n, i) == 1 {
            tot += 1
        }
    }
    unsafe {
        let sum = tot + CACHE[tot as usize];
        CACHE[n as usize] = sum;
        return n == sum;
    }
}

fn main() {
    let mut i = 1;
    let mut count = 0;
    while count < 20 {
        if is_perfect_totient(i) {
            print!("{} ", i);
            count += 1;
        }
        i += 1;
    }
    println!("{}", " ")
}
