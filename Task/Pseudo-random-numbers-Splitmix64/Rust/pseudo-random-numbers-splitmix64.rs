struct Splitmix64 {
    state: u64,
    two_power_64: f64,
}

impl Splitmix64 {
    fn new() -> Self {
        Splitmix64 {
            state: 0,
            two_power_64: (2.0_f64).powi(64),
        }
    }

    fn with_seed(seed: u64) -> Self {
        Splitmix64 {
            state: seed,
            two_power_64: (2.0_f64).powi(64),
        }
    }

    fn seed(&mut self, seed: u64) {
        self.state = seed;
    }

    fn next_int(&mut self) -> u64 {
        let mut z = self.state.wrapping_add(0x9e3779b97f4a7c15);
        self.state = z;
        z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
        z ^ (z >> 31)
    }

    fn next_float(&mut self) -> f64 {
        self.next_int() as f64 / self.two_power_64
    }
}

fn main() {
    let mut random = Splitmix64::new();
    random.seed(1234567);
    for _i in 0..5 {
        println!("{}", random.next_int());
    }
    println!();

    let mut rand = Splitmix64::with_seed(987654321);
    let mut counts = vec![0_u32; 5];
    for _i in 0..100_000 {
        let value = (rand.next_float() * 5.0).floor() as u32;
        counts[value as usize] += 1;
    }

    for i in 0..5 {
        print!("{}: {}   ", i, counts[i as usize]);
    }
    println!();
}
