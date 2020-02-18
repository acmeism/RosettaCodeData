fn aks_coefficients(k: usize) -> Vec<i64> {
    let mut coefficients = vec![0i64; k + 1];
    coefficients[0] = 1;
    for i in 1..(k + 1) {
        coefficients[i] = -(1..i).fold(coefficients[0], |prev, j|{
            let old = coefficients[j];
            coefficients[j] = old - prev;
            old
        });
    }
    coefficients
}

fn is_prime(p: usize) -> bool {
    if p < 2 {
        false
    } else {
        let c = aks_coefficients(p);
        (1..p / 2 + 1).all(|i| c[i] % p as i64 == 0)
    }
}

fn main() {
    for i in 0..8 {
        println!("{}: {:?}", i, aks_coefficients(i));
    }
    for i in (1..=50).filter(|&i| is_prime(i)) {
        print!("{} ", i);
    }
}
