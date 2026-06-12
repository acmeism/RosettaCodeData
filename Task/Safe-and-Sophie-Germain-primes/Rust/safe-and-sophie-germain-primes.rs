fn is_prime( num : u32 ) -> bool {
   let limit : u32 = (num as f32).sqrt( ).floor( ) as u32 ;
   (2..=limit).all( | x | num % x != 0 )
}

fn main() {
   let mut sophie_primes : Vec<u32> = Vec::new( ) ;
   let mut count : u8 = 0 ;
   let mut current : u32 = 2 ;
   while count < 50 {
      if is_prime( current ) && is_prime( 2 * current + 1 ) {
         sophie_primes.push( current ) ;
         count += 1 ;
      }
      current += 1 ;
   }
   println!("The first 50 Sophie - Germain primes:" ) ;
   let mut ct : u8 = 0 ;
   for num in sophie_primes {
      print!("{:>5}" , num ) ;
      ct += 1 ;
      if  ct % 10 == 0  {
        println!("") ;
        ct = 0 ;
      }
   }
}
