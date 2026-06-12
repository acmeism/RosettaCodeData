use itertools::Itertools;
use primal::is_prime;

fn prime_groups(words: &[&str], siz: usize) -> String {
    let mut results = String::new();
    for word in words {
        let mut found = String::from("Not found");
        let chars: Vec<char> = word.chars().collect();
        for combo in chars.into_iter().combinations(siz).unique() {
            if (0..siz).all(|i| {
                (i + 1..siz).all(|j| is_prime((combo[i] as i32 - combo[j] as i32).abs() as u64))
            }) {
                found = combo.into_iter().collect();
                break;
            }
        }

        results.push_str(&found);
        results.push('\n');
    }
    results
}

fn main() {
    let words = vec!["riOtjuoq", "wjtiOxtj", "akwercjoeiJ", "Weej", "Aek", "jjgja"];
    println!("Three character prime groups:\n{}", prime_groups(&words, 3));
    println!("Two character prime groups:\n{}", prime_groups(&words, 2));
}
