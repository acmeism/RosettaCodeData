fn is_prime( number : u32 ) -> bool {
   let limit : u32 = (number as f32).sqrt( ).floor( ) as u32 ;
   (2..=limit).all( | i | number % i != 0 )
}

fn has_one_odd( mut number : u32 ) -> bool {
   let mut digits : Vec<u32> = Vec::new( ) ;
   while number != 0 {
      digits.push( number % 10 ) ;
      number /= 10 ;
   }
   digits.into_iter( ).filter( | &d | d % 2 == 1 ).count( ) == 1
}

fn main() {
   let mut solution_primes : Vec<u32> = Vec::new( ) ;
   (2..1000).filter( | &d | is_prime( d ) && has_one_odd( d )).for_each( | n | {
            solution_primes.push( n ) ;
            } ) ;
   println!("Prime numbers under 1000 with only one odd digit:") ;
   println!("{:?}" , solution_primes ) ;
   println!("Number of primes under 1000000 with only one odd digit : {}" ,
         (2..1000000).filter( | &d  | is_prime( d ) && has_one_odd( d ) ).count( ) ) ;
