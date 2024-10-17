extern crate rand;

use std::sync::{Arc, Mutex};
use std::thread;
use std::cmp;
use std::time::Duration;

use rand::Rng;
use rand::distributions::{IndependentSample, Range};

trait Buckets {
    fn equalize<R:Rng>(&mut self, rng: &mut R);
    fn randomize<R:Rng>(&mut self, rng: &mut R);
    fn print_state(&self);
}

impl Buckets for [i32] {
    fn equalize<R:Rng>(&mut self, rng: &mut R) {
        let range = Range::new(0,self.len()-1);
        let src = range.ind_sample(rng);
        let dst = range.ind_sample(rng);
        if dst != src {
            let amount = cmp::min(((dst + src) / 2) as i32, self[src]);
            let multiplier = if amount >= 0 { -1 } else { 1 };
            self[src] += amount * multiplier;
            self[dst] -= amount * multiplier;
        }
    }
    fn randomize<R:Rng>(&mut self, rng: &mut R) {
        let ind_range = Range::new(0,self.len()-1);
        let src = ind_range.ind_sample(rng);
        let dst = ind_range.ind_sample(rng);
        if dst != src {
            let amount = cmp::min(Range::new(0,20).ind_sample(rng), self[src]);
            self[src] -= amount;
            self[dst] += amount;

        }
    }
    fn print_state(&self) {
        println!("{:?} = {}", self, self.iter().sum::<i32>());
    }
}

fn main() {
    let e_buckets = Arc::new(Mutex::new([10; 10]));
    let r_buckets = e_buckets.clone();
    let p_buckets = e_buckets.clone();

    thread::spawn(move || {
        let mut rng = rand::thread_rng();
        loop {
            let mut buckets = e_buckets.lock().unwrap();
            buckets.equalize(&mut rng);
        }
    });
    thread::spawn(move || {
        let mut rng = rand::thread_rng();
        loop {
            let mut buckets = r_buckets.lock().unwrap();
            buckets.randomize(&mut rng);
        }
    });

    let sleep_time = Duration::new(1,0);
    loop {
        {
            let buckets = p_buckets.lock().unwrap();
            buckets.print_state();
        }
        thread::sleep(sleep_time);
    }
}
