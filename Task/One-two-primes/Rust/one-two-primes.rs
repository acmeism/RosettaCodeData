use itertools::chain;
use num_bigint::BigUint;
use num_prime::nt_funcs::is_prime;
use std::str::FromStr;

fn show_oeis36229(wanted: u32) {
    for ndig in chain!(1_u32..21, (100_u32..wanted + 1).step_by(100)) {
        let k = (BigUint::from(10_u32).pow(ndig) - 1_u32) / BigUint::from(9_u32);
        let i = BigUint::from(2_u32).pow(ndig) - 1_u32;
        let mut j = BigUint::from(0_u32);
        while j <= i {
            let candidate = k.clone() + BigUint::from_str(&format!("{j:b}").as_str()).unwrap();
            if is_prime(&candidate, None).probably() {
                let pstr = candidate.to_string();
                if ndig < 21 {
                    println!("{ndig:>4}: {pstr}");
                } else {
                    let n = pstr.find("2").unwrap_or(20);
                    println!("{ndig:>4}: (1 x {n}) {}", &pstr[n..]);
                }
                break;
            }
            j += 1_u32;
        }
    }
}

fn main() {
    show_oeis36229(2000);
}
