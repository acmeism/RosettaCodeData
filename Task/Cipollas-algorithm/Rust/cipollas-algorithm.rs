// [dependencies]
// rand = "0.8.0"

use rand::distributions::{Distribution, Uniform};
use rand::Rng;

// Use thread_rng for simplicity, could use a seeded generator if needed.
fn range_random(min: u64, max: u64) -> u64 {
    if min > max {
        // Handle invalid range, maybe panic or return min?
        // C++ std::uniform_int_distribution has undefined behavior if min > max.
        // Let's follow a safe approach.
        return min;
    }
    let mut rng = rand::thread_rng();
    // Use ..= to include max, matching C++ behavior.
    let range = Uniform::from(min..=max);
    range.sample(&mut rng)
}

// Return a * b mod modulus using u128 intermediate to prevent overflow.
fn multiply_modulus(a: u64, b: u64, modulus: u64) -> u64 {
    if modulus == 0 {
        panic!("Modulo cannot be zero");
    }
    // Cast to u128 for multiplication, then apply modulus
    ((a as u128 * b as u128) % (modulus as u128)) as u64
}

// Return base^power mod modulus (Modular Exponentiation)
fn power_modulus(mut base: u64, mut power: u64, modulus: u64) -> u64 {
    if modulus == 1 { return 0; } // Edge case: result is always 0 mod 1
    let mut result: u64 = 1;
    base %= modulus; // Reduce base initially

    while power > 0 {
        // If power is odd, multiply result with base
        if (power & 1) == 1 {
            result = multiply_modulus(result, base, modulus);
        }
        // Square the base and reduce modulo
        base = multiply_modulus(base, base, modulus);
        // Halve the power
        power >>= 1;
    }
    result
}

// Helper function for the 'is_prime' function (Miller-Rabin witness test)
fn is_witness(a: u64, n: u64) -> bool {
    if a == 0 { return false; } // 0 is not a useful witness
    let n_minus_1 = n - 1;
    // Find t, u such that n - 1 = 2^t * u where u is odd
    let mut t = 0;
    let mut u = n_minus_1;
    while (u & 1) == 0 {
        t += 1;
        u >>= 1;
    }

    // Calculate a^u mod n
    let mut xx = power_modulus(a, u, n);

    for _i in 0..t {
        let yy = multiply_modulus(xx, xx, n);
        // If yy == 1 and xx != 1 and xx != n-1, then n is composite
        if yy == 1 && xx != 1 && xx != n_minus_1 {
            return true; // a is a witness to n's compositeness
        }
        xx = yy;
    }

    // If xx != 1 after the loop, n might be prime (or a is not a witness)
    // If xx == 1, n might be prime.
    // Return true if a IS a witness (xx != 1), false otherwise.
    xx != 1
}


// Uses the Miller-Rabin primality test (deterministic version for u64)
// Based on known sufficient witness sets. For full 64-bit, more witnesses are needed.
// This uses the small set from the C++ code, which is NOT sufficient for all u64.
// For robustness, consider using a library like `primal` or expanding the witness set.
fn is_prime(n: u64) -> bool {
    if n <= 1 { return false; }
    if n <= 3 { return true; } // 2 and 3 are prime
    if n % 2 == 0 || n % 3 == 0 { return false; } // Handle divisors 2 and 3

    // Small primes often used as bases for Miller-Rabin.
    // WARNING: This set {2, 3, 5, 7, 11, 13, 17} is NOT sufficient for all u64 numbers.
    // It's good for numbers up to 3,317,044,064,679,887,385,961,981.
    // For arbitrary u64, a larger set like {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37}
    // or even more specific sets are needed. Let's stick to the C++ version's set.
    let primes: [u64; 7] = [2, 3, 5, 7, 11, 13, 17];

    // Check if n is one of these small primes directly (already handled by n <= 3 check mostly)
    if primes.contains(&n) { return true; }

    for &prime in &primes {
        // Important: The witness 'a' must be less than 'n'.
        // If n is one of the primes used for testing, skip or handle it.
        // This check is implicit because `is_witness` calls `power_modulus` which uses `% n`.
        // However, technically, Miller-Rabin requires 1 < a < n-1.
        // The bases chosen are small, so `prime < n` is usually true for large n.
        // If n itself is small and in `primes`, `contains` check handles it.
        if prime >= n { break; } // Optimization: no need to check bases >= n

        if is_witness(prime, n) {
            return false; // Found a witness, n is composite
        }
    }

    true // No witness found among the tested bases, likely prime
}

