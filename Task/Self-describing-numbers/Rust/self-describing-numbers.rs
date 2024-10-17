fn is_self_desc(xx: u64) -> bool
{
    let s: String = xx.to_string();
    let mut count_vec = vec![0; 10];
    for c in s.chars() {
        count_vec[c.to_digit(10).unwrap() as usize] += 1;
    }
    for (i, c) in s.chars().enumerate() {
        if count_vec[i] != c.to_digit(10).unwrap() as usize {
            return false;
        }
    }
    return true;
}

fn main() {
    for i in 1..100000000 {
        if is_self_desc(i) {
            println!("{}", i)
        }
    }
}
