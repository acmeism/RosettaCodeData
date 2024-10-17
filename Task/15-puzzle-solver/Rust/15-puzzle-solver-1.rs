const NR: [i32; 16] = [3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3];
const NC: [i32; 16] = [3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2];

const I: u8 = 1;
const G: u8 = 8;
const E: u8 = 2;
const L: u8 = 4;

struct FifteenSolver {
    n: usize,
    limit: usize,
    n0: [i32; 85],
    n3: [u8; 85],
    n4: [usize; 85],
    n2: [u64; 85],
}

impl FifteenSolver {
    fn f_y(&mut self) -> bool {
        if self.n2[self.n] == 0x123456789abcdef0 {
            return true;
        }
        if self.n4[self.n] <= self.limit {
            return self.f_n();
        }
        false
    }

    fn f_z(&mut self, w: u8) -> bool {
        if w & I != 0 {
            self.f_i();
            if self.f_y() {
                return true;
            }
            self.n -= 1;
        }
        if w & G != 0 {
            self.f_g();
            if self.f_y() {
                return true;
            }
            self.n -= 1;
        }
        if w & E != 0 {
            self.f_e();
            if self.f_y() {
                return true;
            }
            self.n -= 1;
        }
        if w & L != 0 {
            self.f_l();
            if self.f_y() {
                return true;
            }
            self.n -= 1;
        }
        false
    }

    fn f_n(&mut self) -> bool {
        self.f_z(match self.n0[self.n] {
            0 => match self.n3[self.n] {
                b'l' => I,
                b'u' => E,
                _ => I + E,
            },
            3 => match self.n3[self.n] {
                b'r' => I,
                b'u' => L,
                _ => I + L,
            },
            1 | 2 => match self.n3[self.n] {
                b'l' => I + L,
                b'r' => I + E,
                b'u' => E + L,
                _ => L + E + I,
            },
            12 => match self.n3[self.n] {
                b'l' => G,
                b'd' => E,
                _ => E + G,
            },
            15 => match self.n3[self.n] {
                b'r' => G,
                b'd' => L,
                _ => G + L,
            },
            13 | 14 => match self.n3[self.n] {
                b'l' => G + L,
                b'r' => E + G,
                b'd' => E + L,
                _ => G + E + L,
            },
            4 | 8 => match self.n3[self.n] {
                b'l' => I + G,
                b'u' => G + E,
                b'd' => I + E,
                _ => I + G + E,
            },
            7 | 11 => match self.n3[self.n] {
                b'd' => I + L,
                b'u' => G + L,
                b'r' => I + G,
                _ => I + G + L,
            },
            _ => match self.n3[self.n] {
                b'd' => I + E + L,
                b'l' => I + G + L,
                b'r' => I + G + E,
                b'u' => G + E + L,
                _ => I + G + E + L,
            },
        })
    }

    fn f_i(&mut self) {
        let g = (11 - self.n0[self.n]) * 4;
        let a = self.n2[self.n] & (15u64 << g);
        self.n0[self.n + 1] = self.n0[self.n] + 4;
        self.n2[self.n + 1] = self.n2[self.n] - a + (a << 16);
        self.n3[self.n + 1] = b'd';
        self.n4[self.n + 1] = self.n4[self.n];
        let cond = NR[(a >> g) as usize] <= self.n0[self.n] / 4;
        if !cond {
            self.n4[self.n + 1] += 1;;
        }
        self.n += 1;
    }

    fn f_g(&mut self) {
        let g = (19 - self.n0[self.n]) * 4;
        let a = self.n2[self.n] & (15u64 << g);
        self.n0[self.n + 1] = self.n0[self.n] - 4;
        self.n2[self.n + 1] = self.n2[self.n] - a + (a >> 16);
        self.n3[self.n + 1] = b'u';
        self.n4[self.n + 1] = self.n4[self.n];
        let cond = NR[(a >> g) as usize] >= self.n0[self.n] / 4;
        if !cond {
            self.n4[self.n + 1] += 1;
        }
        self.n += 1;
    }

    fn f_e(&mut self) {
        let g = (14 - self.n0[self.n]) * 4;
        let a = self.n2[self.n] & (15u64 << g);
        self.n0[self.n + 1] = self.n0[self.n] + 1;
        self.n2[self.n + 1] = self.n2[self.n] - a + (a << 4);
        self.n3[self.n + 1] = b'r';
        self.n4[self.n + 1] = self.n4[self.n];
        let cond = NC[(a >> g) as usize] <= self.n0[self.n] % 4;
        if !cond {
            self.n4[self.n + 1] += 1;
        }
        self.n += 1;
    }

    fn f_l(&mut self) {
        let g = (16 - self.n0[self.n]) * 4;
        let a = self.n2[self.n] & (15u64 << g);
        self.n0[self.n + 1] = self.n0[self.n] - 1;
        self.n2[self.n + 1] = self.n2[self.n] - a + (a >> 4);
        self.n3[self.n + 1] = b'l';
        self.n4[self.n + 1] = self.n4[self.n];
        let cond = NC[(a >> g) as usize] >= self.n0[self.n] % 4;
        if !cond {
            self.n4[self.n + 1] += 1;
        }
        self.n += 1;
    }

    fn new(n: i32, g: u64) -> Self {
        let mut solver = FifteenSolver {
            n: 0,
            limit: 0,
            n0: [0; 85],
            n3: [0; 85],
            n4: [0; 85],
            n2: [0; 85],
        };
        solver.n0[0] = n;
        solver.n2[0] = g;
        solver
    }

    fn solve(&mut self) {
        while !self.f_n() {
            self.n = 0;
            self.limit += 1;
        }
        println!(
            "Solution found in {} moves: {}",
            self.n,
            std::str::from_utf8(&self.n3[1..=self.n]).unwrap()
        );
    }
}

fn main() {
    FifteenSolver::new(8, 0xfe169b4c0a73d852).solve();
}
