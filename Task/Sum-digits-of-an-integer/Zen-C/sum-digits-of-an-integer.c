fn digits_sum(n: int, b: const int) -> int {
    let sum = 0;
    while n > 0 {
        sum += n % b;
        n /= b;
    }
    return sum;
}

fn main() {
    let a: (int, int)[4] = [(1, 10), (1234, 10), (0xfe, 16), (0xf0e, 16)];
    for i in 0..a.len {
        let (n, b) = a[i];
        println "{digits_sum(n, b)}";
    }
}
