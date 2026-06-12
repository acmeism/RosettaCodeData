// 202100327 Rust programming solution

use primes::is_prime;

fn main() {

   let mut count = 0;
   let begin     = 0;
   let end       = 200;

   println!("Find prime numbers of the form");
   println!("   n => n³ + 2 ");

   for n in begin+1..end-1 {
      let m = n*n*n+2;
      if is_prime(m) {
        println!("{:4} => {}", n, m);
        count += 1;
      }
   }

   println!("Found {} such prime numbers where {} < n < {}.", count,begin,end);
}
