// [dependencies]
// primal = "0.3"

fn digits(mut n: u32, dig: &mut [u32]) {
    for i in 0..dig.len() {
        dig[i] = n % 10;
        n /= 10;
    }
}

fn evalpoly(x: u64, p: &[u32]) -> u64 {
    let mut result = 0;
    for y in p.iter().rev() {
        result *= x;
        result += *y as u64;
    }
    result
}

fn max_prime_bases(ndig: u32, maxbase: u32) {
    let mut maxlen = 0;
    let mut maxprimebases = Vec::new();
    let limit = 10u32.pow(ndig);
    let mut dig = vec![0; ndig as usize];
    for n in limit / 10..limit {
        digits(n, &mut dig);
        let bases: Vec<u32> = (2..=maxbase)
            .filter(|&x| dig.iter().all(|&y| y < x) && primal::is_prime(evalpoly(x as u64, &dig)))
            .collect();
        if bases.len() > maxlen {
            maxlen = bases.len();
            maxprimebases.clear();
        }
        if bases.len() == maxlen {
            maxprimebases.push((n, bases));
        }
    }
    println!(
        "{} character numeric strings that are prime in maximum bases: {}",
        ndig, maxlen
    );
    for (n, bases) in maxprimebases {
        println!("{} => {:?}", n, bases);
    }
    println!();
}

fn main() {
    for n in 1..=6 {
        max_prime_bases(n, 36);
    }
}
