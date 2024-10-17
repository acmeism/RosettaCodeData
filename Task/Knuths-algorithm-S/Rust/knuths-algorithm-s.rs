use rand::{Rng,weak_rng};

struct SofN<R: Rng+Sized, T> {
    rng: R,
    sample: Vec<T>,
    i: usize,
    n: usize,
}

impl<R: Rng, T> SofN<R, T> {
    fn new(rng: R, n: usize) -> Self {
        SofN{rng, sample: Vec::new(), i: 0, n}
    }

    fn add(&mut self, item: T) {
        self.i += 1;
        if self.i <= self.n {
            self.sample.push(item);
        } else if self.rng.gen_range(0, self.i) < self.n {
            self.sample[self.rng.gen_range(0, self.n)] = item;
        }
    }

    fn sample(&self) -> &Vec<T> {
        &self.sample
    }
}


pub fn main() {
    const MAX: usize = 10;
    let mut bin: [i32; MAX] = Default::default();
    for _ in 0..100000 {
        let mut s_of_n = SofN::new(weak_rng(), 3);

        for i in 0..MAX { s_of_n.add(i); }

        for s in s_of_n.sample() {
            bin[*s] += 1;
        }
    }

    for (i, x) in bin.iter().enumerate() {
        println!("frequency of {}: {}", i, x);
    }
}
