fn is_even<T>(n: T) -> bool {
    return n & 1 == 0;
}

fn is_odd<T>(n: T) -> bool {
    return n & 1 == 1;
}

fn main() {
    let n1: i32 = 124;
    println "{n1} is even? {is_even(n1)}";
    println "{n1} is odd ? {is_odd(n1)}";
    println "";
    let n2: i64 = -1231231231231231237;
    println "{n2} is even? {is_even(n2)}";
    println "{n2} is odd ? {is_odd(n2)}";
}
