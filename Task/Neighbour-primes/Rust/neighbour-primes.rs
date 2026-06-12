fn main() {
    let mut primes_first : Vec<u64> = Vec::new( ) ;
    primal::Primes::all( ).take_while( | n | *n < 500 ).for_each( | num |
          primes_first.push( num as u64 ) ) ;
    let mut current : u64 = *primes_first.iter( ).last( ).unwrap( ) + 1 ;
    while ! primal::is_prime( current ) {
       current += 1 ;
    }
    primes_first.push( current ) ;
    let len = primes_first.len( ) ;
    let mut primes_searched : Vec<u64> = Vec::new( ) ;
    for i in 0..len - 2 {
       if primal::is_prime( primes_first[ i ] * primes_first[ i + 1 ] + 2 ) {
          let num = primes_first[ i ] ;
          primes_searched.push( num ) ;
       }
    }
    println!("{:?}" , primes_searched ) ;
}
