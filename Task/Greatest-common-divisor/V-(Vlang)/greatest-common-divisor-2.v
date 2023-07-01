import math.big
fn gcd(x i64, y i64) i64 {
    return big.integer_from_i64(x).gcd(big.integer_from_i64(y)).int()
}

fn main() {
    println(gcd(33, 77))
    println(gcd(49865, 69811))
}
