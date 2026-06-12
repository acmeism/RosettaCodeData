use primes::is_prime ;

fn main() {
    println!("{}" , (2u64..2000000u64).filter( | &d | is_prime( d )).sum::<u64>() ) ;
}
