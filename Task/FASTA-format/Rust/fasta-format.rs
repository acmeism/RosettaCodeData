use std::env;
use std::io::{BufReader, Lines};
use std::io::prelude::*;
use std::fs::File;

fn main() {
    let args: Vec<String> = env::args().collect();
    let f = File::open(&args[1]).unwrap();
    for line in FastaIter::new(f) {
        println!("{}", line);
    }
}

struct FastaIter<T> {
    buffer_lines: Lines<BufReader<T>>,
    current_name: Option<String>,
    current_sequence: String
}

impl<T: Read> FastaIter<T> {
    fn new(file: T) -> FastaIter<T> {
        FastaIter { buffer_lines: BufReader::new(file).lines(),
                    current_name: None,
                    current_sequence: String::new() }
    }
}

impl<T: Read> Iterator for FastaIter<T> {
    type Item = String;

    fn next(&mut self) -> Option<String> {
        while let Some(l) = self.buffer_lines.next() {
            let line = l.unwrap();
            if line.starts_with(">") {
                if self.current_name.is_some() {
                    let mut res = String::new();
                    res.push_str(self.current_name.as_ref().unwrap());
                    res.push_str(": ");
                    res.push_str(&self.current_sequence);
                    self.current_name = Some(String::from(&line[1..]));
                    self.current_sequence.clear();
                    return Some(res);
                } else {
                    self.current_name = Some(String::from(&line[1..]));
                    self.current_sequence.clear();
                }
                continue;
            }
            self.current_sequence.push_str(line.trim());
        }
        if self.current_name.is_some() {
            let mut res = String::new();
            res.push_str(self.current_name.as_ref().unwrap());
            res.push_str(": ");
            res.push_str(&self.current_sequence);
            self.current_name = None;
            self.current_sequence.clear();
            self.current_sequence.shrink_to_fit();
            return Some(res);
        }
        None
    }
}
