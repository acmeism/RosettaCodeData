fn chowla(n: usize) -> usize {
    let mut sum = 0;
    let mut i = 2;
    while i * i <= n {
        if n % i == 0 {
            sum += i;
            let j = n / i;
            if i != j {
                sum += j;
            }
        }
        i += 1;
    }
    sum
}

fn sieve(limit: usize) -> Vec<bool> {
    let mut c = vec![false; limit];
    let mut i = 3;
    while i * i < limit {
        if !c[i] && chowla(i) == 0 {
            let mut j = 3 * i;
            while j < limit {
                c[j] = true;
                j += 2 * i;
            }
        }
        i += 2;
    }
    c
}

fn main() {
    for i in 1..=37 {
        println!("chowla({}) = {}", i, chowla(i));
    }

    let mut count = 1;
    let limit = 1e7 as usize;
    let mut power = 100;
    let c = sieve(limit);
    for i in (3..limit).step_by(2) {
        if !c[i] {
            count += 1;
        }
        if i == power - 1 {
            println!("Count of primes up to {} = {}", power, count);
            power *= 10;
        }
    }

    count = 0;
    let limit = 35000000;
    let mut k = 2;
    let mut kk = 3;
    loop {
        let p = k * kk;
        if p > limit {
            break;
        }
        if chowla(p) == p - 1 {
            println!("{} is a number that is perfect", p);
            count += 1;
        }
        k = kk + 1;
        kk += k;
    }
    println!("There are {} perfect numbers <= 35,000,000", count);
}
