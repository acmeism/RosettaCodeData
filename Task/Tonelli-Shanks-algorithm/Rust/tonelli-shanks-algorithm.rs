struct Pair {
    n: u64,
    p: u64,
}

struct Solution {
    root1: u64,
    root2: u64,
    is_square: bool,
}

fn multiply_modulus(a: u64, b: u64, modulus: u64) -> u64 {
    let mut a = a % modulus;
    let mut b = b % modulus;

    if b < a {
        std::mem::swap(&mut a, &mut b);
    }

    let mut result = 0;
    while a > 0 {
        if a % 2 == 1 {
            result = (result + b) % modulus;
        }
        b = (b << 1) % modulus;
        a >>= 1;
    }
    result
}

fn power_modulus(base: u64, exponent: u64, modulus: u64) -> u64 {
    if modulus == 1 {
        return 0;
    }

    let mut base = base % modulus;
    let mut result = 1;
    let mut exponent = exponent;

    while exponent > 0 {
        if (exponent & 1) == 1 {
            result = multiply_modulus(result, base, modulus);
        }
        base = multiply_modulus(base, base, modulus);
        exponent >>= 1;
    }
    result
}

fn legendre(a: u64, p: u64) -> u64 {
    power_modulus(a, (p - 1) / 2, p)
}

fn tonelli_shanks(n: u64, p: u64) -> Solution {
    if legendre(n, p) != 1 {
        return Solution { root1: 0, root2: 0, is_square: false };
    }

    // Factor out powers of 2 from p - 1
    let mut q = p - 1;
    let mut s = 0;
    while q % 2 == 0 {
        q /= 2;
        s += 1;
    }

    if s == 1 {
        let result = power_modulus(n, (p + 1) / 4, p);
        return Solution { root1: result, root2: p - result, is_square: true };
    }

    // Find a non-square z such as ( z | p ) = -1
    let mut z = 2;
    while legendre(z, p) != p - 1 {
        z += 1;
    }

    let mut c = power_modulus(z, q, p);
    let mut t = power_modulus(n, q, p);
    let mut m = s;
    let mut result = power_modulus(n, (q + 1) >> 1, p);

    while t != 1 {
        let mut i = 1;
        let mut z = multiply_modulus(t, t, p);
        while z != 1 && i < m - 1 {
            i += 1;
            z = multiply_modulus(z, z, p);
        }
        let b = power_modulus(c, 1 << (m - i - 1), p);
        c = multiply_modulus(b, b, p);
        t = multiply_modulus(t, c, p);
        m = i;
        result = multiply_modulus(result, b, p);
    }

    Solution { root1: result, root2: p - result, is_square: true }
}

fn main() {
    let tests = vec![
        Pair { n: 10, p: 13 },
        Pair { n: 56, p: 101 },
        Pair { n: 1030, p: 1009 },
        Pair { n: 1032, p: 1009 },
        Pair { n: 44402, p: 100049 },
        Pair { n: 665820697, p: 1000000009 },
        Pair { n: 881398088036, p: 1000000000039 },
    ];

    for test in tests {
        let solution = tonelli_shanks(test.n, test.p);
        print!("n = {}, p = {}", test.n, test.p);
        if solution.is_square {
            println!(" has solutions: {} and {}\n", solution.root1, solution.root2);
        } else {
            println!(" has no solutions because n is not a square modulo p\n");
        }
    }
}
