use std::cmp::Ordering;
use std::io::BufRead;

/// Compares the length of two strings by iterating over their characters
/// together until either string has run out.
fn compare(a: &str, b: &str) -> Ordering {
    let mut a = a.chars();
    let mut b = b.chars();
    loop {
        match (a.next(), b.next()) {
            (None, None) => return Ordering::Equal,
            (Some(_), None) => return Ordering::Greater,
            (None, Some(_)) => return Ordering::Less,
            (Some(_), Some(_)) => {}
        }
    }
}

/// Returns the longest lines of the input, separated by newlines.
fn longest<I: IntoIterator<Item = String>>(input: I) -> String {
    let mut longest = String::new();
    let mut output = String::new();

    for line in input {
        match compare(&line, &longest) {
            // A longer string replaces the output and longest.
            Ordering::Greater => {
                output.clear();
                output.push_str(&line);
                longest = line;
            }
            // A string of the same length is appended to the output.
            Ordering::Equal => {
                output.push('\n');
                output.push_str(&line);
            }
            // A shorter string is ignored.
            Ordering::Less => {}
        }
    }

    output
}

fn main() {
    let stdin = std::io::stdin();
    let lines = stdin.lock().lines().map(|l| l.expect("Failed to read."));

    println!("{}", longest(lines))
}
