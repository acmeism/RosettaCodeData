import "std/math.zc"

fn is_square(n: int) -> bool {
    let sqrt = (int)Math::round(Math::sqrt((f64)n));
    return sqrt * sqrt == n;
}

fn main() {
    for i in 101..1000 step 2 {
        if is_square(i) { print "{i} "; }
    }
    println "";
}
