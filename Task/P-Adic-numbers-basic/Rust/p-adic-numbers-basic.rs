use std::cmp;
use std::sync::atomic::{AtomicI32, Ordering};
use std::cell::UnsafeCell;

// constants
const EMX: i32 = 64;      // exponent maximum (if indexing starts at -EMX)
const DMX: i32 = 100000;  // approximation loop maximum
const AMX: i32 = 1048576; // argument maximum
const PMAX: i32 = 32749;  // prime maximum

// Using atomics for the global variables
static P1: AtomicI32 = AtomicI32::new(0);
static P: AtomicI32 = AtomicI32::new(7);  // default prime
static K: AtomicI32 = AtomicI32::new(11); // precision

fn abs(a: i32) -> i32 {
    if a >= 0 {
        a
    } else {
        -a
    }
}

fn min(a: i32, b: i32) -> i32 {
    if a < b {
        a
    } else {
        b
    }
}

struct Ratio {
    a: i32,
    b: i32,
}

struct Padic {
    v: i32,
    d: [i32; 2 * EMX as usize], // add EMX to index to be consistent with FB
}

impl Padic {
    // Create a new Padic with default values
    fn new() -> Self {
        Padic {
            v: 0,
            d: [0; 2 * EMX as usize],
        }
    }

    // (re)initialize receiver from Ratio, set 'sw' to print
    fn r2pa(&mut self, q: Ratio, sw: i32) -> i32 {
        let mut a = q.a;
        let mut b = q.b;
        if b == 0 {
            return 1;
        }
        if b < 0 {
            b = -b;
            a = -a;
        }
        if abs(a) > AMX || b > AMX {
            return -1;
        }

        let p_val = P.load(Ordering::Relaxed);
        if p_val < 2 || K.load(Ordering::Relaxed) < 1 {
            return 1;
        }

        // Set P to minimum of P and PMAX
        let p_val = cmp::min(p_val, PMAX);
        P.store(p_val, Ordering::Relaxed);

        // Set K to minimum of K and EMX-1
        let k_val = cmp::min(K.load(Ordering::Relaxed), EMX - 1);
        K.store(k_val, Ordering::Relaxed);

        if sw != 0 {
            println!("{}/{} + ", a, b);   // numerator, denominator
            println!("0({}^{})", p_val, k_val); // prime, precision
        }

        // (re)initialize
        self.v = 0;
        P1.store(p_val - 1, Ordering::Relaxed);
        self.d = [0; 2 * EMX as usize];

        if a == 0 {
            return 0;
        }

        let mut i = 0;
        let p1_val = P1.load(Ordering::Relaxed);

        // find -exponent of p in b
        while b % p_val == 0 {
            b = b / p_val;
            i -= 1;
        }

        let mut s = 0;
        let r = b % p_val;

        // modular inverse for small p
        let mut b1 = 1;
        while b1 <= p1_val {
            s += r;
            if s > p1_val {
                s -= p_val;
            }
            if s == 1 {
                break;
            }
            b1 += 1;
        }

        if b1 == p_val {
            println!("r2pa: impossible inverse mod");
            return -1;
        }

        self.v = EMX;

        loop {
            // find exponent of P in a
            while a % p_val == 0 {
                a = a / p_val;
                i += 1;
            }

            // valuation
            if self.v == EMX {
                self.v = i;
            }

            // upper bound
            if i >= EMX {
                break;
            }

            // check precision
            if (i - self.v) > k_val {
                break;
            }

            // next digit
            self.d[(i + EMX) as usize] = a * b1 % p_val;
            if self.d[(i + EMX) as usize] < 0 {
                self.d[(i + EMX) as usize] += p_val;
            }

            // remainder - digit * divisor
            a -= self.d[(i + EMX) as usize] * b;
            if a == 0 {
                break;
            }
        }

        0
    }

    // Horner's rule
    fn dsum(&self) -> i32 {
        let t = cmp::min(self.v, 0);
        let mut s = 0;
        let p_val = P.load(Ordering::Relaxed);
        let k_val = K.load(Ordering::Relaxed);

        for i in (t..=k_val - 1 + t).rev() {
            let r = s;
            s *= p_val;
            if r != 0 && (s / r - p_val != 0) {
                // overflow
                s = -1;
                break;
            }
            s += self.d[(i + EMX) as usize];
        }
        s
    }

    // add b to receiver
    fn add(&self, b: &Padic) -> Padic {
        let mut c = 0;
        let mut r = Padic::new();
        r.v = cmp::min(self.v, b.v);
        let p_val = P.load(Ordering::Relaxed);
        let p1_val = P1.load(Ordering::Relaxed);
        let k_val = K.load(Ordering::Relaxed);

        for i in r.v..=k_val + r.v {
            c += self.d[(i + EMX) as usize] + b.d[(i + EMX) as usize];
            if c > p1_val {
                r.d[(i + EMX) as usize] = c - p_val;
                c = 1;
            } else {
                r.d[(i + EMX) as usize] = c;
                c = 0;
            }
        }

        r
    }

