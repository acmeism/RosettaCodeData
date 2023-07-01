use std::fs::File;
use std::io::{self, BufRead};

fn load_dictionary(filename: &str) -> std::io::Result<Vec<String>> {
    let file = File::open(filename)?;
    let mut dict = Vec::new();
    for line in io::BufReader::new(file).lines() {
        dict.push(line?);
    }
    Ok(dict)
}

fn jaro_winkler_distance(string1: &str, string2: &str) -> f64 {
    let mut st1 = string1;
    let mut st2 = string2;
    let mut len1 = st1.chars().count();
    let mut len2 = st2.chars().count();
    if len1 < len2 {
        std::mem::swap(&mut st1, &mut st2);
        std::mem::swap(&mut len1, &mut len2);
    }
    if len2 == 0 {
        return if len1 == 0 { 0.0 } else { 1.0 };
    }
    let delta = std::cmp::max(1, len1 / 2) - 1;
    let mut flag = vec![false; len2];
    let mut ch1_match = vec![];
    for (idx1, ch1) in st1.chars().enumerate() {
        for (idx2, ch2) in st2.chars().enumerate() {
            if idx2 <= idx1 + delta && idx2 + delta >= idx1 && ch1 == ch2 && !flag[idx2] {
                flag[idx2] = true;
                ch1_match.push(ch1);
                break;
            }
        }
    }
    let matches = ch1_match.len();
    if matches == 0 {
        return 1.0;
    }
    let mut transpositions = 0;
    let mut idx1 = 0;
    for (idx2, ch2) in st2.chars().enumerate() {
        if flag[idx2] {
            transpositions += (ch2 != ch1_match[idx1]) as i32;
            idx1 += 1;
        }
    }
    let m = matches as f64;
    let jaro =
        (m / (len1 as f64) + m / (len2 as f64) + (m - (transpositions as f64) / 2.0) / m) / 3.0;
    let mut commonprefix = 0;
    for (c1, c2) in st1.chars().zip(st2.chars()).take(std::cmp::min(4, len2)) {
        commonprefix += (c1 == c2) as i32;
    }
    1.0 - (jaro + commonprefix as f64 * 0.1 * (1.0 - jaro))
}

fn within_distance<'a>(
    dict: &'a Vec<String>,
    max_distance: f64,
    stri: &str,
    max_to_return: usize,
) -> Vec<(&'a String, f64)> {
    let mut arr: Vec<(&String, f64)> = dict
        .iter()
        .map(|w| (w, jaro_winkler_distance(stri, w)))
        .filter(|x| x.1 <= max_distance)
        .collect();
    // The trait std::cmp::Ord is not implemented for f64, otherwise
    // we could just do this:
    // arr.sort_by_key(|x| x.1);
    let compare_distance = |d1, d2| {
        use std::cmp::Ordering;
        if d1 < d2 {
            Ordering::Less
        } else if d1 > d2 {
            Ordering::Greater
        } else {
            Ordering::Equal
        }
    };
    arr.sort_by(|x, y| compare_distance(x.1, y.1));
    arr[0..std::cmp::min(max_to_return, arr.len())].to_vec()
}

fn main() {
    match load_dictionary("linuxwords.txt") {
        Ok(dict) => {
            for word in &[
                "accomodate",
                "definately",
                "goverment",
                "occured",
                "publically",
                "recieve",
                "seperate",
                "untill",
                "wich",
            ] {
                println!("Close dictionary words (distance < 0.15 using Jaro-Winkler distance) to '{}' are:", word);
                println!("        Word   |  Distance");
                for (w, dist) in within_distance(&dict, 0.15, word, 5) {
                    println!("{:>14} | {:6.4}", w, dist)
                }
                println!();
            }
        }
        Err(error) => eprintln!("{}", error),
    }
}
