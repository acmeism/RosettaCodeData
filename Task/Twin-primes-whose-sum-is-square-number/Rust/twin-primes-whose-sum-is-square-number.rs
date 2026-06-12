use num_integer::Roots;
use num_prime::{nt_funcs::is_prime, Primality, PrimalityTestConfig};

fn main() {
    let config = PrimalityTestConfig::default();
    for n in 1_u64..10_000_000 {
        if n + n + 2 == (n + n + 2).sqrt().pow(2)
            && is_prime(&n, Some(config)) == Primality::Yes
            && is_prime(&(n + 2), Some(config)) == Primality::Yes
        {
            println!("{}^2 = {} + {}", (2 * n + 2).sqrt(), n, n + 2);
        }
    }
}
