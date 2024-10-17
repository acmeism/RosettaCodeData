use std::fs;

fn main() {
    for file in ["input.txt", "docs", "/input.txt", "/docs"].iter() {
        match fs::metadata(file) {
            Ok(attr) => {
                if attr.is_dir() {
                    println!("{} is a directory", file);
                }else {
                    println!("{} is a file", file);
                }
            },
            Err(_) => {
                println!("{} does not exist", file);
            }
        };
    }
}
