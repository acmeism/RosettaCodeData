fn boolean_ops(a: bool, b: bool) {
    println!("{} and {} -> {}", a, b, a && b);
    println!("{} or {} -> {}", a, b, a || b);
    println!("{} xor {} -> {}", a, b, a ^ b);
    println!("not {} -> {}\n", a, !a);
}

fn main() {
    boolean_ops(true, true);
    boolean_ops(true, false);
    boolean_ops(false, true);
    boolean_ops(false, false)
}
