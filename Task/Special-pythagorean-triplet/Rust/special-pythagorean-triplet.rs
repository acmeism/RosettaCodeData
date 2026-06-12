use std::collections::HashSet ;

fn main() {
    let mut numbers : HashSet<u32> = HashSet::new( ) ;
    for a in 1u32..=1000u32 {
       for b in 1u32..=1000u32 {
          for c in 1u32..=1000u32 {
             if a + b + c == 1000 && a * a + b * b == c * c {
                numbers.insert( a ) ;
                numbers.insert( b ) ;
                numbers.insert( c ) ;
             }
          }
       }
    }
    let mut product : u32 = 1 ;
    for k in &numbers {
       product *= *k ;
    }
    println!("{:?}" , numbers ) ;
    println!("The product of {:?} is {}" , numbers , product) ;
}
