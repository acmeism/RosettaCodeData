fn main() {
    println!("5**3**2   = {:7}", 5u32.pow(3).pow(2));
    println!("(5**3)**2 = {:7}", (5u32.pow(3)).pow(2));
    println!("5**(3**2) = {:7}", 5u32.pow(3u32.pow(2)));
}
