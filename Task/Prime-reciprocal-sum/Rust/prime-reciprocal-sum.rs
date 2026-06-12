use num_bigint::{BigInt, Sign};
use num_prime::{nt_funcs::next_prime, PrimalityTestConfig};
use num_rational::BigRational;
use num_traits::{Inv, One};

/// Abbreviate a large string by showing beginning / end and number of chars
fn abbreviate(st: String) -> String {
    const MAX_WIDTH: usize = 40;
    let w = st.len();
    if w < MAX_WIDTH {
        return st;
    }
    let s = st.as_str();
    let x = (MAX_WIDTH + 1) / 2;
    return String::new() + &s[..x] + ".." + &s[w - x..] + &format!(" ({} digits)", w);
}

fn oeis75442(wanted: usize) {
    let mut prime_sum = BigRational::new(BigInt::ZERO, BigInt::one());
    let config = PrimalityTestConfig::default();
    let one = BigRational::from(BigInt::one());
    for i in 1..=wanted {
        let mut n = (one.clone() - prime_sum.clone())
            .inv()
            .ceil()
            .numer()
            .to_owned();
        loop {
            n = BigInt::from_biguint(
                Sign::Plus,
                next_prime(&(BigInt::from(n).to_biguint().unwrap()), Some(config)).unwrap(),
            );
            let m = BigRational::from(n.clone()).inv();
            if prime_sum.clone() + m.clone() < one {
                prime_sum += m;
                println!("{:2} : {}", i, abbreviate(n.to_string()));
                break;
            }
        }
    }
}

fn main() {
    oeis75442(17);
}
