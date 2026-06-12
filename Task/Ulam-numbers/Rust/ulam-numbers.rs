fn ulam(n: usize) -> usize {
    let mut ulams = vec![1, 2];
    let mut sieve = vec![1, 1];
    let mut u = 2;
    while ulams.len() < n {
        sieve.resize(u + ulams[ulams.len() - 2], 0);
        for i in 0..ulams.len() - 1 {
            sieve[u + ulams[i] - 1] += 1;
        }
        for i in u..sieve.len() {
            if sieve[i] == 1 {
                u = i + 1;
                ulams.push(u);
                break;
            }
        }
    }
    ulams[n - 1]
}

fn main() {
    use std::time::Instant;
    let start = Instant::now();
    let mut n = 1;
    while n <= 100000 {
        println!("Ulam({}) = {}", n, ulam(n));
        n *= 10;
    }
    println!("Elapsed time: {:.2?}", start.elapsed());
}