    // complement of receiver
    fn cmpt(&self) -> Padic {
        let mut c = 1;
        let mut r = Padic::new();
        r.v = self.v;
        let p_val = P.load(Ordering::Relaxed);
        let p1_val = P1.load(Ordering::Relaxed);
        let k_val = K.load(Ordering::Relaxed);

        for i in self.v..=k_val + self.v {
            c += p1_val - self.d[(i + EMX) as usize];
            if c > p1_val {
                r.d[(i + EMX) as usize] = c - p_val;
                c = 1;
            } else {
                r.d[(i + EMX) as usize] = c;
                c = 0;
            }
        }

        r
    }

    // rational reconstruction
    fn crat(&self) {
        let mut fl = false;
        let mut s = self.clone();
        let mut j = 0;
        let mut i = 1;
        let p_val = P.load(Ordering::Relaxed);
        let p1_val = P1.load(Ordering::Relaxed);
        let k_val = K.load(Ordering::Relaxed);

        // denominator count
        while i <= DMX {
            // check for integer
            j = k_val - 1 + self.v;
            while j >= self.v {
                if s.d[(j + EMX) as usize] != 0 {
                    break;
                }
                j -= 1;
            }
            fl = ((j - self.v) * 2) < k_val;
            if fl {
                fl = false;
                break;
            }

            // check negative integer
            j = k_val - 1 + self.v;
            while j >= self.v {
                if p1_val - s.d[(j + EMX) as usize] != 0 {
                    break;
                }
                j -= 1;
            }
            fl = ((j - self.v) * 2) < k_val;
            if fl {
                break;
            }

            // repeatedly add self to s
            s = s.add(self);
            i += 1;
        }

        if fl {
            s = s.cmpt();
        }

        // numerator: weighted digit sum
        let x = s.dsum();
        let mut y = i;

        if x < 0 || y > DMX {
            println!("{} {}", x, y);
            println!("crat: fail");
        } else {
            // negative powers
            let mut i = self.v;
            while i <= -1 {
                y *= p_val;
                i += 1;
            }

            // negative rational
            let final_x = if fl { -x } else { x };
            print!("{}", final_x);
            if y > 1 {
                print!("/{}", y);
            }
            println!();
        }
    }

    // print expansion
    fn printf(&self, sw: i32) {
        let t = cmp::min(self.v, 0);
        let k_val = K.load(Ordering::Relaxed);

        for i in (t..=k_val - 1 + t).rev() {
            print!("{}", self.d[(i + EMX) as usize]);
            if i == 0 && self.v < 0 {
                print!(".");
            }
            print!(" ");
        }
        println!();
        // rational approximation
        if sw != 0 {
            self.crat();
        }
    }
}

// Implement the Clone trait for Padic
impl Clone for Padic {
    fn clone(&self) -> Self {
        Padic {
            v: self.v,
            d: self.d,
        }
    }
}

fn main() {
    let data = vec![
        /* rational reconstruction depends on the precision
           until the dsum-loop overflows */
        vec![2, 1, 2, 4, 1, 1],
        vec![4, 1, 2, 4, 3, 1],
        vec![4, 1, 2, 5, 3, 1],
        vec![4, 9, 5, 4, 8, 9],
        vec![26, 25, 5, 4, -109, 125],
        vec![49, 2, 7, 6, -4851, 2],
        vec![-9, 5, 3, 8, 27, 7],
        vec![5, 19, 2, 12, -101, 384],
        /* two decadic pairs */
        vec![2, 7, 10, 7, -1, 7],
        vec![34, 21, 10, 9, -39034, 791],
        /* familiar digits */
        vec![11, 4, 2, 43, 679001, 207],
        vec![-8, 9, 23, 9, 302113, 92],
        vec![-22, 7, 3, 23, 46071, 379],
        vec![-22, 7, 32749, 3, 46071, 379],
        vec![35, 61, 5, 20, 9400, 109],
        vec![-101, 109, 61, 7, 583376, 6649],
        vec![-25, 26, 7, 13, 5571, 137],
        vec![1, 4, 7, 11, 9263, 2837],
        vec![122, 407, 7, 11, -517, 1477],
        /* more subtle */
        vec![5, 8, 7, 11, 353, 30809],
    ];

    let mut sw = 0;
    let mut a = Padic::new();
    let mut b = Padic::new();

    for d in data {
        let q = Ratio { a: d[0], b: d[1] };

        P.store(d[2], Ordering::Relaxed);
        K.store(d[3], Ordering::Relaxed);

        sw = a.r2pa(q, 1);
        if sw == 1 {
            break;
        }
        a.printf(0);

        let q_b = Ratio { a: d[4], b: d[5] };
        sw = sw | b.r2pa(q_b, 1);
        if sw == 1 {
            break;
        }

        if sw == 0 {
            b.printf(0);
            let c = a.add(&b);
            println!("+ =");
            c.printf(1);
        }
        println!();
    }
}
