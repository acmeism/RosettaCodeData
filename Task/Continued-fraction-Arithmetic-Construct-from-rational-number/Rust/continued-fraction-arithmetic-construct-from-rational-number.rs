struct R2cf {
    n1: i64,
    n2: i64
}

// This iterator generates the continued fraction representation from the
// specified rational number.
impl Iterator for R2cf {
    type Item = i64;

    fn next(&mut self) -> Option<i64> {
        if self.n2 == 0 {
            None
        }
        else {
            let t1 = self.n1 / self.n2;
            let t2 = self.n2;
            self.n2 = self.n1 - t1 * t2;
            self.n1 = t2;
            Some(t1)
        }
    }
}

fn r2cf(n1: i64, n2: i64) -> R2cf {
    R2cf { n1: n1, n2: n2 }
}

macro_rules! printcf {
    ($x:expr, $y:expr) => (println!("{:?}", r2cf($x, $y).collect::<Vec<_>>()));
}

fn main() {
    printcf!(1, 2);
    printcf!(3, 1);
    printcf!(23, 8);
    printcf!(13, 11);
    printcf!(22, 7);
    printcf!(-152, 77);

    printcf!(14_142, 10_000);
    printcf!(141_421, 100_000);
    printcf!(1_414_214, 1_000_000);
    printcf!(14_142_136, 10_000_000);

    printcf!(31, 10);
    printcf!(314, 100);
    printcf!(3142, 1000);
    printcf!(31_428, 10_000);
    printcf!(314_285, 100_000);
    printcf!(3_142_857, 1_000_000);
    printcf!(31_428_571, 10_000_000);
    printcf!(314_285_714, 100_000_000);
}
