fn main() {
   let mut big_squares : Vec<u64> = Vec::new( ) ;
   let mut numberstrings : Vec<String> = Vec::new( ) ;
   for n in 0..8 {
      let mut numberstring : String = String::new( ) ;
      for i in 0..=n {
         if  i != 0  {
            numberstring.push( '1' ) ;
         }
      }
      numberstring.push('3') ;
      let number : u64 = numberstring.parse::<u64>().unwrap( ) ;
      numberstrings.push( numberstring ) ;
      big_squares.push( number.pow( 2 )) ;
   }
   for i in 0..numberstrings.len( ) {
      print!("{} ^ 2 =" , numberstrings[ i ] ) ;
      let width = 30 - (7 + i )  ;
      println!("{:>width$}" , big_squares[ i ] ) ;
   }
}
