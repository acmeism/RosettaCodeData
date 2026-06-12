use num_prime::{nt_funcs, Primality, PrimalityTestConfig};


const LIMIT: usize = 15_000;

fn main() {
    let mut p = 2_usize;
    let mut n = 1;

    print!("2 ");
    loop {
        let new_p = p + n * n * n;
        if nt_funcs::is_prime(&new_p, Some(PrimalityTestConfig::strict())) == Primality::Yes {
            p = new_p;
            n = 1;
            print!("{} ", p);
        } else {
            n += 1;
            if new_p >= LIMIT {
                break;
            }
        }
    }
}
