// [dependencies]
// primal = "0.3"

fn main() {
    let p = primal::StreamingSieve::nth_prime(10001);
    println!("The 10001st prime is {}.", p);
}
