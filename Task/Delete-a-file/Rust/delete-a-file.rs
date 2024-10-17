use std::io::{self, Write};
use std::fs::{remove_file,remove_dir};
use std::path::Path;
use std::{process,display};

const FILE_NAME: &'static str = "output.txt";
const DIR_NAME : &'static str = "docs";

fn main() {
    delete(".").and(delete("/"))
               .unwrap_or_else(|e| error_handler(e,1));
}


fn delete<P>(root: P) -> io::Result<()>
    where P: AsRef<Path>
{
    remove_file(root.as_ref().join(FILE_NAME))
        .and(remove_dir(root.as_ref().join(DIR_NAME)))
}

fn error_handler<E: fmt::Display>(error: E, code: i32) -> ! {
    let _ = writeln!(&mut io::stderr(), "{:?}", error);
    process::exit(code)
}
