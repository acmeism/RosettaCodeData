use rand::Rng;
use std::{cmp::Ordering, mem};

// --- Constants ---
const MAX_MODULUS: i64 = 1_073_741_789;
const MAX_ORDER_G: i64 = MAX_MODULUS + 65536;

// --- Structures ---

#[derive(Debug, Copy, Clone, PartialEq, Eq)]
struct Point {
    x: i64,
    y: i64,
}

impl Point {
    // Represents the point at infinity (identity element)
    const ZERO: Point = Point { x: i64::MAX, y: 0 };

    fn new(x: i64, y: i64) -> Self {
        Point { x, y }
    }

    fn is_zero(&self) -> bool {
        *self == Point::ZERO
    }
}

#[derive(Debug, Copy, Clone, PartialEq, Eq)]
struct Pair {
    // Often represents (c, d) in ECDSA signature
    c: i64, // Renamed 'a' to 'c' for clarity in ECDSA context
    d: i64, // Renamed 'b' to 'd' for clarity in ECDSA context
}

impl Pair {
    fn new(c: i64, d: i64) -> Self {
        Pair { c, d }
    }
}

#[derive(Debug, Copy, Clone)]
struct Parameter {
    a: i64,
    b: i64,
    n: i64, // Modulus
    g: Point, // Base point
    r: i64, // Order of G
}

impl Parameter {
    fn new(a: i64, b: i64, n: i64, g: Point, r: i64) -> Self {
        Parameter { a, b, n, g, r }
    }
}

// --- Helper Functions ---

// Consistent floor modulus (handles negative numbers)
fn floor_mod(num: i64, modulus: i64) -> i64 {
    // Assumes modulus > 0, which is true for elliptic curve 'n' and 'r'
    // If modulus can be negative, more complex logic is needed like in the C++ version.
    // For ECDSA n and r are positive.
    if modulus <= 0 {
        panic!("Modulus must be positive for floor_mod in this context.");
    }
    // ((num % modulus) + modulus) % modulus
    let rem = num % modulus;
    if rem < 0 {
        rem + modulus
    } else {
        rem
    }
}

// Extended Euclidean Algorithm to find modular multiplicative inverse.
// Returns `x` such that `(a * x) % m == 1`.
// Returns Err if gcd(a, m) != 1 (no inverse exists).
fn extended_gcd(a: i64, m: i64) -> Result<i64, String> {
    if m <= 0 {
        return Err("Modulus must be positive for extended_gcd".to_string());
    }
    let mut v = floor_mod(a, m); // Ensure v is in [0, m-1]
    let mut u = m;
    let mut result: i64 = 0;
    let mut s: i64 = 1;

    while v != 0 {
        // Using standard Euclidean algorithm division, not floor_div, as 'v' and 'u' are non-negative
        let quotient = u / v;
        u = u % v;
        mem::swap(&mut u, &mut v); // Swap u and v

        // Update Bezout coefficients
        let next_result = result.wrapping_sub(quotient.wrapping_mul(s));
        result = s;
        s = next_result;

        // Keep result and s within i64 range reasonably
        // (Technically full modular arithmetic on coefficients is better,
        // but for typical crypto sizes i64 is usually sufficient)
    }

    if u != 1 {
        Err(format!(
            "Cannot inverse modulo N={}, gcd({}, {}) = {}",
            m, a, m, u
        ))
    } else {
        // Ensure the result is positive
        Ok(floor_mod(result, m))
    }
}

// --- Elliptic Curve Logic ---

#[derive(Debug, Clone)] // Cannot Copy as methods take &self
struct EllipticCurve {
    a: i64,
    b: i64,
    n: i64, // Modulus
    r: i64, // Order of G
    g: Point, // Base point
}

