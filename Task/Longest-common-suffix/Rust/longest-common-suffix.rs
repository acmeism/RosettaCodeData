fn longestcommonsuffix(strings: &[&str]) -> String {
    let mut n = 0;
    let nmax = strings.iter().map(|x| x.len()).min().unwrap();
    if nmax == 0 {
        return String::from("");
    }
    'a: while n <= nmax {
        for s in strings {
            if s.len() < n + 1 {
                break 'a;
            }
            let ch1 = &s[s.len() - 1 - n..=s.len() - 1 - n];
            let s2 = strings[strings.len() - 1];
            if ch1 != &s2[s2.len() - 1 - n..=s2.len() - 1 - n] {
                break 'a;
            }
        }
        n += 1;
    }
    return strings[0][strings[0].len() - n..].to_string();
}

fn main() {
    let tests = [["baabababc", "baabc", "bbbabc"].to_vec(),
     ["baabababc", "baabc", "bbbazc"].to_vec(),
    ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"].to_vec(),
    ["longest", "common", "suffix"].to_vec(),
    ["suffix"].to_vec(),
    [""].to_vec()];
    for t in tests {
        println!("The longest common suffix of {:?} is \"{}\".", t, longestcommonsuffix(&t.to_vec()));
    }
}
