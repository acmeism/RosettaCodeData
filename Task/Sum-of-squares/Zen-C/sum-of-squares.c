import "std/vec.zc"

fn sum_squares<T>(vec: Vec<T>*) -> T {
    let sum: T = (T)0;
    for v in *vec { sum += v * v; }
    return sum;
}

fn main() {
    let vec = Vec<int>::new();
    println "{sum_squares<int>(&vec)}";
    vec << 2;
    vec << 3;
    vec << 5;
    println "{sum_squares<int>(&vec)}";

    let vec2 = Vec<f64>::new();
    vec2 << 2.5;
    vec2 << 3.5;
    vec2 << 5.5;
    println "{sum_squares<f64>(&vec2):g}";
}
