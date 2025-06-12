fn mod_fn(x: i64, y: i64) -> i64 {
    let m = x % y;
    if m < 0 {
        if y < 0 {
            return m - y;
        } else {
            return m + y;
        }
    }
    m
}

struct RNG {
    // First generator
    a1: [i64; 3],
    m1: i64,
    x1: [i64; 3],
    // Second generator
    a2: [i64; 3],
    m2: i64,
    x2: [i64; 3],
    // other
    d: i64,
}

impl RNG {
    fn new() -> RNG {
        RNG {
            a1: [0, 1403580, -810728],
            m1: (1i64 << 32) - 209,
            x1: [0, 0, 0],
            a2: [527612, 0, -1370589],
            m2: (1i64 << 32) - 22853,
            x2: [0, 0, 0],
            d: (1i64 << 32) - 209 + 1,
        }
    }

    fn seed(&mut self, state: i64) {
        self.x1 = [state, 0, 0];
        self.x2 = [state, 0, 0];
    }

    fn next_int(&mut self) -> i64 {
        let x1i = mod_fn(
            self.a1[0] * self.x1[0] + self.a1[1] * self.x1[1] + self.a1[2] * self.x1[2],
            self.m1,
        );
        let x2i = mod_fn(
            self.a2[0] * self.x2[0] + self.a2[1] * self.x2[1] + self.a2[2] * self.x2[2],
            self.m2,
        );
        let z = mod_fn(x1i - x2i, self.m1);

        // keep last three values of the first generator
        self.x1 = [x1i, self.x1[0], self.x1[1]];
        // keep last three values of the second generator
        self.x2 = [x2i, self.x2[0], self.x2[1]];

        z + 1
    }

    fn next_float(&mut self) -> f64 {
        self.next_int() as f64 / self.d as f64
    }
}

fn main() {
    let mut rng = RNG::new();

    rng.seed(1234567);
    println!("{}", rng.next_int());
    println!("{}", rng.next_int());
    println!("{}", rng.next_int());
    println!("{}", rng.next_int());
    println!("{}", rng.next_int());
    println!();

    let mut counts: [i32; 5] = [0, 0, 0, 0, 0];
    rng.seed(987654321);
    for _i in 0..100000 {
        let value = (rng.next_float() * 5.0).floor() as usize;
        counts[value] += 1;
    }

    for i in 0..counts.len() {
        println!("{}: {}", i, counts[i]);
    }
}
