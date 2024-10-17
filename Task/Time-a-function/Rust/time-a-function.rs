// 20210224 Rust programming solution

use rand::Rng;
use std::time::{Instant};

fn custom_function() {

   let mut i = 0;
   let mut rng = rand::thread_rng();
   let n1: f32 = rng.gen();

   while i < ( 1000000 + 1000000 * ( n1.log10() as i32 ) ) {
      i = i + 1;
   }
}

fn main() {

   let start = Instant::now();
   custom_function();
   let duration = start.elapsed();

   println!("Time elapsed in the custom_function() is : {:?}", duration);
}
