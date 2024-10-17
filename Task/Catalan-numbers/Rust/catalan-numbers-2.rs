struct Catalan {
    catalans: Vec<i64>,
    n: i64,
}

impl Default for Catalan {
    fn default() -> Self {
        Catalan {
            catalans: vec![1],
            n: 1,
        }
    }
}

impl Iterator for Catalan {
    type Item = i64;

    fn next(&mut self) -> Option<Self::Item> {
        let c = *self.catalans.last().unwrap();
        let next = 2 * c * (2 * self.n - 1) / (self.n + 1);

        self.catalans.push(next);
        self.n += 1;

        Some(next)
    }
}

fn main() {
    for (i, catalan) in Catalan::default().take(15).enumerate() {
        println!("c_n({}) = {}", i, catalan);
    }
}