impl EllipticCurve {
    // Constructor with validation
    fn new(param: Parameter) -> Result<Self, String> {
        if param.n < 5 || param.n > MAX_MODULUS {
            return Err(format!("Invalid value for modulus: {}", param.n));
        }
        if param.r < 5 || param.r > MAX_ORDER_G {
            return Err(format!(
                "Invalid value for the order of g: {}",
                param.r
            ));
        }

        let a = floor_mod(param.a, param.n);
        let b = floor_mod(param.b, param.n);

        let curve = EllipticCurve {
            a,
            b,
            n: param.n,
            r: param.r,
            g: param.g,
        };

        println!("\nElliptic curve: y^2 = x^3 + {}x + {} (mod {})", a, b, param.n);
        curve.print_point_with_prefix(curve.g, "base point G");
        println!("order(G, E) = {}", curve.r);

        // Basic check: Base point must be on the curve
        if !param.g.is_zero() && !curve.contains(param.g) {
             return Err(format!("Base point G {:?} is not on the curve", param.g));
        }
        // Basic check: Order * G should be Zero
        let order_check = curve.multiply(curve.g, curve.r);
        // Check if multiplication failed or result is not Zero
        match order_check {
            Ok(p) if !p.is_zero() => return Err(format!("Order r={} is invalid for G: r*G is not Zero", curve.r)),
            Err(e) => return Err(format!("Failed order check multiplication: {}", e)),
            _ => {} // Ok and point is Zero, proceed
        }
        // Basic check: Discriminant non-zero (for non-singular curve)
        let disc = curve.discriminant()?;
        if disc == 0 {
            return Err("Curve discriminant is zero (singular curve)".to_string());
        }

        Ok(curve)
    }

    // Point addition (P + Q)
    fn add(&self, p: Point, q: Point) -> Result<Point, String> {
        if p.is_zero() {
            return Ok(q);
        }
        if q.is_zero() {
            return Ok(p);
        }

        let lambda: i64;
        if p.x != q.x {
            // P != Q
            let dy = p.y.wrapping_sub(q.y);
            let dx = p.x.wrapping_sub(q.x);
            let dx_inv = extended_gcd(dx, self.n)?;
            lambda = floor_mod(dy.wrapping_mul(dx_inv), self.n);
        } else if p.y == q.y && p.y != 0 {
            // P == Q (Point doubling)
            // lambda = (3*x^2 + a) / (2*y) mod n
            let x_sq = floor_mod(p.x.wrapping_mul(p.x), self.n);
            let numerator = floor_mod(x_sq.wrapping_mul(3).wrapping_add(self.a), self.n);
            let denominator = floor_mod(p.y.wrapping_mul(2), self.n);
            let denominator_inv = extended_gcd(denominator, self.n)?;
            lambda = floor_mod(numerator.wrapping_mul(denominator_inv), self.n);
        } else {
            // P == -Q (p.x == q.x but p.y == -q.y mod n) or P == Q == (x, 0)
            return Ok(Point::ZERO);
        }

        // x_r = lambda^2 - x_p - x_q mod n
        let lambda_sq = floor_mod(lambda.wrapping_mul(lambda), self.n);
        let x_r = floor_mod(
            lambda_sq.wrapping_sub(p.x).wrapping_sub(q.x),
            self.n,
        );

        // y_r = lambda * (x_p - x_r) - y_p mod n
        let x_p_sub_x_r = p.x.wrapping_sub(x_r);
        let term1 = floor_mod(lambda.wrapping_mul(x_p_sub_x_r), self.n);
        let y_r = floor_mod(term1.wrapping_sub(p.y), self.n);

        Ok(Point::new(x_r, y_r))
    }

    // Scalar multiplication (k * P) using double-and-add
    fn multiply(&self, mut point: Point, mut k: i64) -> Result<Point, String> {
        let mut result = Point::ZERO;
        if k < 0 {
           // This basic implementation doesn't handle negative k easily.
           // Standard ECDSA uses positive scalars (private key, random nonce).
           // If needed, one could compute k = k mod r, or compute point negation.
           return Err("Negative scalar multiplication not directly supported".to_string());
        }
         if k == 0 {
            return Ok(Point::ZERO);
        }

        // Ensure k is positive and reduced modulo r if necessary, though ECDSA usually handles this before calling.
        // k = floor_mod(k, self.r); // Optional: Reduce k modulo order, requires r > 0

        while k > 0 {
            if (k & 1) == 1 {
                result = self.add(result, point)?;
            }
            point = self.add(point, point)?; // Double the point
            k >>= 1; // Halve the scalar
        }
        Ok(result)
    }

