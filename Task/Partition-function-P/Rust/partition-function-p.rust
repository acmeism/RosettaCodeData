// [dependencies]
// rug = "1.11"

use rug::Integer;

fn partitions(n: usize) -> Integer {
    let mut p = Vec::with_capacity(n + 1);
    p.push(Integer::from(1));
    for i in 1..=n {
        let mut num = Integer::from(0);
        let mut k = 1;
        loop {
            let mut j = (k * (3 * k - 1)) / 2;
            if j > i {
                break;
            }
            if (k & 1) == 1 {
                num += &p[i - j];
            } else {
                num -= &p[i - j];
            }
            j += k;
            if j > i {
                break;
            }
            if (k & 1) == 1 {
                num += &p[i - j];
            } else {
                num -= &p[i - j];
            }
            k += 1;
        }
        p.push(num);
    }
    p[n].clone()
}

fn main() {
    use std::time::Instant;
    let n = 6666;
    let now = Instant::now();
    let result = partitions(n);
    let time = now.elapsed();
    println!("P({}) = {}", n, result);
    println!("elapsed time: {} microseconds", time.as_micros());
}
