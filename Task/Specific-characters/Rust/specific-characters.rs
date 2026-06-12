use std::collections::{HashMap, HashSet};

// Find characters that appear exactly twice in a string.
fn count_two_and_unique(s: &str) -> Vec<char> {
    let mut counts = HashMap::new();
    for c in s.chars() {
        *counts.entry(c).or_insert(0) += 1;
    }
    counts.into_iter()
          .filter(|&(_, count)| count == 2)
          .map(|(c, _)| c)
          .collect()
}

// Count characters unique to a specific string in the array,
// where those characters appear exactly twice in that string.
fn specific_counts(arr: &[&str]) -> Vec<usize> {
    let mut ret: Vec<usize> = vec![0; arr.len()];
    for (i, &w) in arr.iter().enumerate() {
        for c in count_two_and_unique(w) {
            let mut found_in_other = false;
            for (j, &w2) in arr.iter().enumerate() {
                if i != j && w2.contains(c) {
                    found_in_other = true;
                    break;
                }
            }
            if !found_in_other {
                ret[i] += 1;
            }
        }
    }
    ret
}

// Counts the number of unique characters that are NOT "specific" for each string.
fn nonspecific_counts(arr: &[&str]) -> Vec<usize> {
    arr.iter()
       .zip(specific_counts(arr))
       .map(|(&s, count_with)| {
           let unique_chars: HashSet<char> = s.chars().collect();
           unique_chars.len() - count_with
       })
       .collect()
}

fn main() {
    let a = ["ahwiueshaiu", "ajxxfioaaf", "ajrdsfroiwr"];
    println!("Specific char counts in the 3 words: {:?}", specific_counts(&a));
    println!("Nonspecific char counts in the 3 words: {:?}", nonspecific_counts(&a));
}
