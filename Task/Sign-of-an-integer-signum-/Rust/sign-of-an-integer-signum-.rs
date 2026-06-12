fn main() {
    println!("{:^10} {:^10}", "input", "output");
    for i in [-10i32, 42, 0] {
        println!("{i:^10} {:^10}", i.signum());
    }
    for f in [0.0, -0.0, f64::from_bits(0xFFF8_0000_0000_0000)] {
        println!("{f:^10} {:^10}", f.signum());
    }
}
