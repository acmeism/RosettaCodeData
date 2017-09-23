use std::io::{self, Write};
use std::fs::{DirBuilder, File};
use std::path::Path;
use std::{process,fmt};

const FILE_NAME: &'static str = "output.txt";
const DIR_NAME : &'static str = "docs";

fn main() {
    create(".").and(create("/"))
               .unwrap_or_else(|e| error_handler(e,1));
}


fn create<P>(root: P) -> io::Result<File>
    where P: AsRef<Path>
{
    let f_path = root.as_ref().join(FILE_NAME);
    let d_path = root.as_ref().join(DIR_NAME);
    DirBuilder::new().create(d_path).and(File::create(f_path))
}

fn error_handler<E: fmt::Display>(error: E, code: i32) -> ! {
    let _ = writeln!(&mut io::stderr(), "Error: {}", error);
    process::exit(code)
}
