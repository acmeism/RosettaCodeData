use gcd::Gcd;

fn ekg_sequence(n: u64, limit: usize) -> Vec<u64> {
    let mut ekg = [1_u64, n].to_vec();
    while ekg.len() < limit {
        for i in 2..2<<18 {
            if ekg.iter().all(|j| *j != i) && Gcd::gcd(ekg[ekg.len()-1], i) > 1 {
                ekg.push(i);
                break;
            }
        }
    }
    return ekg;
}


fn converge_at(n: u64, m: u64, tmax: usize) -> usize {
    let a = ekg_sequence(n, tmax);
    let b = ekg_sequence(m, tmax);
    for i in 2..tmax {
        if a[i] == b[i] && a[0..i+1].iter().sum::<u64>() == (b[0..i+1]).iter().sum::<u64>() {
            return i + 1;
        }
    }
    println!("Error: no convergence in {tmax} terms");
    return 0;
}

fn main() {
    for i in [2_u64, 5, 7, 9, 10] {
        println!("EKG({i:2}): {:?}", ekg_sequence(i, 30_usize));
    }
    println!("EKGs of 5 & 7 converge after term {:?}", converge_at(5, 7, 50));
}
