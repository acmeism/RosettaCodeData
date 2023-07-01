extern crate num;

use std::cmp;
use num::bigint::BigUint;

fn cumu(n: usize, cache: &mut Vec<Vec<BigUint>>) {
    for l in cache.len()..n+1 {
        let mut r = vec![BigUint::from(0u32)];
        for x in 1..l+1 {
            let prev = r[r.len() - 1].clone();
            r.push(prev + cache[l-x][cmp::min(x, l-x)].clone());
        }
        cache.push(r);
    }
}

fn row(n: usize, cache: &mut Vec<Vec<BigUint>>) -> Vec<BigUint> {
    cumu(n, cache);
    let r = &cache[n];
    let mut v: Vec<BigUint> = Vec::new();

    for i in 0..n {
        v.push(&r[i+1] - &r[i]);
    }
    v
}

fn main() {
    let mut cache = vec![vec![BigUint::from(1u32)]];

    println!("rows:");
    for x in 1..26 {
        let v: Vec<String> = row(x, &mut cache).iter().map(|e| e.to_string()).collect();
        let s: String = v.join(" ");
        println!("{}: {}", x, s);
    }

    println!("sums:");
    for x in vec![23, 123, 1234, 12345] {
        cumu(x, &mut cache);
        let v = &cache[x];
        let s = v[v.len() - 1].to_string();
        println!("{}: {}", x, s);
    }
}
