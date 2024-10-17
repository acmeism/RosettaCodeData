/**
 * Abbreviations from tintenalarm.de
 */
use std::fs::File;
use std::io;
use std::io::{BufRead, BufReader};

fn main() {
    let table = read_days("weekdays.txt").expect("Error in Function read_days:");
    for line in table {
        if line.len() == 0 {
            continue;
        };
        let mut max_same = 0;
        for i in 0..(line.len() - 1) {
            for j in i + 1..line.len() {
                max_same = max_same.max(begins_with_num_same_chars(&line[i], &line[j]));
            }
        }
        println!("{}\t{:?}", max_same + 1, line);
    }
}

fn read_days(filename: &str) -> io::Result<Vec<Vec<String>>> {
    let f = File::open(filename)?;
    let reader = BufReader::new(f);
    let mut table: Vec<Vec<String>> = Vec::new();
    for line in reader.lines() {
        let mut days: Vec<String> = Vec::with_capacity(7);
        for day in line?.split_whitespace() {
            days.push(day.to_string());
        }
        table.push(days);
    }
    Ok(table)
}

fn begins_with_num_same_chars(str_a: &str, str_b: &str) -> u32 {
    let mut num = 0;
    for (pos, char_a) in str_a.chars().enumerate() {
        match str_b.chars().nth(pos) {
            Some(char_b) => {
                if char_a == char_b {
                    num = num + 1;
                } else {
                    return num;
                }
            }
            None => return num,
        }
    }
    num
}