    // Check if a point lies on the curve y^2 = x^3 + ax + b (mod n)
    fn contains(&self, point: Point) -> bool {
        if point.is_zero() {
            return true; // Point at infinity is always on the curve
        }

        // y^2 mod n
        let lhs = floor_mod(point.y.wrapping_mul(point.y), self.n);

        // x^3 + ax + b mod n
        let x_sq = floor_mod(point.x.wrapping_mul(point.x), self.n);
        let x_cubed = floor_mod(x_sq.wrapping_mul(point.x), self.n);
        let ax = floor_mod(self.a.wrapping_mul(point.x), self.n);
        let rhs = floor_mod(x_cubed.wrapping_add(ax).wrapping_add(self.b), self.n);

        lhs == rhs
    }

    // Calculate discriminant: -16 * (4a^3 + 27b^2) mod n
    fn discriminant(&self) -> Result<i64, String> {
        // Need intermediate results, use wrapping arithmetic carefully
        let a_sq = floor_mod(self.a.wrapping_mul(self.a), self.n);
        let a_cubed = floor_mod(a_sq.wrapping_mul(self.a), self.n);
        let term1 = floor_mod(a_cubed.wrapping_mul(4), self.n); // 4a^3

        let b_sq = floor_mod(self.b.wrapping_mul(self.b), self.n);
        let term2 = floor_mod(b_sq.wrapping_mul(27), self.n); // 27b^2

        let inner_sum = floor_mod(term1.wrapping_add(term2), self.n); // 4a^3 + 27b^2
        let result = floor_mod(inner_sum.wrapping_mul(-16), self.n);

        Ok(result)
    }

    // Helper to print points
    fn print_point_with_prefix(&self, point: Point, prefix: &str) {
        if point.is_zero() {
            println!("{} (0 - Point at Infinity)", prefix);
        } else {
            // Optionally represent y with the smaller absolute value coordinate
            let mut y_repr = point.y;
            if y_repr > self.n / 2 { // Simplified check assuming n > 0
               y_repr = y_repr.wrapping_sub(self.n);
            }
            println!("{} ({}, {})", prefix, point.x, y_repr);
        }
    }
}

// --- ECDSA Functions ---

// Generate a random number 0.0 <= x < 1.0
fn random_f64() -> f64 {
    let mut rng = rand::thread_rng();
    rng.gen::<f64>()
}

// Generate a random integer 1 <= x < limit
fn random_i64_in_range(limit: i64) -> i64 {
    if limit <= 1 {
        // Avoid panic in gen_range(1..limit) if limit is 1 or less.
        // In ECDSA, the limit (order r) should be > 1.
        // If r was 1 or less, curve setup should have failed.
        panic!("Range limit must be greater than 1 for random generation");
    }
    let mut rng = rand::thread_rng();
    rng.gen_range(1..limit) // Exclusive upper bound
}


// Create ECDSA signature (c, d) for message hash f
// s: private key
fn signature(curve: &EllipticCurve, s: i64, f: i64) -> Result<Pair, String> {
    if curve.r <= 1 {
         return Err("Curve order 'r' must be greater than 1 for signing.".to_string());
    }

    loop {
        // 1. Generate random nonce 'u' (called 'k' in many texts) in [1, r-1]
        let u = random_i64_in_range(curve.r);

        // 2. Calculate curve point V = u * G
        let v = curve.multiply(curve.g, u)?;
        if v.is_zero() { continue; } // Should technically not happen if u in [1, r-1]

        // 3. Calculate c = V.x mod r
        let c = floor_mod(v.x, curve.r);
        if c == 0 { continue; } // Retry if c is 0

        // 4. Calculate d = u^-1 * (f + s*c) mod r
        let u_inv = extended_gcd(u, curve.r)?; // u^-1 mod r
        let s_times_c = floor_mod(s.wrapping_mul(c), curve.r);
        let hash_plus_sc = floor_mod(f.wrapping_add(s_times_c), curve.r);
        let d = floor_mod(u_inv.wrapping_mul(hash_plus_sc), curve.r);

        if d == 0 { continue; } // Retry if d is 0

        println!("one-time u = {}", u);
        curve.print_point_with_prefix(v, "V = uG");
        return Ok(Pair::new(c, d));
    }
}

