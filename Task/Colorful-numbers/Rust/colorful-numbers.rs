use core::cmp::max;
use std::collections::HashSet;

fn to_digits(mut n: u64, base: u64) -> Vec<u64> {
    if n == 0 {
        return [0].to_vec();
    }
    let mut v: Vec<u64> = Vec::new();
    while n > 0 {
        let d = n % base;
        n /= base;
        v.push(d);
    }
    return v;
}

fn is_colorful(n: u64) -> bool {
    if &n > &9 {
        let dig: Vec<u64> = to_digits(n, 10);
        if dig.contains(&1) || dig.contains(&0) {
            return false;
        }
        let mut products: HashSet<u64> = HashSet::new();
        for i in 0..dig.len() {
            if products.contains(&dig[i]) {
                return false;
            }
            products.insert(dig[i]);
        }
        for i in 0..dig.len() {
            for j in i+2..dig.len()+1 {
                let p: u64 = (dig[i..j]).iter().product();
                if products.contains(&p) {
                    return false;
                }
                products.insert(p);
            }
        }
    }
    return true;
}

fn main() {
    println!("Colorful numbers for 1:25, 26:50, 51:75, and 76:100:");
    for i in (1..101).step_by(25) {
        for j in 0..25 {
            if is_colorful(i + j) {
                print!("{:5}", i + j);
            }
        }
        println!();
    }
    println!();

    let mut csum: u64 = 0;
    let mut largest: u64 = 0;
    let mut n: u64;
    for i in 0..8 {
        let j: u64 = { if i == 0 { 0 } else { 10_u64.pow(i) } };
        let k: u64 = 10_u64.pow(i + 1) - 1;
        n = 0;
        for x in j..k+1 {
            if is_colorful(x) {
                largest = max(largest, x);
                n += 1;
            }
        }
        println!("The count of colorful numbers within the interval [{j}, {k}] is {n}.");
        csum += n;
    }
    println!("The largest possible colorful number is {largest}.");
    println!("The total number of colorful numbers is {csum}.")
}
