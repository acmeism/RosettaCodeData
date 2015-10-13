#![feature(fs_walk)]

use std::fs;
use std::path::Path;

fn main() {
    for f in fs::walk_dir(&Path::new("/home/pavel/Music")).unwrap() {
        let p = f.unwrap().path();
        if p.extension().unwrap_or("".as_ref()) == "mp3" {
            println!("{:?}", p);
        }
    }
}
