fn e(k: i32, n: i32) -> Vec<u8> {
    let mut s: Vec<Vec<u8>> = (0..n)
        .map(|i| if i < k { vec![1] } else { vec![0] })
        .collect();

    let mut d = n - k;
    let mut n = std::cmp::max(k, d);
    let mut k = std::cmp::min(k, d);
    let mut z = d;

    while z > 0 || k > 1 {
        for i in 0..(k as usize) {
            let mut extension = s[s.len() - 1 - i].clone();
            s[i].append(&mut extension);
        }
        s.truncate(s.len() - (k as usize));
        z -= k;
        d = n - k;
        n = std::cmp::max(k, d);
        k = std::cmp::min(k, d);
    }

    s.into_iter().flatten().collect()
}

fn main() {
    let result = e(5, 13);
    let result_string: String = result.into_iter().map(|digit| digit.to_string()).collect();
    println!("{}", result_string);
}
