fn is_prime(n: i64) -> bool {
    if n > 1 {
        (2..((n / 2) + 1)).all(|x| n % x != 0)
    } else {
        false
    }
}

// The modulo operator actually calculates the remainder.
fn modulo(n: i64, m: i64) -> i64 {
    ((n % m) + m) % m
}

fn carmichael(p1: i64) -> Vec<(i64, i64, i64)> {
    let mut results = Vec::new();
    if !is_prime(p1) {
        return results;
    }

    for h3 in 2..p1 {
        for d in 1..(h3 + p1) {
            if (h3 + p1) * (p1 - 1) % d != 0 || modulo(-p1 * p1, h3) != d % h3 {
                continue;
            }

            let p2 = 1 + ((p1 - 1) * (h3 + p1) / d);
            if !is_prime(p2) {
                continue;
            }

            let p3 = 1 + (p1 * p2 / h3);
            if !is_prime(p3) || ((p2 * p3) % (p1 - 1) != 1) {
                continue;
            }

            results.push((p1, p2, p3));
        }
    }

    results
}

fn main() {
    (1..62)
        .filter(|&x| is_prime(x))
        .map(carmichael)
        .filter(|x| !x.is_empty())
        .flat_map(|x| x)
        .inspect(|x| println!("{:?}", x))
        .count(); // Evaluate entire iterator
}
