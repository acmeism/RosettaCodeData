extern crate rug;
extern crate primal;

use rug::Integer;
use rug::ops::Pow;
use std::thread::spawn;

fn is_mersenne (p : usize) {
    let p = p as u32;
    let mut m = Integer::from(1);
    m = m << p;
    m = Integer::from(&m - 1);
    let mut flag1 = false;
    for k in 1..10_000 {
        let mut flag2 = false;
        let mut div : u32 = 2*k*p + 1;
        if &div >= &m {break; }
        for j in [3,5,7,11,13,17,19,23,29,31,37].iter() {
            if div % j == 0 {
                flag2 = true;
                break;
            }
        }
        if flag2 == true {continue;}
        if div % 8 != 1 && div % 8 != 7 { continue; }
        if m.is_divisible_u(div) {
            flag1 = true;
            break;
        }
    }
    if flag1 == true {return ()}
    let mut s = Integer::from(4);
    let two = Integer::from(2);
    for _i in 2..p {
		let mut sqr = s.pow(2);
		s = Integer::from(&Integer::from(&sqr & &m) + &Integer::from(&sqr >> p));
		if &s >= &m {s = s - &m}
		s = Integer::from(&s - &two);
    }
	if s == 0 {println!("Mersenne : {}",p);}
}

fn main () {
    println!("Mersenne : 2");
    let limit = 11_214;
    let mut thread_handles = vec![];
    for p in primal::Primes::all().take_while(|p| *p < limit) {
        thread_handles.push(spawn(move || is_mersenne(p)));
    }
    for handle in thread_handles {
        handle.join().unwrap();
    }
}
