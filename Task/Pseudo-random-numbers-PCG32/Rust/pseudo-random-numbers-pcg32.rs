struct PCG32 {
    multiplier: u64,
    state: u64,
    inc: u64,
}

impl PCG32 {
    fn new() -> Self {
        PCG32 {
            multiplier: 6364136223846793005,
            state: 0x853c49e6748fea9b,
            inc: 0xda3e39cb94b95bdb,
        }
    }

    fn next_int(&mut self) -> u32 {
        let old = self.state;
        self.state = old.wrapping_mul(self.multiplier).wrapping_add(self.inc);
        let xorshifted = (((old >> 18) ^ old) >> 27) as u32;
        let rot = (old >> 59) as u32;
        (xorshifted >> rot) | (xorshifted << ((!rot).wrapping_add(1) & 31))
    }

    fn next_float(&mut self) -> f64 {
        (self.next_int() as f64) / ((1u64 << 32) as f64)
    }

    fn seed(&mut self, seed_state: u64, seed_sequence: u64) {
        self.state = 0;
        self.inc = (seed_sequence << 1) | 1;
        self.next_int();
        self.state = self.state.wrapping_add(seed_state);
        self.next_int();
    }
}

fn main() {
    let mut rng = PCG32::new();

    rng.seed(42, 54);
    for _ in 0..5 {
        println!("{}", rng.next_int());
    }

    println!();

    let mut counts = [0; 5];
    rng.seed(987654321, 1);
    for _ in 0..100000 {
        let j = (rng.next_float() * 5.0).floor() as usize;
        counts[j] += 1;
    }

    println!("The counts for 100,000 repetitions are:");
    for (i, count) in counts.iter().enumerate() {
        println!("  {} : {}", i, count);
    }
}
