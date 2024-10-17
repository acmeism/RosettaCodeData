struct XorShiftStar {
    magic: u64,
    state: u64,
}

impl XorShiftStar {
    fn new() -> Self {
        Self {
            magic: 0x2545_F491_4F6C_DD1D,
            state: 0,
        }
    }

    fn seed(&mut self, num: u64) {
        self.state = num;
    }

    fn next_int(&mut self) -> u32 {
        let mut x = self.state;
        x ^= x >> 12;
        x ^= x << 25;
        x ^= x >> 27;
        self.state = x;
        ((x.wrapping_mul(self.magic)) >> 32) as u32
    }

    fn next_float(&mut self) -> f32 {
        self.next_int() as f32 / (1u64 << 32) as f32
    }
}

fn main() {
    let mut rng = XorShiftStar::new();
    rng.seed(1234567);
    println!("{}", rng.next_int());
    println!("{}", rng.next_int());
    println!("{}", rng.next_int());
    println!("{}", rng.next_int());
    println!("{}", rng.next_int());
    println!();

    let mut counts = [0; 5];
    rng.seed(987654321);
    for _ in 0..100000 {
        let j = (rng.next_float() * 5.0).floor() as usize;
        counts[j] += 1;
    }
    for (i, count) in counts.iter().enumerate() {
        println!("{}: {}", i, count);
    }
}
