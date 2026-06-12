fn is_prime( number : u16 ) -> bool {
   let limit : u16 = (number as f32).sqrt( ).floor( ) as u16 ;
   (2..=limit).all( | i | number % i != 0 )
}

fn main() {
   let primes : Vec<u16> = (2..100).filter( | &d | is_prime( d ) ).collect( ) ;
   let prime_slice = &primes[..] ;
   let mut iter = prime_slice.windows( 2 ) ;
   while let Some( p ) = iter.next( ) {
      if is_prime( p[0] + p[1] - 1 ) {
         println!("({} , {})" , p[0] , p[1] );
      }
   }
}
