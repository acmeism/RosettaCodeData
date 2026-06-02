import "std/time.zc" // uses system time

fn func() {
    for i in 0..10_000_000 {}
}

fn main() {
    let iterations = 100;
    let start = Time::now();
    for i in 0..iterations { func(); }
    let end = Time::now();
    println "Calling 'func' {iterations} times took {end - start} ms.";
}
