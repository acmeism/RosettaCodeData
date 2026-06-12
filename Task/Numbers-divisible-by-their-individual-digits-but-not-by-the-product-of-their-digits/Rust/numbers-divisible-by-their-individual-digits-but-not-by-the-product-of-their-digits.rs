fn to_digits( n : i32 ) -> Vec<i32> {
   let mut i : i32 = n ;
   let mut digits : Vec<i32> = Vec::new( ) ;
   while i != 0 {
      digits.push( i % 10 ) ;
      i /= 10 ;
   }
   digits
}

fn my_condition( num : i32 ) -> bool {
   let digits : Vec<i32> = to_digits( num ) ;
   if ! digits.iter( ).any( | x | *x == 0 ) {
      let prod : i32 = digits.iter( ).product( ) ;
      return digits.iter( ).all( | x | num % x == 0 ) &&
         num % prod != 0 ;
   }
   else {
      false
   }
}

fn main() {
let mut count : i32 = 0 ;
   for n in 10 .. 1000 {
      if my_condition( n ) {
         print!("{:5}" , n) ;
         count += 1 ;
         if count % 10 == 0 {
            println!( ) ;
         }
      }
   }
   println!();
}
