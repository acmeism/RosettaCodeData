fn main() {
    for x in 1u32..31 {
        let n = x.ilog2() + 1;
        println!("{:>3}  {0:b}", x << n | x);
    }
}
