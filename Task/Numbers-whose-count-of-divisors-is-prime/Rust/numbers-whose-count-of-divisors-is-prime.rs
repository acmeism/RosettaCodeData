fn count_divisors(number : u64 ) -> u64 {
   let mut divisors : u64 = 0 ;
   for n in 1..=number {
      if number % n == 0 {
         divisors += 1 ;
      }
   }
   divisors
}

fn main() {
   let mut the_numbers : Vec<u64> = Vec::new( ) ;
   let mut count : i32 = 0 ;
   for n in 1..100000 {
      let divis = count_divisors( n as u64 ) ;
      if divis > 2 && primal::is_prime( divis ) {
         the_numbers.push( n ) ;
      }
   }
   for n in the_numbers {
      count += 1 ;
      print!(" {:6}" , n ) ;
      if count % 8 == 0 {
         println!( ) ;
      }
   }
   println!( ) ;
   println!("count is {}" , count) ;
}
