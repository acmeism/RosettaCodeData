struct SubtractiveGenerator {
    /// m in the formula
    modulo: i32,
    /// i and j in the formula
    offsets: (u32, u32),
    /// r in the formula. It is used as a ring buffer.
    state: Vec<i32>,
    /// n in the formula
    position: usize,
}

impl SubtractiveGenerator {
    fn new(modulo: i32, first_offset: u32, second_offset: u32) -> Self {
        // The state size has to fit into a usize to index state properly
        // without overflow.
        let state_size: usize = first_offset.try_into().unwrap();

        // Both offsets have to fit in i32 for the substractions to work
        // without overflow.
        assert!(first_offset <= i32::MAX as u32);
        assert!(first_offset > second_offset);
        SubtractiveGenerator {
            modulo,
            offsets: (first_offset, second_offset),
            state: Vec::with_capacity(state_size),
            position: 0,
        }
    }
}

impl Iterator for SubtractiveGenerator {
    type Item = i32;

    fn next(&mut self) -> Option<<Self as Iterator>::Item> {
        let state_size = self.offsets.0 as usize;

        assert_eq!(self.state.len(), state_size);

        self.position = (self.position + 1) % self.offsets.0 as usize;

        let i1 = (self.position as i32 - self.offsets.0 as i32).rem_euclid(state_size as i32);
        let i2 = (self.position as i32 - self.offsets.1 as i32).rem_euclid(state_size as i32);

        let p1 = self.state[i1 as usize];
        let p2 = self.state[i2 as usize];

        self.state[self.position] = (p1 - p2).rem_euclid(self.modulo);

        Some(self.state[self.position])
    }
}

/// Returns a pre-seeded subtractive generator, which generates the same
/// sequences as Bentley's generator, as used in xpat2.
fn get_seeded_xpat2_gen(seed: i32) -> SubtractiveGenerator {
    let mut gen = SubtractiveGenerator::new(1_000_000_000, 55, 24);

    let state_size = gen.offsets.0 as usize;

    let mut pre_state = Vec::with_capacity(state_size);
    pre_state.push(seed);
    pre_state.push(1);
    for i in 2..state_size {
        pre_state.push((pre_state[i - 2] - pre_state[i - 1]).rem_euclid(gen.modulo));
    }

    for i in 0..state_size {
        gen.state.push(pre_state[(34 * (i + 1)) % 55]);
    }

    gen.position = 54;
    for _ in 0..165 {
        gen.next();
    }

    gen
}

fn main() {
    let gen = get_seeded_xpat2_gen(292929);

    for n in gen.take(5) {
        println!("{}", n);
    }
}
