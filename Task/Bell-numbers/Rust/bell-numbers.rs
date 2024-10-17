use num::BigUint;

fn main() {
    let bt = bell_triangle(51);
    // the fifteen first
    for i in 1..=15 {
        println!("{}: {}", i, bt[i][0]);
    }

    // the fiftieth
    println!("50: {}", bt[50][0])
}

fn bell_triangle(n: usize) -> Vec<Vec<BigUint>> {
    let mut tri: Vec<Vec<BigUint>> = Vec::with_capacity(n);
    for i in 0..n {
        let v = vec![BigUint::from(0u32); i];
        tri.push(v);
    }
    tri[1][0] = BigUint::from(1u32);

    for i in 2..n {
        tri[i][0] = BigUint::from_bytes_be(&tri[i - 1][i - 2].to_bytes_be());
        for j in 1..i {
            let added_big_uint = &tri[i][j - 1] + &tri[i - 1][j - 1];
            tri[i][j] = BigUint::from_bytes_be(&added_big_uint.to_bytes_be());
        }
    }

    tri
}
