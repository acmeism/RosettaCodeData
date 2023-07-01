// [dependencies]
// rug = "1.9"

use rug::Integer;

fn fermat(n: u32) -> Integer {
    Integer::from(Integer::u_pow_u(2, 2u32.pow(n))) + 1
}

fn g(x: Integer, n: &Integer) -> Integer {
    (Integer::from(&x * &x) + 1) % n
}

fn pollard_rho(n: &Integer) -> Integer {
    use rug::Assign;

    let mut x = Integer::from(2);
    let mut y = Integer::from(2);
    let mut d = Integer::from(1);
    let mut z = Integer::from(1);
    let mut count = 0;
    loop {
        x = g(x, n);
        y = g(g(y, n), n);
        d.assign(&x - &y);
        d = d.abs();
        z *= &d;
        z %= n;
        count += 1;
        if count == 100 {
            d.assign(z.gcd_ref(n));
            if d != 1 {
                break;
            }
            z.assign(1);
            count = 0;
        }
    }
    if d == *n {
        return Integer::from(0);
    }
    d
}

fn get_prime_factors(n: &Integer) -> Vec<Integer> {
    use rug::integer::IsPrime;
    let mut factors = Vec::new();
    let mut m = Integer::from(n);
    loop {
        if m.is_probably_prime(25) != IsPrime::No {
            factors.push(m);
            break;
        }
        let f = pollard_rho(&m);
        if f == 0 {
            factors.push(m);
            break;
        }
        factors.push(Integer::from(&f));
        m = m / f;
    }
    factors
}

fn main() {
    for i in 0..10 {
        println!("F({}) = {}", i, fermat(i));
    }
    println!("\nPrime factors:");
    for i in 0..9 {
        let f = get_prime_factors(&fermat(i));
        print!("F({}): {}", i, f[0]);
        for j in 1..f.len() {
            print!(", {}", f[j]);
        }
        println!();
    }
}
