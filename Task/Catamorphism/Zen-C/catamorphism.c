alias binary_op_fn = fn*(int, int) -> int;

fn reduce(f: binary_op_fn, a: int*, len: const usize) -> int {
    let acc = a[0];
    for i in 1..len {
        acc = f(acc, a[i]);
    }
    return acc;
}

fn add(x: int, y: int) -> int { return x + y; }
fn sub(x: int, y: int) -> int { return x - y; }
fn mul(x: int, y: int) -> int { return x * y; }

fn main() {
    let a = [1, 2, 3, 4, 5];
    println "{reduce(add, a, a.len)}";
    println "{reduce(sub, a, a.len)}";
    println "{reduce(mul, a, a.len)}";
}
