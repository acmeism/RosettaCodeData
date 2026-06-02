import "std/sort.zc"

fn median(a: f64*, len: const usize) -> f64 {
    // Avoid mutating 'a' by copying it to a new buffer 'b'.
    let bytes = len * sizeof(f64);
    autofree let b = (f64*)malloc(bytes);
    memcpy(b, a, bytes);
    sort_double(b, len);
    let hl = len / 2;
    let med = len % 2 ? b[hl] : (b[hl - 1] + b[hl]) / 2.0;
    return med;
}

fn main() {
    let a1 = [4.1, 5.6, 7.2, 1.7, 9.3, 4.4, 3.2];
    let a2 = [4.1, 7.2, 1.7, 9.3, 4.4, 3.2];
    let as: f64*[2] = [a1, a2];
    let lens = [7, 6];
    for i in 0..2 { println "{median(as[i], lens[i]):g}" };
}
