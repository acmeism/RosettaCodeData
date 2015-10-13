extern crate rand;
use rand::distributions::{Normal, IndependentSample};

fn main() {
    let mut rands = [0.0; 1000];
    let normal = Normal::new(1.0, 0.5);
    let mut rng = rand::thread_rng();
    for num in rands.iter_mut() {
        *num = normal.ind_sample(&mut rng);
    }
}
