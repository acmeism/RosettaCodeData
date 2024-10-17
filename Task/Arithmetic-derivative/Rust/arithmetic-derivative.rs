use prime_factorization::Factorization;

fn d(n: i128) -> i128 {
    if n < 0 {
        return -(d(-n));
    } else if n < 2 {
        return 0;
    } else {
        let fpairs = Factorization::run(n as u128).prime_factor_repr();
        if fpairs.len() == 1 && fpairs[0].1 == 1 {
            return 1;
        }
        return fpairs.iter().fold(0_i128, |p, q| p + n * (q.1 as i128) / (q.0 as i128));
    }
}

fn main() {
    for n in -99..101 {
        print!("{:5}{}", d(n), { if n % 10 == 0 { "\n" } else {""} });
    }
    println!();
    for m in 1..21 {
        println!("(D for 10 ^ {}) divided by 7 is {}", m, d(10_i128.pow(m)) / 7)
    }
}
