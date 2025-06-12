use std::cmp::{max, Ordering};
use std::collections::HashMap;
use std::fmt;
use std::ops::{Add, Div, Mul, Neg};

const MAX_ALL_FACTORS: i32 = 100000;
const ALGORITHM: i32 = 2;
static mut DIVISIONS: i32 = 0;

// Note: Cyclotomic Polynomials have small coefficients. Not appropriate for general polynomial usage.
#[derive(Clone, Debug)]
struct Term {
    coefficient: i64,
    exponent: i64,
}

impl Term {
    fn new(c: i64, e: i64) -> Self {
        Term {
            coefficient: c,
            exponent: e,
        }
    }

    fn coefficient(&self) -> i64 {
        self.coefficient
    }

    fn degree(&self) -> i64 {
        self.exponent
    }
}

impl Neg for Term {
    type Output = Term;

    fn neg(self) -> Self::Output {
        Term::new(-self.coefficient, self.exponent)
    }
}

impl Neg for &Term {
    type Output = Term;

    fn neg(self) -> Self::Output {
        Term::new(-self.coefficient, self.exponent)
    }
}

impl Mul for &Term {
    type Output = Term;

    fn mul(self, rhs: &Term) -> Self::Output {
        Term::new(self.coefficient * rhs.coefficient, self.exponent + rhs.exponent)
    }
}

impl Add for &Term {
    type Output = Term;

    fn add(self, rhs: &Term) -> Self::Output {
        if self.exponent != rhs.exponent {
            panic!("Exponents not equal");
        }
        Term::new(self.coefficient + rhs.coefficient, self.exponent)
    }
}

impl fmt::Display for Term {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if self.coefficient == 0 {
            return write!(f, "0");
        }
        if self.exponent == 0 {
            return write!(f, "{}", self.coefficient);
        }
        if self.coefficient == 1 {
            if self.exponent == 1 {
                return write!(f, "x");
            }
            return write!(f, "x^{}", self.exponent);
        }
        if self.coefficient == -1 {
            if self.exponent == 1 {
                return write!(f, "-x");
            }
            return write!(f, "-x^{}", self.exponent);
        }
        if self.exponent == 1 {
            return write!(f, "{}x", self.coefficient);
        }
        write!(f, "{}x^{}", self.coefficient, self.exponent)
    }
}

#[derive(Clone, Debug)]
struct Polynomial {
    polynomial_terms: Vec<Term>,
}

impl Polynomial {
    fn new() -> Self {
        let mut terms = Vec::new();
        terms.push(Term::new(0, 0));
        Polynomial {
            polynomial_terms: terms,
        }
    }

    fn from_values(values: &[i32]) -> Self {
        if values.len() % 2 != 0 {
            panic!("Length must be even.");
        }

        let mut terms = Vec::new();
        let mut i = 0;
        while i < values.len() {
            terms.push(Term::new(values[i] as i64, values[i + 1] as i64));
            i += 2;
        }

        terms.sort_by(|a, b| b.degree().cmp(&a.degree()));
        Polynomial {
            polynomial_terms: terms,
        }
    }

    fn from_term_list(term_list: &[Term]) -> Self {
        let mut terms = Vec::new();
        if term_list.is_empty() {
            terms.push(Term::new(0, 0));
        } else {
            for t in term_list {
                if t.coefficient() != 0 {
                    terms.push(t.clone());
                }
            }
            if terms.is_empty() {
                terms.push(Term::new(0, 0));
            }
            terms.sort_by(|a, b| b.degree().cmp(&a.degree()));
        }
        Polynomial {
            polynomial_terms: terms,
        }
    }

    fn leading_coefficient(&self) -> i64 {
        self.polynomial_terms[0].coefficient()
    }

    fn degree(&self) -> i64 {
        self.polynomial_terms[0].degree()
    }

    fn has_coefficient_abs(&self, coeff: i32) -> bool {
        for term in &self.polynomial_terms {
            if (term.coefficient() as i32).abs() == coeff {
                return true;
            }
        }
        false
    }

