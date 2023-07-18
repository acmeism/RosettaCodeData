use ndhistogram::{Histogram, ndhistogram, axis::Uniform};
use rand::Rng;

/// change x in [0.0, 1.0) to a split with minimum probability at 0.5
fn modifier(x: f64) -> f64 {
    if x < 0.5 {
        return 2.0 * (0.5 - &x);
    } else {
        return 2.0 * (&x - 0.5);
    }
}

const WANTED: usize = 20_000;

fn main() {
    let mut hist = ndhistogram!(Uniform::new(19, -0.0, 1.0));
    let mut rng = rand::thread_rng();
    for _ in 0.. WANTED {
        loop {
            let x: f64 = rng.gen::<f64>();
            let y: f64 = rng.gen::<f64>();
            if y < modifier(x) {
                hist.fill(&f64::from(x));
                break;
            }
        }
    }
    println!("{}", hist);
}