// Calculate the Legendre symbol (a/p)
fn legendre_symbol(a: u64, p: u64) -> i64 {
    if p < 3 || !is_prime(p) {
        // Legendre symbol is defined for odd primes p
        // Returning 0 or panicking might be options. C++ returned potentially incorrect value.
        // Let's return 0 for non-odd-primes, aligning with some conventions.
        // Or panic!("p must be an odd prime");
        eprintln!("Warning: legendre_symbol called with non-odd-prime p={}", p);
        return 0; // Or choose another indicator
    }

    let ls = power_modulus(a, (p - 1) / 2, p);

    if ls == p - 1 {
        -1 // Corresponds to quadratic non-residue
    } else if ls == 1 {
        1 // Corresponds to quadratic residue
    } else {
        // ls should be 0 if a % p == 0
        0 // Corresponds to a divisible by p
    }
}

// Represents an element in the field F(p^2), x + y*sqrt(w2)
// where w2 is a quadratic non-residue mod p.
#[derive(Debug, Copy, Clone, PartialEq, Eq)]
struct Fp2 {
    x: u64,
    y: u64,
}

// Multiply two elements in F(p^2)
// (a.x + a.y*sqrt(w2)) * (b.x + b.y*sqrt(w2))
// = (a.x*b.x + a.y*b.y*w2) + (a.x*b.y + a.y*b.x)*sqrt(w2)
fn multiply_fp2(a: Fp2, b: Fp2, prime: u64, w2: u64) -> Fp2 {
    let axbx = multiply_modulus(a.x, b.x, prime);
    let ayby = multiply_modulus(a.y, b.y, prime);
    let aybyw2 = multiply_modulus(ayby, w2, prime);

    // Calculate real part: (a.x*b.x + a.y*b.y*w2) % prime
    // Use u128 intermediate for addition to prevent overflow
    let real_part = ((axbx as u128 + aybyw2 as u128) % prime as u128) as u64;

    let axby = multiply_modulus(a.x, b.y, prime);
    let aybx = multiply_modulus(a.y, b.x, prime);

    // Calculate imaginary part: (a.x*b.y + a.y*b.x) % prime
    // Use u128 intermediate for addition
    let imag_part = ((axby as u128 + aybx as u128) % prime as u128) as u64;

    Fp2 {
        x: real_part,
        y: imag_part,
    }
}

// Calculate base^power in F(p^2) using exponentiation by squaring
fn power_fp2(mut base: Fp2, mut power: u64, prime: u64, w2: u64) -> Fp2 {
    // Identity element in F(p^2) is 1 + 0*sqrt(w2)
    let mut result = Fp2 { x: 1, y: 0 };
    if power == 0 { return result; }

    // Reduce base components modulo prime initially (though they likely are already)
    base.x %= prime;
    base.y %= prime;

    while power > 0 {
        if (power & 1) == 1 {
            result = multiply_fp2(result, base, prime, w2);
        }
        base = multiply_fp2(base, base, prime, w2);
        power >>= 1;
    }
    result
}

