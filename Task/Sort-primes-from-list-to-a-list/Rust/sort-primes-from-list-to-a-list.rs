fn is_prime( number : u32 ) -> bool {
   let result : bool = match number {
      0 => false ,
      1 => false ,
      2 => true ,
      _ => {
         let limit : u32 = (number as f32).sqrt( ).floor( ) as u32 ;
         (2..=limit).filter( | &d | number % d == 0 ).count( ) == 0
      }
   } ;
   result
}

fn main() {
    let numbers : Vec<u32> = vec![2 , 43 , 81 , 122 , 63 , 7 , 95 , 103] ;
    let mut primes : Vec<u32> = numbers.into_iter( ).filter( | &d | is_prime( d ) ).
       collect( ) ;
    primes.sort( ) ;
    println!("{:?}" , primes )
}
