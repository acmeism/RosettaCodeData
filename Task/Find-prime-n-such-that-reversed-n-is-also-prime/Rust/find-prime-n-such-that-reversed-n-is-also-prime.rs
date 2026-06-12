use prime_tools ;

fn myreverse( n : u32 ) -> u32 {
   let forward : String = n.to_string( ) ;
   let numberstring = &forward[..] ;
   let mut reversed : String = String::new( ) ;
   for c in numberstring.chars( ).rev( ) {
      reversed.push( c ) ;
   }
   *&reversed[..].parse::<u32>( ).unwrap( )
}

fn main() {
   let mut reversible_primes : Vec<u32> = Vec::new( ) ;
   for num in 2..=500 {
      if prime_tools::is_u32_prime( num ) && prime_tools::is_u32_prime(
               myreverse( num ))  {
            reversible_primes.push( num ) ;
      }
   }
   println!("{:?}" , reversible_primes ) ;
}
