use std::env;
use std::fs;

use std::collections::HashMap;

extern crate rand;
use rand::{seq::index::sample, thread_rng};

fn read_data(filename: &str) -> String {
    fs::read_to_string(filename).expect("Something went wrong reading the file")
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = &args[1];
    let key_size = args[2].parse::<usize>().expect("Invalid key_size!");
    let output_size = args[3].parse::<usize>().expect("Invalid output_size!");

    let data = read_data(filename);
    let rule = make_rule(&data, key_size);
    let result = make_string(&rule.unwrap(), output_size);
    println!("{}", result);
}

fn make_rule(content: &str, key_size: usize) -> Result<HashMap<String, Vec<String>>, &'static str> {
    if key_size < 1 {
        eprintln!();
        return Err("key_size may not be less than 1!");
    }
    let words: Vec<&str> = content.split(' ').collect();

    let mut dict: HashMap<String, Vec<String>> = HashMap::new();

    for i in 0..words.len() - key_size {
        let mut key = words[i].to_string();
        for word in words.iter().take(i + key_size).skip(i + 1) {
            key.push_str(" ");
            key.push_str(word);
        }
        let value = words[i + key_size];
        match dict.get_mut(&key) {
            Some(e) => {
                e.push(value.to_string());
            }
            None => {
                dict.insert(key, vec![value.to_string()]);
            }
        }
    }
    Ok(dict)
}

fn make_string(rule: &HashMap<String, Vec<String>>, length: usize) -> String {
    let keys: Vec<&String> = rule.keys().collect();
    let random_key = keys[get_random_index(keys.len())];
    let mut words = random_key.split(' ').collect::<Vec<&str>>();
    let mut buffer = words.clone().join(" ");
    buffer.push_str(" ");
    for _i in 0..length {
        let key = words.join(" ");
        let entry = match rule.get(&key) {
            None => continue,
            Some(e) => e,
        };
        let new = &entry[get_random_index(entry.len())];
        buffer.push_str(new);
        buffer.push_str(" ");
        let len = words.len();
        for j in 0..len - 1 {
            words[j] = words[j + 1];
        }
        words[len - 1] = new;
    }
    buffer
}

fn get_random_index(max: usize) -> usize {
    let mut rng = thread_rng();
    sample(&mut rng, max, 1).into_vec()[0]
}
