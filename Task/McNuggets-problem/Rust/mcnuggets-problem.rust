fn main() {
    let test_cases = vec![
        [6, 9, 20],
        [12, 14, 17],
        [12, 13, 34],
        [5, 9, 21],
        [10, 18, 21],
        [71, 98, 99],
        [7_074_047, 8_214_596, 9_098_139],
        [582_795_988, 1_753_241_221, 6_814_151_015],
        [4, 30, 16],
        [12, 12, 13],
        [6, 15, 1],
    ];
    for case in &test_cases {
        print!("g({}, {}, {}) = ", case[0], case[1], case[2]);
        println!(
            "{}",
            match frobenius(case.to_vec()) {
                Ok(g) => format!("{}", g),
                Err(e) => e,
            }
        );
    }
}

fn frobenius(unsorted_a: Vec<i64>) -> Result<i64, String> {
    let mut a = unsorted_a;
    a.sort();
    assert!(a[0] >= 1);
    if gcd(gcd(a[0], a[1]), a[2]) > 1 {
        return Err("Undefined".to_string());
    }
    let d12 = gcd(a[0], a[1]);
    let d13 = gcd(a[0] / d12, a[2]);
    let d23 = gcd(a[1] / d12, a[2] / d13);
    let mut a_prime = vec![a[0] / d12 / d13, a[1] / d12 / d23, a[2] / d13 / d23];
    a_prime.sort();
    let rod = if a_prime[0] == 1 {
        -1
    } else {
        // Rødseth’s Algorithm
        let mut a1 = a_prime[0];
        let mut s0 = congruence(a_prime[1], a_prime[2], a_prime[0]);
        let mut s = vec![a1];
        let mut q: Vec<i64> = vec![];
        while s0 != 0 {
            s.push(s0);
            let s1 = if s0 == 1 { 0 } else { s0 - (a1 % s0) };
            let q1 = (a1 + s1) / s0;
            q.push(q1);
            a1 = s0;
            s0 = s1;
        }
        let mut p = vec![0, 1];
        let mut r = (s[1] * a_prime[1] - p[1] * a_prime[2]) / a_prime[0];
        let mut i = 1;
        while r > 0 {
            let p_next = q[i - 1] * p[i] - p[i - 1];
            p.push(p_next);
            r = (s[i + 1] * a_prime[1] - p_next * a_prime[2]) / a_prime[0];
            i += 1;
        }
        let v = i - 1;
        -a_prime[0] + a_prime[1] * (s[v] - 1) + a_prime[2] * (p[v + 1] - 1)
            - (a_prime[1] * s[v + 1]).min(a_prime[2] * p[v])
    };
    Ok(rod * d12 * d13 * d23 + a[0] * (d23 - 1) + a[1] * (d13 - 1) + a[2] * (d12 - 1))
}

fn gcd(a: i64, b: i64) -> i64 {
    if b == 0 {
        a
    } else {
        gcd(b, a % b)
    }
}

fn congruence(a: i64, c: i64, m: i64) -> i64 {
    // Solves ax ≡ c mod m
    let aa = a % m;
    let cc = (c + a * m) % m;
    if aa == 1 {
        cc
    } else {
        let y = congruence(m, -cc, aa);
        (m * y + cc) / aa
    }
}