// Tonelli-Shanks algorithm to find modular square root x such that x^2 = n (mod p)
fn test(n_orig: u64, p: u64) {
    println!("Finding solutions for number = {} and prime = {}:", n_orig, p);

    // Ensure n is reduced modulo p for calculations
    let n = n_orig % p;

    if p == 2 {
        // Special case for p=2: sqrt(n) = n (mod 2)
        if n == 0 {
             println!("Square root of 0 mod 2 is 0");
        } else { // n == 1
             println!("Square root of 1 mod 2 is 1");
        }
        println!();
        return;
    }

    if !is_prime(p) {
        println!("No solutions, since p={} is not an odd prime.", p);
        println!();
        return;
    }

    // Handle n=0 separately
    if n == 0 {
        println!("Square root of 0 mod {} is 0", p);
        println!();
        return;
    }


    // Step 1: Check if n is a quadratic residue using Legendre symbol
    let leg_sym = legendre_symbol(n, p);
    if leg_sym != 1 {
        if leg_sym == -1 {
             println!("No solutions, since {} is not a quadratic residue mod {}", n_orig, p);
        } else { // leg_sym == 0 implies n is divisible by p
             println!("Square root of 0 mod {} is 0", p); // Should have been caught by n==0 check
        }
        println!();
        return;
    }

    // Step 2: Find a quadratic non-residue 'a' mod p
    // The loop finds 'a' such that w2 = a^2 - n is a non-residue.
    let mut a;
    let mut w2;
    loop {
        // Choose a random 'a' in [1, p-1]. C++ used [2, p].
        // Choosing from [1, p-1] or [0, p-1] is common.
        a = range_random(1, p - 1);
        let a_squared = multiply_modulus(a, a, p);
        // Calculate w2 = (a^2 - n) mod p = (a^2 + p - n) mod p
        w2 = (a_squared + p - n) % p;

        if legendre_symbol(w2, p) == -1 {
            // Found a suitable 'a', so w2 is a non-residue
            break;
        }
        // If legendre_symbol(w2, p) == 0, means a^2 = n (mod p), so 'a' is a root!
        // This is an optimization/early exit.
        if legendre_symbol(w2, p) == 0 {
             let x1 = a;
             let x2 = p - x1;
             println!("Square roots of {} are ( {} and {} ) mod {}", n_orig, x1, x2, p);
             println!();
             return;
        }
        // Otherwise, legendre_symbol(w2, p) == 1, try another 'a'.
    }

    // Step 3: Compute R = (a + sqrt(w2))^((p+1)/2) in F(p^2)
    // Note: sqrt(w2) is implicitly represented by the 'y' component (y=1).
    let initial_fp2 = Fp2 { x: a, y: 1 };
    let power = (p + 1) / 2;
    let result_fp2 = power_fp2(initial_fp2, power, p, w2);

    // The roots should be the 'x' component of the result.
    // Tonelli-Shanks guarantees result_fp2.y == 0 if everything worked.
    if result_fp2.y != 0 {
        // This shouldn't happen if n is a quadratic residue and p is prime.
        eprintln!("Error in Tonelli-Shanks: Imaginary part is non-zero.");
        println!("Algorithm failed for n={}, p={}", n_orig, p);
        println!();
        return;
    }

    let x1 = result_fp2.x;
    let x2 = p - x1; // The other root is p - x1

    // Verification (optional but good practice)
    if multiply_modulus(x1, x1, p) == n && multiply_modulus(x2, x2, p) == n {
         println!("Square roots of {} are ( {} and {} ) mod {}", n_orig, x1, x2, p);
    } else {
        eprintln!("Error: Verification failed. x1^2={}, x2^2={}, expected={}",
                  multiply_modulus(x1, x1, p), multiply_modulus(x2, x2, p), n);
        println!("Algorithm failed for n={}, p={}", n_orig, p);
    }
    println!();

}

fn main() {
    test(10, 13);
    test(56, 101);
    test(8_218, 10_007);
    test(8_219, 10_007); // Should have no solution
    test(331_575, 1_000_003);
    test(665_165_880, 1_000_000_007);
    test(881_398_088_036, 1_000_000_000_039);
    test(12_345_678_901_234_567, 1_000_000_000_000_000_031);
}
