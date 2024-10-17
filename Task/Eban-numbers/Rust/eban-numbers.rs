use std::ops::{Div, Rem};
use std::println;

fn iseban(n: i64) -> bool {
    let b = n.div(1_000_000_000);
    let mut r = n.rem(1_000_000_000);
    let m = r.div(1_000_000);
    r = r.rem(1_000_000);
    let t = r.div(1000);
    r = r.rem(1000);
    let mut arr: Vec<_> = [m, t, r]
        .iter()
        .map(|x| {
            if &30 <= x && x <= &66 {
                (*x).rem(10)
            } else {
                *x
            }
        })
        .collect();
    arr.push(b);
    return arr.iter().all(|x| [0, 2, 4, 6].contains(x));
}

fn main() {
    println!("Eban numbers up to and including 1000:");
    println!(
        "{}",
        (1..=1_00_i64)
            .filter(|x| iseban(*x))
            .map(|x| x.to_string())
            .collect::<Vec<_>>()
            .join(", ")
    );
    println!("Eban numbers between 1000 and 4000 (inclusive):");
    println!(
        "{}",
        (1000..=4_000_i64)
            .filter(|x| iseban(*x))
            .map(|x| x.to_string())
            .collect::<Vec<_>>()
            .join(", ")
    );
    println!(
        "Eban numbers up to and including 10_000: {}",
        (1..=10000).map(|x| iseban(x) as i32).sum::<i32>()
    );
    println!(
        "Eban numbers up to and including 100_000: {}",
        (1..=100000).map(|x| iseban(x) as i32).sum::<i32>()
    );
    println!(
        "Eban numbers up to and including 1_000_000: {}",
        (1..=1000000).map(|x| iseban(x) as i32).sum::<i32>()
    );
    println!(
        "Eban numbers up to and including 10_000_000: {}",
        (1..=10000000).map(|x| iseban(x) as i32).sum::<i32>()
    );
    println!(
        "Eban numbers up to and including 100_000_000: {}",
        (1..=100000000).map(|x| iseban(x) as i32).sum::<i32>()
    );
    println!(
        "Eban numbers up to and including 1_000_000_000: {}",
        (1..=1000000000).map(|x| iseban(x) as i32).sum::<i32>()
    );
}
