fn condition( num : u16 ) -> bool {
   let divis : Vec<u16> = divisors( num ) ;
   let reversed : u16 = my_reverse( num ) ;
   divis.iter( ).all( | d | {
         let revi = my_reverse( *d ) ;
         reversed % revi == 0 } )
}

fn my_reverse( num : u16 ) -> u16 {
   let numstring : String = num.to_string( ) ;
   let nstr : &str = numstring.as_str( ) ;
   let mut reversed_str : String = String::new( ) ;
   for c in  nstr.chars( ).rev( ) {
      reversed_str.push( c ) ;
   }
   let reversi : &str = reversed_str.as_str( ) ;
   reversi.parse::<u16>( ).unwrap( )
}

fn divisors( n : u16 ) -> Vec<u16> {
   (1..=n).filter( | &d | n % d == 0 ).collect( )
}

fn main() {
    println!("{:?}" , (1u16..200u16).filter( | &d | condition( d ) ).collect
          ::<Vec<u16>>( ) )  ;
}
