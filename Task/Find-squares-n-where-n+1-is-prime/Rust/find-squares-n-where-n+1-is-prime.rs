use primes::is_prime ;

fn is_square( number : u64 ) -> bool {
   let floor : u64 = (number as f64).sqrt( ).floor( ) as u64 ;
   floor * floor == number
}

fn main() {
   let solution : Vec<u64> = (1..1000).into_iter( ).
      filter( | d | is_square( *d ) && is_prime( *d + 1 )).collect( ) ;
    println!("{:?}" , solution);
}