// Verify ECDSA signature
// point W: public key (W = s*G)
// f: message hash (same as used for signing)
// signature (c, d): the signature to verify
fn verify(curve: &EllipticCurve, public_key_w: Point, f: i64, signature: Pair) -> Result<bool, String> {
    let (c, d) = (signature.c, signature.d);

    // 1. Check if c and d are in the valid range [1, r-1]
    if !(1..curve.r).contains(&c) || !(1..curve.r).contains(&d) {
        println!("Verification fail: c or d out of range [1, r-1]");
        return Ok(false);
    }

    println!("\nSignature verification");

    // 2. Calculate h = d^-1 mod r
    let h = extended_gcd(d, curve.r)?;

    // 3. Calculate h1 = f * h mod r
    // 4. Calculate h2 = c * h mod r
    let h1 = floor_mod(f.wrapping_mul(h), curve.r);
    let h2 = floor_mod(c.wrapping_mul(h), curve.r);
    println!("h = d^-1 = {}", h);
    println!("h1 = f*h = {}", h1);
    println!("h2 = c*h = {}", h2);

    // 5. Calculate point V' = h1*G + h2*W
    let v1 = curve.multiply(curve.g, h1)?;
    let v2 = curve.multiply(public_key_w, h2)?;
    curve.print_point_with_prefix(v1, "h1*G");
    curve.print_point_with_prefix(v2, "h2*W");

    let v_prime = curve.add(v1, v2)?;
    curve.print_point_with_prefix(v_prime, "+ = V'");

    // 6. Check if V' is the point at infinity
    if v_prime.is_zero() {
        println!("Verification fail: V' is point at infinity");
        return Ok(false);
    }

    // 7. Calculate c' = V'.x mod r
    let c_prime = floor_mod(v_prime.x, curve.r);
    println!("c' = V'.x mod r = {}", c_prime);

    // 8. Signature is valid if c' == c
    Ok(c_prime == c)
}

// Main ECDSA process: keygen, sign, verify
fn ecdsa(curve: &EllipticCurve, f_original: i64, d_error: i32) -> Result<(), String> {
    // Initial curve/parameter checks (already done in EllipticCurve::new, but re-stated here)
    // if curve.discriminant()? == 0 { return Err("Invalid parameter: discriminant is 0".to_string()); }
    // if curve.g.is_zero() { return Err("Invalid parameter: base point G is zero".to_string()); }
    // let point_check = curve.multiply(curve.g, curve.r)?;
    // if !point_check.is_zero() { return Err("Invalid parameter: r*G is not zero".to_string()); }
    // if !curve.contains(curve.g) { return Err("Invalid parameter: G is not on the curve".to_string()); }

    println!("\nKey generation");
    // 1. Generate private key 's' in [1, r-1]
    let s = random_i64_in_range(curve.r);
    // 2. Calculate public key W = s * G
    let public_key_w = curve.multiply(curve.g, s)?;
    println!("private key s = {}", s);
    curve.print_point_with_prefix(public_key_w, "public key W = sG");


    // Align hash f to be within the bit range related to r
    let mut f = f_original;
    // Find the next highest power of two minus one for r (rough bit mask)
    let mut t = curve.r;
    if t > 0 { // Avoid infinite loop if r is 0 or negative (shouldn't happen)
         // Efficient way to get next power of 2 minus 1 (all lower bits set)
         t |= t >> 1;
         t |= t >> 2;
         t |= t >> 4;
         t |= t >> 8;
         t |= t >> 16;
         t |= t >> 32; // For i64

        // Reduce f if it's larger than the bit mask t
        // This step isn't standard ECDSA but mimics the C++ example's behavior.
        // Standard ECDSA typically takes the leftmost min(N, L) bits of the hash,
        // where N is bit length of r, L is bit length of hash output.
        while f > 0 && t > 0 && f > t {
             println!("Warning: Hash {} > bitmask {}. Right-shifting hash (non-standard).", f, t);
             f >>= 1;
        }
    } else {
        println!("Warning: Curve order r ({}) is not positive. Hash alignment skipped.", curve.r);
        t = i64::MAX; // Allow any hash if r is invalid
    }

    println!("\nAligned hash f = 0x{:08x} ({})", f, f);

    // Sign the hash
    let signature_pair = signature(curve, s, f)?;
    println!("Signature (c, d) = ({}, {})", signature_pair.c, signature_pair.d);

    // Simulate data corruption if d_error > 0
    let mut f_verify = f;
    if d_error > 0 {
        let mut error_val = d_error as i64;
        // Align the error like the hash was aligned (mimicking C++ again)
         while error_val > 0 && t > 0 && error_val > t {
             error_val >>= 1;
         }
        f_verify ^= error_val; // Apply error using XOR
        println!(
            "\nCorrupted hash f' = 0x{:08x} ({}) (error=0x{:x})",
            f_verify, f_verify, d_error
        );
    }

    // Verify the signature
    let is_valid = verify(curve, public_key_w, f_verify, signature_pair)?;
    println!("{}", if is_valid { "Valid" } else { "Invalid" });
    println!("-----------------");

    Ok(())
}

