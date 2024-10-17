fn factorial(n: i64) -> i64 {
    let mut total = 1;
    for i in 1..n+1 {
        total *= i;
    }
    return total;
}

fn main() {
    println!("Factorial of 10 is {}.", factorial(10));
}
