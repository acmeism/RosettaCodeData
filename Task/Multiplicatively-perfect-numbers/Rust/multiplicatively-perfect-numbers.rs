fn divisors( num : u128 ) -> Vec<u128> {
   (1..= num).filter( | &d | num % d == 0 ).collect( )
}

fn main() {
   println!("{:?}" , (1..= 500).filter( | &d | {
            let divis : Vec<u128> = divisors( d ) ;
            let prod : u128 = divis.iter( ).product( ) ;
            prod == d.checked_pow( 2 ).unwrap( )
            }).collect::<Vec<u128>>( ) ) ;
}