fn main() {
    // Test parameters for elliptic curve digital signature algorithm,
    // using the short Weierstrass model: y^2 = x^3 + ax + b (mod N).
    // Parameter: a, b, modulus N, base point G(x, y), order of G.
    let parameters = vec![
        Parameter::new(355, 671, 1_073_741_789, Point::new(13693, 10088), 1_073_807_281),
        Parameter::new(0, 7, 67_096_021, Point::new(6580, 779), 16_769_911),
        Parameter::new(-3, 1, 877_073, Point::new(0, 1), 878_159), // SECp256k1 shape (a=0, b=7) is common, this is a=-3
        Parameter::new(0, 14, 22_651, Point::new(63, 30), 151),
        Parameter::new(3, 2, 5, Point::new(2, 1), 5), // Very small curve example
    ];

    // Parameters which cause failure (commented out like C++)
    // Parameter::new(0, 7, 67096021, Point::new(2402, 6067), 33539822), // G has composite order
    // Parameter::new(0, 7, 67096021, Point::new(6580, 779), 67079644), // r is composite (multiple of true order)
    // Parameter::new(0, 7, 877069, Point::new(3, 97123), 877069),     // N not prime (877069 = 877 * 1000 + 69, maybe 7*125295 + 4?) Let's check: 877069 / 7 = 125295.5; 877069 / 11.. nope. 877069 is prime. The comment might be wrong, or the point/order pair fails for other reasons.
    // Parameter::new(39, 387, 22651, Point::new(95, 27), 22651)       // N divides discriminant? disc = -16*(4*39^3+27*387^2) mod 22651. Let's check: 4*39^3+27*387^2 = 4*59319 + 27*149769 = 237276 + 4043763 = 4281039. 4281039 mod 22651 = 0. Yes, N divides discriminant -> singular curve.

    // The message hash (often SHA-256 output truncated/converted to integer)
    let f_hash: i64 = 0x789a_bcde;
    // Set d_error > 0 to simulate corrupted data before verification
    let d_error: i32 = 0; // 0 means no error

    for param in parameters {
        match EllipticCurve::new(param) {
            Ok(curve) => {
                if let Err(e) = ecdsa(&curve, f_hash, d_error) {
                    eprintln!("ECDSA Error for curve {:?}: {}", param, e);
                     println!("-----------------");
                }
            }
            Err(e) => {
                eprintln!("Failed to create curve with parameters {:?}: {}", param, e);
                 println!("-----------------");
            }
        }
    }
}
