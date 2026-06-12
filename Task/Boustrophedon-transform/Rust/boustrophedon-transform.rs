use std::collections::HashMap;
use std::cell::RefCell;
use std::rc::Rc;

struct BoustrophedonIterator<F>
where
    F: Fn(u32) -> i64
{
    index: i32,
    sequence: F,
    cache: HashMap<u32, HashMap<u32, i64>>,
}

impl<F> BoustrophedonIterator<F>
where
    F: Fn(u32) -> i64
{
    fn new(sequence: F) -> Self {
        BoustrophedonIterator {
            index: -1,
            sequence,
            cache: HashMap::new(),
        }
    }

    fn next(&mut self) -> i64 {
        self.index += 1;
        let index = self.index as u32;
        self.transform(index, index)
    }

    fn transform(&mut self, k: u32, n: u32) -> i64 {
        if n == 0 {
            return (self.sequence)(k);
        }

        if let Some(inner_map) = self.cache.get(&k) {
            if let Some(&value) = inner_map.get(&n) {
                return value;
            }
        }

        let value = self.transform(k, n - 1) + self.transform(k - 1, k - n);

        self.cache.entry(k).or_insert_with(HashMap::new).insert(n, value);
        value
    }
}

fn main() {
    let primes = Rc::new(RefCell::new(Vec::<u32>::new()));
    let fibonacci_cache = Rc::new(RefCell::new(HashMap::<u32, i64>::new()));
    let factorial_cache = Rc::new(RefCell::new(HashMap::<u32, i64>::new()));

    sieve_primes(8_000, &mut primes.borrow_mut());

    display("One followed by an infinite series of zeros -> A000111", |number| one_one(number));

    display("An infinite series of ones -> A000667", |number| all_ones(number));

    display("(-1)^n: alternating 1, -1, 1, -1 -> A062162", |number| alternating(number));

    let primes_clone = Rc::clone(&primes);
    display("Sequence of prime numbers -> A000747", move |number| {
        prime(number, &primes_clone.borrow())
    });

    let fib_clone = Rc::clone(&fibonacci_cache);
    display("Sequence of Fibonacci numbers -> A000744", move |number| {
        fibonacci(number, &mut fib_clone.borrow_mut())
    });

    let fact_clone = Rc::clone(&factorial_cache);
    display("Sequence of factorial numbers -> A230960", move |number| {
        factorial(number, &mut fact_clone.borrow_mut())
    });
}

fn sieve_primes(limit: u32, primes: &mut Vec<u32>) {
    primes.push(2);
    let half_limit = (limit + 1) / 2;
    let mut composite = vec![false; half_limit as usize];

    let mut i = 1;
    let mut p = 3;

    while i < half_limit {
        if !composite[i as usize] {
            primes.push(p);
            let mut a = i + p;
            while a < half_limit {
                composite[a as usize] = true;
                a += p;
            }
        }
        p += 2;
        i += 1;
    }
}

fn one_one(number: u32) -> i64 {
    if number == 0 { 1 } else { 0 }
}

fn all_ones(_number: u32) -> i64 {
    1
}

fn alternating(number: u32) -> i64 {
    if number % 2 == 0 { 1 } else { -1 }
}

fn prime(number: u32, primes: &[u32]) -> i64 {
    primes[number as usize] as i64
}

fn fibonacci(number: u32, cache: &mut HashMap<u32, i64>) -> i64 {
    if !cache.contains_key(&number) {
        let value = if number == 0 || number == 1 {
            1
        } else {
            fibonacci(number - 2, cache) + fibonacci(number - 1, cache)
        };
        cache.insert(number, value);
    }
    *cache.get(&number).unwrap()
}

fn factorial(number: u32, cache: &mut HashMap<u32, i64>) -> i64 {
    if !cache.contains_key(&number) {
        let mut value = 1;
        for i in 2..=number {
            value *= i as i64;
        }
        cache.insert(number, value);
    }
    *cache.get(&number).unwrap()
}

fn display<F>(title: &str, sequence: F)
where
    F: Fn(u32) -> i64,
{
    println!("{}", title);
    let mut iterator = BoustrophedonIterator::new(sequence);
    for _ in 1..=15 {
        print!("{} ", iterator.next());
    }
    println!("\n");
}
