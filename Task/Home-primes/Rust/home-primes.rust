use std::str::FromStr;
use num_bigint::BigUint;
use num_prime::nt_funcs::{is_prime, factorize};

fn homechains(n: &BigUint) -> Vec<BigUint> {
    let mut links = vec![BigUint::from_str("0").unwrap(); 0].to_vec();
    if is_prime(n, None).probably() {
        links.push(n.clone());
        return links;
    }
    let mut s = String::from_str("").unwrap();
    let d = factorize(n.clone());
    for (p, e) in d {
        let s2 = format!("{p}");
        for _ in 0..e {
            s.push_str(&s2);
        }
    }
    let k = BigUint::from_str(&s).unwrap();
    links.push(k.clone());
    links.append(&mut homechains(&k));
    return links;
}

fn home_chains_print(num: u64, chains: &mut Vec<BigUint>) {
    let mut clen = chains.len();
    if clen == 1 {
        println!("HP{num} ─► {num}");
    } else {
        if chains[clen - 1] == chains[clen - 2] {
            chains.pop();
            clen -= 1;
        }
        print!("HP{num}({clen}) ─► ");
        for (i, k) in chains.iter().enumerate() {
            if clen - i > 1 {
                print!("HP{k}({}) ─► ", clen - i - 1);
                if (i + 1) % 5 == 0 {
                    println!();
                }
            } else {
                println!("{k}");
            }
        }
    }
}


fn main() {
    for num in 2_u64..21 {
        let m = BigUint::from_str(&format!("{num}")).unwrap();
        let mut chains = homechains(&m);
        home_chains_print(num, &mut chains);
    }
    let mut chains = homechains(&BigUint::from_str("65").unwrap());
    home_chains_print(65_u64, &mut chains);
}
