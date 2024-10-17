fn lex_sorted_vector(num: i32) -> Vec<i32> {
    let (min, max) = if num >= 1 { (1, num) } else { (num, 1) };
    let mut str: Vec<String> = (min..=max).map(|i| i.to_string()).collect();
    str.sort();
    str.iter().map(|s| s.parse::<i32>().unwrap()).collect()
}

fn main() {
    for n in &[0, 5, 13, 21, -22] {
        println!("{}: {:?}", n, lex_sorted_vector(*n));
    }
}
