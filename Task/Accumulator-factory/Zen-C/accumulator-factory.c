fn accumulator<T>(acc: T) -> fn(T) -> T {
    return fn(f: T) -> T {
        acc += f;
        return acc;
    }
}

fn main() {
    // Example with f64s.
    let x = accumulator(1.0);
    x(5.0);
    accumulator(3.0);
    println "{x(2.3):g}";

    // Example with ints.
    let y = accumulator(1);
    y(5);
    accumulator(3);
    println "{y(2)}";
}
