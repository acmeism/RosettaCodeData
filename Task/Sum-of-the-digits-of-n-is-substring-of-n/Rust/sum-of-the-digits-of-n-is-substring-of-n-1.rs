fn sum_digits( mut num : u32 ) -> u32 {
   let mut sum : u32 = 0 ;
   while num != 0 {
      sum += num % 10 ;
      num /= 10 ;
   }
   sum
}

fn main() {
    let solution : Vec<u32> = (0..1000).filter( | &d | {
          let digit_sum : u32 = sum_digits( d ) ;
          let sumstring = digit_sum.to_string( ) ;
          let sumstr : &str = sumstring.as_str( ) ;
          let numstring : String = d.to_string( ) ;
          let numstr : &str = numstring.as_str( ) ;
          numstr.contains( &sumstr )
          }).collect( ) ;
    println!("{:?}" , solution ) ;
}
