fn square(n: int) -> int {
    return n * n;
}

fn main() {
    let a = [1, 2, 3, 4, 5];
    for i in 0..a.len {
        a[i] = square(a[i]);
        println "{a[i]}";
    }
}
