fn chen_fox_lyndon_factorization(s: &str) -> Vec<String> {
    let n = s.len();
    let mut i = 0;
    let mut factorization = Vec::new();
    while i < n {
        let (mut j, mut k) = (i + 1, i);
        while j < n && s.as_bytes()[k] <= s.as_bytes()[j] {
            if s.as_bytes()[k] < s.as_bytes()[j] {
                k = i;
            } else {
                k += 1;
            }
            j += 1;
        }
        while i <= k {
            factorization.push(s[i..i + j - k].to_string());
            i += j - k;
        }
    }
    factorization
}

fn main() {
    let mut m = String::from("0");
    for _ in 0..7 {
        let m0 = m.clone();
        m = m.replace("0", "a");
        m = m.replace("1", "0");
        m = m.replace("a", "1");
        m = m0 + &m;
    }

    let factorization = chen_fox_lyndon_factorization(&m);
    println!("{:?}", factorization);
}
