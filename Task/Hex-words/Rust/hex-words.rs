use std::collections::HashSet;
use std::fs::File;
use std::io::{BufRead, BufReader};

struct Item {
    word: String,
    number: i32,
    digital_root: i32,
}

fn display(items: &Vec<Item>) {
    println!("  Word      Decimal value   Digital root");
    println!("----------------------------------------");
    for item in items {
        println!("{:>7} {:>15} {:>12}", item.word, item.number, item.digital_root);
    }
    println!("\nTotal count: {}\n", items.len());
}

fn digital_root(mut number: i32) -> i32 {
    let mut result = 0;
    while number > 0 {
        result += number % 10;
        number /= 10;
    }
    if result <= 9 {
        result
    } else {
        digital_root(result)
    }
}

fn contains_only(word: &str, acceptable: &HashSet<char>) -> bool {
    word.chars().all(|ch| acceptable.contains(&ch))
}

fn main() -> std::io::Result<()> {
    let hex_digits: HashSet<char> = ['a', 'b', 'c', 'd', 'e', 'f'].iter().cloned().collect();
    let mut items = Vec::new();

    let file = File::open("unixdict.txt")?;
    let reader = BufReader::new(file);

    for line in reader.lines() {
        if let Ok(word) = line {
            if word.len() >= 4 && contains_only(&word, &hex_digits) {
                let value = i32::from_str_radix(&word, 16).unwrap();
                let root = digital_root(value);
                items.push(Item {
                    word,
                    number: value,
                    digital_root: root,
                });
            }
        }
    }

    items.sort_by(|a, b| {
        if a.digital_root == b.digital_root {
            a.word.cmp(&b.word)
        } else {
            a.digital_root.cmp(&b.digital_root)
        }
    });
    display(&items);

    let mut filtered_items = Vec::new();
    for item in &items {
        let unique_chars: HashSet<char> = item.word.chars().collect();
        if unique_chars.len() >= 4 {
            filtered_items.push(Item {
                word: item.word.clone(),
                number: item.number,
                digital_root: item.digital_root,
            });
        }
    }

    filtered_items.sort_by(|a, b| b.number.cmp(&a.number));
    display(&filtered_items);

    Ok(())
}
