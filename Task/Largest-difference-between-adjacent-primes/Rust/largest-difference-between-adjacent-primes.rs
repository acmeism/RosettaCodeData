fn is_prime( num : u32 ) -> bool {
   if num == 1 {
      return false ;
   }
   else {
      let root : f32 = (num as f32).sqrt( ) ;
      let limit : u32 = root.floor( ) as u32 ;
      (2..=limit).filter( | &d | num % d == 0 ).collect::<Vec<u32>>( ).len( ) == 0
   }
}

fn main() {
    let target_primes : Vec<u32> = (2..1000000).filter( | &d | is_prime( d ) ).
       collect( ) ;
    let mut diff : u32 = target_primes[ 1 ] - target_primes[ 0 ] ;
    let len = target_primes.len( ) ;
    for i in 1..len - 1 {
       let current_diff = target_primes[i + 1] - target_primes[ i ] ;
       if current_diff > diff {
          diff = current_diff ;
       }
    }
    println!("{}" , diff ) ;
}
