fn main() {
    let a: u8 = 105;
    let b: u8 = 91;
    println!("a      = {:0>8b}", a);
    println!("b      = {:0>8b}", b);
    println!("a | b  = {:0>8b}", a | b);
    println!("a & b  = {:0>8b}", a & b);
    println!("a ^ b  = {:0>8b}", a ^ b);
    println!("!a     = {:0>8b}", !a);
    println!("a << 3 = {:0>8b}", a << 3);
    println!("a >> 3 = {:0>8b}", a >> 3);
}
