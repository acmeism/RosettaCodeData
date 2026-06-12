use std::collections::HashMap;

fn lindenmayer(mut s: String, rules: &HashMap<char, String>, count: usize) {
    for _ in 0..count {
        println!("{}", s);
        let mut nxt = String::new();
        for c in s.chars() {
            if let Some(rule) = rules.get(&c) {
                nxt.push_str(rule);
            } else {
                nxt.push(c);
            }
        }
        s = nxt;
    }
}

fn main() {
    let mut rules = HashMap::new();
    rules.insert('I', "M".to_string());
    rules.insert('M', "MI".to_string());

    lindenmayer("I".to_string(), &rules, 5);
}
