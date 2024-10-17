extern crate rand;
use rand::distributions::{Normal, IndependentSample};

fn main() {
    let rands: Vec<_> = {
        let normal = Normal::new(1.0, 0.5);
        let mut rng = rand::thread_rng();
        (0..1000).map(|_| normal.ind_sample(&mut rng)).collect()
    };
}
