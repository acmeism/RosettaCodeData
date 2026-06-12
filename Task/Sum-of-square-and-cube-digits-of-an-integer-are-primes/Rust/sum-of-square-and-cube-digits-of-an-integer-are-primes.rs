fn is_prime( number : u32 ) -> bool {
   if number < 2 {
      false
   }
   else {
      let limit : u32 = (number as f32).sqrt( ).floor( ) as u32 ;
      let mut nums : Vec<u32> = Vec::new( ) ;
      for i in 2..=limit {
         nums.push( i ) ;
      }
      nums.iter( ).filter( | n | number % *n == 0 ).count( ) == 0
   }
}

fn to_digits( mut number : u32 ) -> Vec<u32> {
   let mut digits : Vec<u32> = Vec::new( ) ;
   while number != 0 {
      let remainder : u32 = number % 10 ;
      digits.push( remainder ) ;
      number /= 10 ;
   }
   digits
}

fn digit_sum( number : u32 ) -> u32 {
   let digits : Vec<u32> = to_digits( number ) ;
   digits.iter( ).sum( )
}

fn main() {
   let mut solution : Vec<u32> = Vec::new( ) ;
   for i in 2..=100 {
      let square = i * i ;
      let cube = square * i ;
      if is_prime( digit_sum( square ) ) && is_prime( digit_sum(cube ) ) {
         solution.push( i ) ;
      }
   }
   println!("{:?}" , solution);
}
