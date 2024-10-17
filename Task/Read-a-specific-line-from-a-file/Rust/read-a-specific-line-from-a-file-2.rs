use std::env;
use std::fs::File;
use std::io::BufRead;
use std::io::BufReader;
use std::path::Path;

fn main() {
    if env::args().len() <= 1 {
        println!("At least a path to a file is needed: No file path given");
        return;
    } else {
        let path = &env::args().nth(1).expect("could not parse the path");
        let path = Path::new(&path);
        let mut line_num = 1usize;
        if let Some(arg) = env::args().nth(2) {
            line_num = arg.parse::<usize>().expect("Parsing line number failed");
        }
        print_line_at(&path, line_num);
    }
}

fn print_line_at(path: &Path, line_num: usize) {
    if line_num < 1 {
        panic!("Line number has to be > 0");
    }
    let line_num = line_num - 1;
    let file = File::open(path).expect("File not found or cannot be opened");
    let content = BufReader::new(&file);
    let mut lines = content.lines();
    let line = lines.nth(line_num).expect("No line found at given position");
    println!("{}", line.expect("None line"));
}
