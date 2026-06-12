use prime_tools ;

fn is_square_number( num : u32 ) -> bool {
   let comp_num : f32 = num as f32 ;
   let root = comp_num.sqrt( ) ;
   return root == root.floor( ) ;
}

fn main() {
   let primes: Vec<u32> = prime_tools::get_primes_less_than_x(1000000_u32) ;
   let len = primes.len( ) ;
   let mut i : usize = 0 ;
   while  i < len - 1  {
      let diff : u32 = primes[ i + 1 ] - primes[ i ] ;
      if diff > 36 && is_square_number( diff ) {
         println!("{} - {} = {}" , primes[ i + 1 ] , primes[ i ] , diff) ;
      }
      i += 1 ;
   }
}
