alias fi = fn(int) -> int;

fn add_n(n: int) -> fi {
    return fn(x: int) -> int { return n + x; }
}

fn main() {
    let adder = add_n(40);
    println "The answer to life is {adder(2)}.";
}
