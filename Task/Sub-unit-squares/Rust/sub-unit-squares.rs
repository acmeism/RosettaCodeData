fn is_square_number( number : u64 ) -> bool {
   let root : f64 = (number as f64).sqrt( ).floor( ) ;
   (root as u64) * (root as u64) == number
}

fn is_subunit_square( number : u64 ) -> bool {
   let numberstring = number.to_string( ) ;
   let numstring : &str = numberstring.as_str( ) ;
   if numstring.contains( '0' ) {
      return false ;
   }
   else {
      if number < 10 {
         is_square_number( number ) && is_square_number( number - 1 )
      }
      else {
         let mut digits : Vec<u64> = Vec::new( ) ;
         let mut num : u64 = number ;
         while num != 0 {
            digits.push( num % 10 ) ;
            num /= 10 ;
         }
         for n in digits.iter_mut( ) {
            *n -= 1 ;
         }
         let mut sum : u64 = 0 ;
         let mut factor : u64 = 1 ;
         for d in digits {
            sum += d * factor ;
            factor *= 10 ;
         }
         is_square_number( sum ) && is_square_number( number )
      }
   }
}

fn main() {
   let mut solution : Vec<u64> = Vec::new( ) ;
   let mut current : u64 = 1 ;
   while solution.len( ) != 7 {
      if is_subunit_square( current ) {
         solution.push( current ) ;
      }
      current += 1 ;
   }
   println!("{:?}" , solution ) ;
}
