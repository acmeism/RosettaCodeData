use std::collections::HashMap;

fn find_ngrams(n: usize, s: &str) -> HashMap<String, i32> {
    let mut ngrams = HashMap::new();
    let chars: Vec<char> = s.chars().collect();

    if chars.len() < n {
        return ngrams;
    }

    let max_loc = chars.len() - n;
    for i in 0..=max_loc {
        let ngram: String = chars[i..i + n].iter().collect();
        *ngrams.entry(ngram).or_insert(0) += 1;
    }

    ngrams
}

fn print_ngrams(ngrams: &HashMap<String, i32>) {
    let mut col = 0;
    for (ngram, count) in ngrams {
        print!("'{}' - {}", ngram, count);
        if col % 5 == 4 {
            println!();
        } else {
            print!("\t");
        }
        col += 1;
    }
    println!();
}

fn main() {
    let s = "LIVE AND LET LIVE";

    for n in 2..=4 {
        println!("{}-grams of '{}':", n, s);
        print_ngrams(&find_ngrams(n, s));
    }
}
