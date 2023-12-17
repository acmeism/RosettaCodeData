use std::collections::HashSet ;

fn main() {
   let mut recamans : Vec<i32> = Vec::new( ) ;
   let mut reca_set : HashSet<i32> = HashSet::new() ;
   let mut first_nums : HashSet<i32> = HashSet::new( ) ;
   for i in 0i32..=1000 {
      first_nums.insert( i ) ;
   }
   recamans.push( 0 ) ;
   reca_set.insert( 0 ) ;
   let mut current : i32 = 0 ;
   while ! first_nums.is_subset( &reca_set ) {
      current += 1 ;
      let mut nextnum : i32 = recamans[( current as usize ) - 1] - current ;
      if nextnum < 0 || reca_set.contains( &nextnum ) {
         nextnum = recamans[(current as usize ) - 1 ] + current ;
      }
      recamans.push( nextnum ) ;
      reca_set.insert( nextnum ) ;
      if current == 15 {
         println!("The first 15 numbers of the Recaman sequence are:" ) ;
         println!("{:?}" , recamans ) ;
      }
   }
   println!("To generate all numbers from 0 to 1000 , one has to go to element {}" , current) ;
}
