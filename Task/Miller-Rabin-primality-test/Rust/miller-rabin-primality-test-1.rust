/* Add these lines to the [dependencies] section of your Cargo.toml file:
num = "0.2.0"
rand = "0.6.5"
*/

use num::bigint::BigInt;
use num::bigint::ToBigInt;


// The modular_exponentiation() function takes three identical types
// (which get cast to BigInt), and returns a BigInt:
fn modular_exponentiation<T: ToBigInt>(n: &T, e: &T, m: &T) -> BigInt {
    // Convert n, e, and m to BigInt:
    let n = n.to_bigint().unwrap();
    let e = e.to_bigint().unwrap();
    let m = m.to_bigint().unwrap();

    // Sanity check:  Verify that the exponent is not negative:
    assert!(e >= Zero::zero());

    use num::traits::{Zero, One};

    // As most modular exponentiations do, return 1 if the exponent is 0:
    if e == Zero::zero() {
        return One::one()
    }

    // Now do the modular exponentiation algorithm:
    let mut result: BigInt = One::one();
    let mut base = n % &m;
    let mut exp = e;

    loop {  // Loop until we can return our result.
        if &exp % 2 == One::one() {
            result *= &base;
            result %= &m;
        }

        if exp == One::one() {
            return result
        }

        exp /= 2;
        base *= base.clone();
        base %= &m;
    }
}


// is_prime() checks the passed-in number against many known small primes.
// If that doesn't determine if the number is prime or not, then the number
// will be passed to the is_rabin_miller_prime() function:
fn is_prime<T: ToBigInt>(n: &T) -> bool {
    let n = n.to_bigint().unwrap();
    if n.clone() < 2.to_bigint().unwrap() {
        return false
    }

    let small_primes = vec![2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43,
                            47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101,
                            103, 107, 109, 113, 127, 131, 137, 139, 149, 151,
                            157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
                            211, 223, 227, 229, 233, 239, 241, 251, 257, 263,
                            269, 271, 277, 281, 283, 293, 307, 311, 313, 317,
                            331, 337, 347, 349, 353, 359, 367, 373, 379, 383,
                            389, 397, 401, 409, 419, 421, 431, 433, 439, 443,
                            449, 457, 461, 463, 467, 479, 487, 491, 499, 503,
                            509, 521, 523, 541, 547, 557, 563, 569, 571, 577,
                            587, 593, 599, 601, 607, 613, 617, 619, 631, 641,
                            643, 647, 653, 659, 661, 673, 677, 683, 691, 701,
                            709, 719, 727, 733, 739, 743, 751, 757, 761, 769,
                            773, 787, 797, 809, 811, 821, 823, 827, 829, 839,
                            853, 857, 859, 863, 877, 881, 883, 887, 907, 911,
                            919, 929, 937, 941, 947, 953, 967, 971, 977, 983,
                            991, 997, 1009, 1013];

    use num::traits::Zero;  // for Zero::zero()

    // Check to see if our number is a small prime (which means it's prime),
    // or a multiple of a small prime (which means it's not prime):
    for sp in small_primes {
        let sp = sp.to_bigint().unwrap();

        if n.clone() == sp {
            return true
        } else if n.clone() % sp == Zero::zero() {
            return false
        }
    }

    is_rabin_miller_prime(&n, None)
}


// Note:  "use bigint::RandBigInt;"  (which is needed for gen_bigint_range())
//        fails to work in the Rust playground ( https://play.rust-lang.org ).
//        Therefore, I'll create my own here:
fn get_random_bigint(low: &BigInt, high: &BigInt) -> BigInt {
    if low == high {  // base case
        return low.clone()
    }

    let middle = (low.clone() + high) / 2.to_bigint().unwrap();

    let go_low: bool = rand::random();

    if go_low {
        return get_random_bigint(low, &middle)
    } else {
        return get_random_bigint(&middle, high)
    }
}


// k is the number of times for testing (pass in None to use 5 (the default)).
fn is_rabin_miller_prime<T: ToBigInt>(n: &T, k: Option<usize>) -> bool {
    let n = n.to_bigint().unwrap();
    let k = k.unwrap_or(10);  // number of times for testing (defaults to 10)

    use num::traits::{Zero, One};  // for Zero::zero() and One::one()
    let zero: BigInt = Zero::zero();
    let one: BigInt = One::one();
    let two: BigInt = 2.to_bigint().unwrap();

    // The call to is_prime() should have already checked this,
    // but check for two, less than two, and multiples of two:
    if n <= one {
        return false
    } else if n == two {
        return true  // 2 is prime
    } else if n.clone() % &two == Zero::zero() {
        return false  // even number (that's not 2) is not prime
    }

    let mut t: BigInt = zero.clone();
    let n_minus_one: BigInt = n.clone() - &one;
    let mut s = n_minus_one.clone();
    while &s % &two == one {
        s /= &two;
        t += &one;
    }

    // Try k times to test if our number is non-prime:
    'outer: for _ in 0..k {
        let a = get_random_bigint(&two, &n_minus_one);
        let mut v = modular_exponentiation(&a, &s, &n);
        if v == one {
            continue 'outer;
        }
        let mut i: BigInt = zero.clone();
        'inner: while &i < &t {
            v = (v.clone() * &v) % &n;
            if &v == &n_minus_one {
                continue 'outer;
            }
            i += &one;
        }
        return false;
    }
    // If we get here, then we have a degree of certainty
    // that n really is a prime number, so return true:
    true
}