    fn add_term(&self, term: &Term) -> Polynomial {
        let mut term_list = Vec::new();
        let mut added = false;
        for current_term in &self.polynomial_terms {
            if current_term.degree() == term.degree() {
                added = true;
                let sum_coeff = current_term.coefficient() + term.coefficient();
                if sum_coeff != 0 {
                    term_list.push(Term::new(sum_coeff, term.degree()));
                }
            } else {
                term_list.push(current_term.clone());
            }
        }
        if !added {
            term_list.push(term.clone());
        }
        Polynomial::from_term_list(&term_list)
    }

    fn mul_term(&self, term: &Term) -> Polynomial {
        let mut term_list = Vec::new();
        for current_term in &self.polynomial_terms {
            term_list.push((current_term * term).clone());
        }
        Polynomial::from_term_list(&term_list)
    }
}

impl Add for &Polynomial {
    type Output = Polynomial;

    fn add(self, rhs: &Polynomial) -> Self::Output {
        let mut term_list = Vec::new();
        let mut this_count = self.polynomial_terms.len();
        let mut poly_count = rhs.polynomial_terms.len();

        while this_count > 0 || poly_count > 0 {
            if this_count == 0 {
                let poly_term = &rhs.polynomial_terms[poly_count - 1];
                term_list.push(poly_term.clone());
                poly_count -= 1;
            } else if poly_count == 0 {
                let this_term = &self.polynomial_terms[this_count - 1];
                term_list.push(this_term.clone());
                this_count -= 1;
            } else {
                let poly_term = &rhs.polynomial_terms[poly_count - 1];
                let this_term = &self.polynomial_terms[this_count - 1];

                match this_term.degree().cmp(&poly_term.degree()) {
                    Ordering::Equal => {
                        let t = this_term + poly_term;
                        if t.coefficient() != 0 {
                            term_list.push(t);
                        }
                        this_count -= 1;
                        poly_count -= 1;
                    },
                    Ordering::Less => {
                        term_list.push(this_term.clone());
                        this_count -= 1;
                    },
                    Ordering::Greater => {
                        term_list.push(poly_term.clone());
                        poly_count -= 1;
                    }
                }
            }
        }
        Polynomial::from_term_list(&term_list)
    }
}

impl Div for &Polynomial {
    type Output = Polynomial;

    fn div(self, v: &Polynomial) -> Self::Output {
        unsafe {
            DIVISIONS += 1;
        }

        let mut q = Polynomial::new();
        let mut r = self.clone();
        let lcv = v.leading_coefficient();
        let dv = v.degree();

        while r.degree() >= v.degree() {
            let lcr = r.leading_coefficient();
            let s = lcr / lcv;
            let term = Term::new(s, r.degree() - dv);
            q = &q + &q.add_term(&term);
            r = &r + &v.mul_term(&(-&term));
        }

        q
    }
}

impl fmt::Display for Polynomial {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut it = self.polynomial_terms.iter();
        if let Some(term) = it.next() {
            write!(f, "{}", term)?;
        }

        for term in it {
            if term.coefficient() > 0 {
                write!(f, " + {}", term)?;
            } else {
                write!(f, " - {}", -term)?;
            }
        }
        Ok(())
    }
}

fn get_divisors(number: i32) -> Vec<i32> {
    let mut divisors = Vec::new();
    let root = (number as f64).sqrt() as i32;

    for i in 1..=root {
        if number % i == 0 {
            divisors.push(i);
            let div = number / i;
            if div != i && div != number {
                divisors.push(div);
            }
        }
    }
    divisors
}

