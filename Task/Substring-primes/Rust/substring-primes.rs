use primes::is_prime;

fn counted_prime_test() {
    let mut number_of_prime_tests = 0;
    let mut non_primes = vec![0; 0];
    // start with 1 digit primes
    let mut results: Vec<i32> = [2, 3, 5, 7].to_vec();
    // check 2 digit candidates
    for n in results.clone() {
        for i in [3, 7].to_vec() {
            if n != i {
                let candidate = n * 10 + i;
                if candidate < 100 {
                    number_of_prime_tests += 1;
                    if is_prime(candidate as u64) {
                        results.push(candidate);
                    } else {
                        non_primes.push(candidate);
                    }
                }
            }
        }
    }
    // check 3 digit candidates
    for n in results.clone() {
        for i in [3, 7].to_vec() {
            if 10 < n && n < 100 && n % 10 != i {
                let candidate = n * 10 + i;
                number_of_prime_tests += 1;
                if is_prime(candidate as u64) {
                    results.push(candidate);
                } else {
                    non_primes.push(candidate);
                }
            }
        }
    }
    println!("Results: {results:?}.\nThe function isprime() was called {number_of_prime_tests} times.");
    println!("Discarded nonprime candidates: {non_primes:?}");
    println!("Because 237, 537, and 737 are excluded, we cannot generate any larger candidates from 373.");
}

fn main() {
    counted_prime_test();
}
