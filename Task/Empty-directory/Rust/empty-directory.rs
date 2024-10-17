use std::fs::read_dir;
use std::error::Error;

fn main() {
    for path in std::env::args().skip(1) { // iterate over the arguments, skipping the first (which is the executable)
        match read_dir(path.as_str()) { // try to read the directory specified
            Ok(contents) => {
                let len = contents.collect::<Vec<_>>().len(); // calculate the amount of items in the directory
                if len == 0 {
                    println!("{} is empty", path);
                } else {
                    println!("{} is not empty", path);
                }
            },
            Err(e) => { // If the attempt failed, print the corresponding error msg
                println!("Failed to read directory \"{}\": {}", path, e.description());
            }
        }
    }
}
