use prime_tools ;

fn prime_decomposition( mut number : u32) -> Vec<u32> {
   let mut divisors : Vec<u32> = Vec::new( ) ;
   let mut divisor : u32 = 2 ;
   while number != 1 {
      if number % divisor == 0 {
         divisors.push( divisor ) ;
         number /= divisor ;
      }
      else {
         divisor += 1 ;
      }
   }
   divisors
}

fn is_giuga( num : u32 ) -> bool {
   let prime_factors : Vec<u32> = prime_decomposition( num ) ;
   ! prime_tools::is_u32_prime( num ) &&
      prime_factors.into_iter( ).all( |n : u32| (num/n -1) % n == 0 )
}

fn main() {
   let mut giuga_numbers : Vec<u32> = Vec::new( ) ;
   let mut num : u32 = 2 ;
   while giuga_numbers.len( ) != 4 {
      if is_giuga( num ) {
         giuga_numbers.push( num ) ;
      }
      num += 1 ;
   }
   println!("{:?}" , giuga_numbers ) ;
}
