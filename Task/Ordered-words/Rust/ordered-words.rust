const FILE: &'static str = include_str!("./unixdict.txt");

fn is_ordered(s: &str) -> bool {
    let mut prev = '\x00';
    for c in s.to_lowercase().chars() {
        if c < prev {
            return false;
        }
        prev = c;
    }

    return true;
}

fn find_longest_ordered_words(dict: Vec<&str>) -> Vec<&str> {
    let mut result = Vec::new();
    let mut longest_length = 0;

    for s in dict.into_iter() {
        if is_ordered(&s) {
            let n = s.len();
            if n > longest_length {
                longest_length = n;
                result.truncate(0);
            }
            if n == longest_length {
                result.push(s);
            }
        }
    }

    return result;
}

fn main() {
    let lines = FILE.lines().collect();

    let longest_ordered = find_longest_ordered_words(lines);

    for s in longest_ordered.iter() {
        println!("{}", s.to_string());
    }
}
