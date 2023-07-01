fn gcd(xx int, yy int) int {
    mut x, mut y := xx, yy
    for y != 0 {
        x, y = y, x%y
    }
    return x
}

fn main() {
    println(gcd(33, 77))
    println(gcd(49865, 69811))
}
