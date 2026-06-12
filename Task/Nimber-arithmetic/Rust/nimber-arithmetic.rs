// highest power of 2 that divides a given number
fn hpo2(n: u32) -> u32 {
    n & (0xFFFFFFFF - n + 1)
}

// base 2 logarithm of the highest power of 2 dividing a given number
fn lhpo2(n: u32) -> u32 {
    let mut q: u32 = 0;
    let mut m: u32 = hpo2(n);
    while m % 2 == 0 {
        m >>= 1;
        q += 1;
    }
    q
}

// nim-sum of two numbers
fn nimsum(x: u32, y: u32) -> u32 {
    x ^ y
}

// nim-product of two numbers
fn nimprod(x: u32, y: u32) -> u32 {
    if x < 2 || y < 2 {
        return x * y;
    }
    let mut h: u32 = hpo2(x);
    if x > h {
        return nimprod(h, y) ^ nimprod(x ^ h, y);
    }
    if hpo2(y) < y {
        return nimprod(y, x);
    }
    let xp: u32 = lhpo2(x);
    let yp: u32 = lhpo2(y);
    let comp: u32 = xp & yp;
    if comp == 0 {
        return x * y;
    }
    h = hpo2(comp);
    nimprod(nimprod(x >> h, y >> h), 3 << (h - 1))
}

fn print_table(n: u32, op: char, func: fn(u32, u32) -> u32) {
    print!(" {} |", op);
    for a in 0..=n {
        print!("{:3}", a);
    }
    print!("\n--- -");
    for _ in 0..=n {
        print!("---");
    }
    println!();
    for b in 0..=n {
        print!("{:2} |", b);
        for a in 0..=n {
            print!("{:3}", func(a, b));
        }
        println!();
    }
}

fn main() {
    print_table(15, '+', nimsum);
    println!();
    print_table(15, '*', nimprod);
    let a: u32 = 21508;
    let b: u32 = 42689;
    println!("\n{} + {} = {}", a, b, nimsum(a, b));
    println!("{} * {} = {}", a, b, nimprod(a, b));
}
