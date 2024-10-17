#![feature(core)]

fn sumsqd(mut n: i32) -> i32 {
    let mut sq = 0;
    while n > 0 {
        let d = n % 10;
        sq += d*d;
        n /= 10
    }
    sq
}

use std::num::Int;
fn cycle<T: Int>(a: T, f: fn(T) -> T) -> T {
    let mut t = a;
    let mut h = f(a);

    while t != h {
        t = f(t);
        h = f(f(h))
    }
    t
}

fn ishappy(n: i32) -> bool {
    cycle(n, sumsqd) == 1
}

fn main() {
    let happy = std::iter::count(1, 1)
                    .filter(|&n| ishappy(n))
                    .take(8)
                    .collect::<Vec<i32>>();

    println!("{:?}", happy)
}
