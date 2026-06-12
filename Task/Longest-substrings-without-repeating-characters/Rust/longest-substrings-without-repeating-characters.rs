use itertools::Itertools;
use std::fs;

fn nonrepeating(s: &str) -> Vec<String> {
    let mut max_subs: Vec<String> = vec![];
    let mut mx = 0_usize;
    for i in 0..s.len() {
        for j in i+1..=s.len() {
            let sub = &s[i..j];
            let subbytes = sub.chars().sorted().dedup();
            if j - i >= mx && sub.len() == subbytes.collect_vec().len() {
                if j - i == mx && !max_subs.contains(&sub.to_string()) {
                    max_subs.push(sub.to_string());
                } else {
                    max_subs = vec![sub.to_string()];
                    mx = j - i;
                }
            }
        }
    }
    return max_subs;
}

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let results = wordsfile
        .split_whitespace().map(|w| format!("{} ==> {:?}", w, nonrepeating(w)));
    for s in results {
        println!("{}", s);
    }
}
