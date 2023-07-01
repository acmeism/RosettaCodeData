// [dependencies]
// primal = "0.3"

use std::collections::BTreeMap;

struct ErdosSelfridge {
    primes: Vec<usize>,
    category: Vec<u32>,
}

impl ErdosSelfridge {
    fn new(limit: usize) -> ErdosSelfridge {
        let mut es = ErdosSelfridge {
            primes: primal::Primes::all().take(limit).collect(),
            category: Vec::new(),
        };
        es.category.resize(es.primes.len(), 0);
        es
    }

    fn get_category(&mut self, index: usize) -> u32 {
        if self.category[index] != 0 {
            return self.category[index];
        }
        let mut max_category = 0;
        let mut n = self.primes[index] + 1;
        for i in 0.. {
            let p = self.primes[i];
            if p * p > n {
                break;
            }
            let mut count = 0;
            while n % p == 0 {
                n /= p;
                count += 1;
            }
            if count != 0 {
                let category = if p <= 3 { 1 } else { 1 + self.get_category(i) };
                max_category = std::cmp::max(max_category, category);
            }
        }
        if n > 1 {
            let i = self.get_index(n);
            let category = if n <= 3 { 1 } else { 1 + self.get_category(i) };
            max_category = std::cmp::max(max_category, category);
        }
        self.category[index] = max_category;
        max_category
    }

    fn get_index(&self, prime: usize) -> usize {
        self.primes.binary_search(&prime).unwrap()
    }

    fn get_primes_by_category(&mut self, limit: usize) -> BTreeMap<u32, Vec<usize>> {
        let mut primes_by_category: BTreeMap<u32, Vec<usize>> = BTreeMap::new();
        for i in 0..limit {
            let category = self.get_category(i);
            let prime = self.primes[i];
            if let Some(primes) = primes_by_category.get_mut(&category) {
                primes.push(prime);
            } else {
                let mut primes = Vec::new();
                primes.push(prime);
                primes_by_category.insert(category, primes);
            }
        }
        primes_by_category
    }
}

fn main() {
    let mut es = ErdosSelfridge::new(1000000);
    let primes_by_category = es.get_primes_by_category(200);
    println!("First 200 primes:");
    for (category, primes) in primes_by_category.iter() {
        println!("Category {}:", category);
        for i in 0..primes.len() {
            print!(
                "{:4}{}",
                primes[i],
                if (i + 1) % 15 == 0 { "\n" } else { " " }
            );
        }
        print!("\n\n");
    }
    println!("First 1,000,000 primes:");
    let primes_by_category = es.get_primes_by_category(1000000);
    for (category, primes) in primes_by_category.iter() {
        let first = primes[0];
        let count = primes.len();
        let last = primes[count - 1];
        println!(
            "Category {:2}: first = {:7}  last = {:8}  count = {}",
            category, first, last, count
        );
    }
}
