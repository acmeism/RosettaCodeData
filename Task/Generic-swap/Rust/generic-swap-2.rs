fn main() {
    let mut a: String = "Alice".to_owned();
    let mut b: String = "Bob".to_owned();
    let mut c: i32 = 1;
    let mut d: i32 = 2;

    generic_swap(&mut a, &mut b);
    generic_swap(&mut c, &mut d);

    println!("a={}, b={}", a, b);
    println!("c={}, d={}", c, d);
}