fn get_factors(number: i32, all_factors: &mut HashMap<i32, HashMap<i32, i32>>) -> HashMap<i32, i32> {
    if let Some(factors) = all_factors.get(&number) {
        return factors.clone();
    }

    let mut factors = HashMap::new();
    if number % 2 == 0 {
        let factors_div_two = get_factors(number / 2, all_factors);
        factors.extend(factors_div_two);
        *factors.entry(2).or_insert(0) += 1;

        if number < MAX_ALL_FACTORS {
            all_factors.insert(number, factors.clone());
        }
        return factors;
    }

    let root = (number as f64).sqrt() as i64;
    let mut i = 3;
    while i <= root {
        if number % i as i32 == 0 {
            let factors_div_i = get_factors(number / i as i32, all_factors);
            factors.extend(factors_div_i);
            *factors.entry(i as i32).or_insert(0) += 1;

            if number < MAX_ALL_FACTORS {
                all_factors.insert(number, factors.clone());
            }
            return factors;
        }
        i += 2;
    }

    factors.insert(number, 1);
    if number < MAX_ALL_FACTORS {
        all_factors.insert(number, factors.clone());
    }
    factors
}

fn cyclotomic_polynomial(n: i32, computed: &mut HashMap<i32, Polynomial>, all_factors: &mut HashMap<i32, HashMap<i32, i32>>) -> Polynomial {
    if let Some(poly) = computed.get(&n) {
        return poly.clone();
    }

    if n == 1 {
        // Polynomial: x - 1
        let p = Polynomial::from_values(&[1, 1, -1, 0]);
        computed.insert(1, p.clone());
        return p;
    }

    let factors = get_factors(n, all_factors);

    if factors.contains_key(&n) {
        // n prime
        let mut term_list = Vec::new();
        for index in 0..n {
            term_list.push(Term::new(1, index as i64));
        }

        let cyclo = Polynomial::from_term_list(&term_list);
        computed.insert(n, cyclo.clone());
        return cyclo;
    } else if factors.len() == 2 && factors.contains_key(&2) && factors[&2] == 1 &&
              factors.contains_key(&(n / 2)) && factors[&(n / 2)] == 1 {
        // n = 2p
        let prime = n / 2;
        let mut term_list = Vec::new();
        let mut coeff = -1;

        for index in 0..prime {
            coeff *= -1;
            term_list.push(Term::new(coeff, index as i64));
        }

        let cyclo = Polynomial::from_term_list(&term_list);
        computed.insert(n, cyclo.clone());
        return cyclo;
    } else if factors.len() == 1 && factors.contains_key(&2) {
        // n = 2^h
        let h = factors[&2];
        let mut term_list = Vec::new();
        term_list.push(Term::new(1, 2i64.pow(h as u32 - 1)));
        term_list.push(Term::new(1, 0));

        let cyclo = Polynomial::from_term_list(&term_list);
        computed.insert(n, cyclo.clone());
        return cyclo;
    } else if factors.len() == 1 && factors.contains_key(&n) {
        // n = p^k
        let mut p = 0;
        let mut k = 0;
        for (key, value) in &factors {
            p = *key;
            k = *value;
        }
        let mut term_list = Vec::new();
        for index in 0..p {
            term_list.push(Term::new(1, (index * p.pow(k as u32 - 1)) as i64));
        }

        let cyclo = Polynomial::from_term_list(&term_list);
        computed.insert(n, cyclo.clone());
        return cyclo;
    } else if factors.len() == 2 && factors.contains_key(&2) {
        // n = 2^h * p^k
        let mut p = 0;
        for (key, _) in &factors {
            if *key != 2 {
                p = *key;
            }
        }

        let mut term_list = Vec::new();
        let mut coeff = -1;
        let two_exp = 2i32.pow(factors[&2] as u32 - 1);
        let k = factors[&p];
        for index in 0..p {
            coeff *= -1;
            term_list.push(Term::new(coeff, (index * two_exp * p.pow(k as u32 - 1)) as i64));
        }

        let cyclo = Polynomial::from_term_list(&term_list);
        computed.insert(n, cyclo.clone());
        return cyclo;
    } else if factors.contains_key(&2) && ((n / 2) % 2 == 1) && (n / 2) > 1 {
        // CP(2m)[x] = CP(-m)[x], n odd integer > 1
        let cyclo_div2 = cyclotomic_polynomial(n / 2, computed, all_factors);
        let mut term_list = Vec::new();
        for term in &cyclo_div2.polynomial_terms {
            if term.degree() % 2 == 0 {
                term_list.push(term.clone());
            } else {
                term_list.push(-term);
            }
        }

        let cyclo = Polynomial::from_term_list(&term_list);
        computed.insert(n, cyclo.clone());
        return cyclo;
    }

    // General Case
    match ALGORITHM {
        0 => {
            // slow - uses basic definition
            let divisors = get_divisors(n);
            // Polynomial: (x^n - 1)
            let mut cyclo = Polynomial::from_values(&[1, n as i32, -1, 0]);
            for i in divisors {
                let p = cyclotomic_polynomial(i, computed, all_factors);
                cyclo = &cyclo / &p;
            }

            computed.insert(n, cyclo.clone());
            cyclo
        },
        1 => {
            // Faster. Remove Max divisor (and all divisors of max divisor) - only one divide for all divisors of Max Divisor
            let divisors = get_divisors(n);
            let mut max_divisor = i32::MIN;
            for div in &divisors {
                max_divisor = max(max_divisor, *div);
            }
            let mut divisor_except_max = Vec::new();
            for div in divisors {
                if max_divisor % div != 0 {
                    divisor_except_max.push(div);
                }
            }

            // Polynomial: ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
            let mut cyclo = &Polynomial::from_values(&[1, n as i32, -1, 0]) /
                             &Polynomial::from_values(&[1, max_divisor, -1, 0]);

            for i in divisor_except_max {
                let p = cyclotomic_polynomial(i, computed, all_factors);
                cyclo = &cyclo / &p;
            }

            computed.insert(n, cyclo.clone());
            cyclo
        },
        2 => {
            // Fastest
            // Let p ; q be primes such that p does not divide n, and q divides n.
            // Then CP(np)[x] = CP(n)[x^p] / CP(n)[x]
            let mut m = 1;
            let mut cyclo = cyclotomic_polynomial(m, computed, all_factors);
            let mut primes = Vec::new();
            for (prime, _) in &factors {
                primes.push(*prime);
            }
            primes.sort();

            for prime in primes {
                // CP(m)[x]
                let cyclo_m = cyclo.clone();
                // Compute CP(m)[x^p].
                let mut term_list = Vec::new();
                for t in &cyclo_m.polynomial_terms {
                    term_list.push(Term::new(t.coefficient(), t.degree() * prime as i64));
                }
                cyclo = &Polynomial::from_term_list(&term_list) / &cyclo_m;
                m = m * prime;
            }

            // Now, m is the largest square free divisor of n
            let s = n / m;
            // Compute CP(n)[x] = CP(m)[x^s]
            let mut term_list = Vec::new();
            for t in &cyclo.polynomial_terms {
                term_list.push(Term::new(t.coefficient(), t.degree() * s as i64));
            }

            cyclo = Polynomial::from_term_list(&term_list);
            computed.insert(n, cyclo.clone());
            cyclo
        },
        _ => panic!("Invalid algorithm"),
    }
}

fn main() {
    // initialization
    let mut all_factors = HashMap::new();
    let mut factors = HashMap::new();
    factors.insert(2, 1);
    all_factors.insert(2, factors);

    let mut computed = HashMap::new();

    // Task 1: cyclotomic polynomials for n <= 30
    println!("Task 1:  cyclotomic polynomials for n <= 14:");
    for i in 1..=14 {
        let p = cyclotomic_polynomial(i, &mut computed, &mut all_factors);
        println!("CP[{}] = {}", i, p);
    }

    // Task 2: Smallest cyclotomic polynomial with n or -n as a coefficient
    println!("Task 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:");
    let mut n = 0;
    for i in 1..=2 {
        loop {
            n += 1;
            let cyclo = cyclotomic_polynomial(n, &mut computed, &mut all_factors);
            if cyclo.has_coefficient_abs(i) {
                println!("CP[{}] has coefficient with magnitude = {}", n, i);
                n -= 1;
                break;
            }
        }
    }
}
