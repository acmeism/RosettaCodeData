/// Uses a queue to calculate and store the next integer sequences to generate.
///
/// The next sequence has the next power of 10 generated in lock-step from the front value
///
/// Ex: `[1, 2, 3, 4, 5, 6, 7, 8, 9]`
///
/// The front value `1` produces the next sequence
///
/// `[12, 13, 14, 15, 16, 17, 18, 19]`
///
/// Which is then appended to the back of the queue
///
/// Due to the nature of this algorithm, no sorting is required but iteration is implemented in a
/// more procedural style
fn powerset_from_queue() -> Vec<u32> {
    let mut dq = std::collections::VecDeque::from_iter(1..=9);
    let mut primes = Vec::new();

    while let Some(n) = dq.pop_front() {
        if is_prime_v(n) {
            primes.push(n);
        }

        for rem in (n % 10 + 1)..=9 {
            dq.push_back(n * 10 + rem);
        }
    }

    primes
}
