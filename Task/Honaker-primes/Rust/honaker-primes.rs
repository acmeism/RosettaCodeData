//includes primal = "0.2" in dependencies

fn digit_sum( mut number: usize) -> usize {
   let mut sum : usize = 0 ;
   while number != 0 {
      sum += number % 10 ;
      number /= 10 ;
   }
   sum
}

fn main() {
   let mut count : i32 = 0 ;
   let mut pos : i32 = 1 ;
   println!("The first 50 Honaker primes:") ;
   primal::Primes::all( ).enumerate( ).map( |( i , w )| (i + 1 , w) ).
      filter( |(i , w)| digit_sum( *i ) == digit_sum( *w ) ).take( 50 ).
      for_each( |(i , w )| {
            count += 1 ;
            print!("(p:{} ,ind:{} ,val:{}) " , pos , i, w ) ;
            pos += 1 ;
            if count % 3 == 0 {
               println!( ) ;
            }
      }) ;
   println!( ) ;
}
