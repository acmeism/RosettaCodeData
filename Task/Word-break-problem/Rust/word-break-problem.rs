use std::collections::HashSet;
fn create_string(s: &str, v: Vec<Option<usize>>) -> String {
    let mut idx = s.len();
    let mut slice_vec = vec![];
    while let Some(prev) = v[idx] {
        slice_vec.push(&s[prev..idx]);
        idx = prev;
    }
    slice_vec.reverse();
    slice_vec.join(" ")


}

fn word_break(s: &str, dict: HashSet<&str>) -> Option<String> {
    let size = s.len() + 1;
    let mut possible = vec![None; size];

    let check_word = |i,j| dict.get(&s[i..j]).map(|_| i);

    for i in 1..size {
        possible[i] = possible[i].or_else(|| check_word(0,i));

        if possible[i].is_some() {
            for j in i+1..size {
                possible[j] = possible[j].or_else(|| check_word(i,j));
            }

            if possible[s.len()].is_some() {
                return Some(create_string(s, possible));
            }

        };
    }
    None
}

fn main() {
    let mut set = HashSet::new();
    set.insert("a");
    set.insert("bc");
    set.insert("abc");
    set.insert("cd");
    set.insert("b");
    println!("{:?}", word_break("abcd", set).unwrap());
}
