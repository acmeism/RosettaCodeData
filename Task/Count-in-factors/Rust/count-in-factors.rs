use std::env;

fn main() {
    let args: Vec<_> = env::args().collect();
    let n = if args.len() > 1 {
        args[1].parse().expect("Not a valid number to count to")
    }
    else {
        20
    };
    count_in_factors_to(n);
}

fn count_in_factors_to(n: u64) {
    println!("1");
    let mut primes = vec![];
    for i in 2..=n {
        let fs = factors(&primes, i);
        if fs.len() <= 1 {
            primes.push(i);
            println!("{}", i);
        }
        else {
            println!("{} = {}", i, fs.iter().map(|f| f.to_string()).collect::<Vec<String>>().join(" x "));
        }
    }
}

fn factors(primes: &[u64], mut n: u64) -> Vec<u64> {
    let mut result = Vec::new();
    for p in primes {
        while n % p == 0 {
            result.push(*p);
            n /= p;
        }
        if n == 1 {
            return result;
        }
    }
    vec![n]
}
