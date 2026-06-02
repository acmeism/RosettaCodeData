// The procedure accepts a raw C-style function pointer
fn times_fp(proc: fn*(), n: uint) {
    for _ in 0..n {
        proc();
    }
}

// A standard named function
fn say_hello() {
    println "Hello from function pointer!";
}

fn main() {
    times_fp(say_hello, 2);
}
