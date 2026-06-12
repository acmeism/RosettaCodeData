fn is_upside_down( num : u32 ) -> bool {
   let numberstring : String = num.to_string( ) ;
   let len = numberstring.len( ) ;
   let numberstr = numberstring.as_str( ) ;
   if numberstr.contains( "0" ) {
      return false ;
   }
   if len % 2 == 1 && numberstr.chars( ).nth( len / 2 ).unwrap( ) != '5' {
      return false ;
   }
   let mut forward : usize = 0 ;
   let mut backward : usize = len - 1 ;
   while forward <= backward {
      let first = numberstr.chars( ).nth( forward ).expect("No digit!").
         to_digit( 10 ).unwrap( ) ;
      let second = numberstr.chars( ).nth( backward ).expect("No digit!").
         to_digit( 10 ).unwrap( ) ;
      if first + second != 10 {
         return false ;
      }
      forward += 1 ;
      if backward != 0 {
         backward -= 1 ;
       }
   }
   true
}

fn main() {
    let mut solution : Vec<u32> = Vec::new( ) ;
    let mut sum : u32 = 0 ;
    let mut current : u32 = 0 ;
    while sum < 50 {
       current += 1 ;
       if is_upside_down( current ) {
          solution.push( current ) ;
          sum += 1 ;
       }
    }
    let five_hundr : u32 ;
    while sum != 500 {
       current += 1 ;
       if is_upside_down( current ) {
          sum += 1 ;
       }
    }
    five_hundr = current ;
    let five_thous : u32 ;
    while sum != 5000 {
       current += 1 ;
       if is_upside_down( current ) {
          sum += 1 ;
       }
    }
    five_thous = current ;
    println!("The first 50 upside-down numbers:") ;
    println!("{:?}" , solution ) ;
    println!("The five hundredth such number : {}" , five_hundr) ;
    println!("The five thousandth such number : {}" , five_thous ) ;
}
