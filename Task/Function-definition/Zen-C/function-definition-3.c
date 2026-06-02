// Standard function with a default argument
fn increment(val: int, amount: int = 1) -> int {
    return val + amount;
}

// Inline function attribute hint
@inline
fn multiply(a: float, b: float) -> float {
    return a * b;
}

// Generic function
fn multiply_generic<T>(a: T, b: T) -> T {
    return a * b;
}

fn main() {
    // Default argument evaluated
    let res1 = increment(10);
    println "10 + default = {res1}";

    // Inline execution
    let res2 = multiply(5.0, 4.0);
    println "5.0 * 4.0 = {res2}";

    // Generic execution with f32 (float)
    let res3 = multiply_generic<f32>(2.5, 2.0);
    println "2.5 * 2.0 = {res3}";

    // Generic execution with int
    let res4 = multiply_generic<int>(10, 3);
    println "10 * 3 = {res4}";
}
