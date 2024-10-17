pub struct CumulativeStandardDeviation {
    n: f64,
    sum: f64,
    sum_sq: f64
}

impl CumulativeStandardDeviation {
    pub fn new() -> Self {
        CumulativeStandardDeviation {
            n: 0.,
            sum: 0.,
            sum_sq: 0.
        }
    }

    fn push(&mut self, x: f64) -> f64 {
        self.n += 1.;
        self.sum += x;
        self.sum_sq += x * x;

        (self.sum_sq / self.n - self.sum * self.sum / self.n / self.n).sqrt()
    }
}

fn main() {
    let nums = [2, 4, 4, 4, 5, 5, 7, 9];

    let mut cum_stdev = CumulativeStandardDeviation::new();
    for num in nums.iter() {
        println!("{}", cum_stdev.push(*num as f64));
    }
}
