use std::collections::HashSet;
use std::fs;

fn targeted_mutations(word: &str, targ: &str, hs: &HashSet<&str>) -> Vec<Vec<String>> {
    let mut working = [[word.to_string()].to_vec()].to_vec();
    let mut tried = HashSet::new();
    while working.iter().all(|a| a.last().unwrap() != &targ) {
        let mut new_working: Vec<Vec<String>> = vec![];
        for arr in working {
            let s = arr.last().unwrap();
            tried.insert(s.to_owned());
            for j in 0..s.len() {
                for c in 'a'..='z' {
                    let w = String::new() + &s[..j] + &c.to_string() + &s[j + 1..];
                    if hs.contains(w.as_str()) && !tried.contains(&w) {
                        let mut a = arr.iter().map(|st| st.to_string()).collect::<Vec<String>>();
                        a.push(w);
                        new_working.push(a);
                    }
                }
            }
        }
        if new_working.is_empty() {
            return [["This cannot be done.".to_string()].to_vec()].to_vec();
        }
        working = new_working;
    }
    return working
        .iter()
        .filter(|a| !a.is_empty() && a.last().unwrap() == targ)
        .map(|x| x.to_owned())
        .collect::<Vec<Vec<String>>>();
}

fn main() {
    let wordsfile = fs::read_to_string("unixdict.txt").unwrap().to_lowercase();
    let dict: HashSet<&str> = wordsfile.split_whitespace().into_iter().collect();
    println!("boy to man: {:?}", targeted_mutations("boy", "man", &dict));
    println!(
        "girl to lady: {:?}",
        targeted_mutations("girl", "lady", &dict)
    );
    println!(
        "john to jane: {:?}",
        targeted_mutations("john", "jane", &dict)
    );
    println!(
        "child to adult: {:?}",
        targeted_mutations("child", "adult", &dict)
    );
}
