extern crate rand;

pub use rand::{Rng, SeedableRng};

pub struct BsdLcg {
    state: u32,
}

impl Rng for BsdLcg {
    // Because the output is in the range [0, 2147483647], this should technically be `next_u16`
    // (the largest integer size which is fully covered, as `rand::Rng` assumes).  The `rand`
    // crate does not provide it however.  If serious usage is required, implementing this
    // function as a concatenation of two `next_u16`s (elsewhere defined) should work.
    fn next_u32(&mut self) -> u32 {
        self.state = self.state.wrapping_mul(1_103_515_245).wrapping_add(12_345);
        self.state %= 1 << 31;
        self.state
    }
}

impl SeedableRng<u32> for BsdLcg {
    fn from_seed(seed: u32) -> Self {
        Self { state: seed }
    }
    fn reseed(&mut self, seed: u32) {
        self.state = seed;
    }
}

pub struct MsLcg {
    state: u32,
}

impl Rng for MsLcg {
    // Similarly, this outputs in the range [0, 32767] and should output a `u8`.  Concatenate
    // four `next_u8`s for serious usage.
    fn next_u32(&mut self) -> u32 {
        self.state = self.state.wrapping_mul(214_013).wrapping_add(2_531_011);
        self.state %= 1 << 31;
        self.state >> 16 // rand_n = state_n / 2^16
    }
}

impl SeedableRng<u32> for MsLcg {
    fn from_seed(seed: u32) -> Self {
        Self { state: seed }
    }
    fn reseed(&mut self, seed: u32) {
        self.state = seed;
    }
}

fn main() {
    println!("~~~ BSD ~~~");
    let mut bsd = BsdLcg::from_seed(0);
    for _ in 0..10 {
        println!("{}", bsd.next_u32());
    }

    println!("~~~ MS ~~~");
    let mut ms = MsLcg::from_seed(0);
    for _ in 0..10 {
        println!("{}", ms.next_u32());
    }

    // Because we have implemented the `rand::Rng` trait, we can generate a variety of other types.
    println!("~~~ Others ~~~");
    println!("{:?}", ms.gen::<[u32; 5]>());
    println!("{}", ms.gen::<bool>());
    println!("{}", ms.gen_ascii_chars().take(15).collect::<String>());
}
