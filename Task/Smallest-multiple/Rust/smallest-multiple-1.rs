fn main() {
   let mut current : u32 = 2520 ;
   while ! (1u32..=20u32).all( | i | current % i == 0 ) {
      current += 1 ;
   }
   println!("{}" , current) ;
}
