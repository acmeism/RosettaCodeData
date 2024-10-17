use std::fs::File;
use std::io::{self, Read,  Write};
use std::path::Path;
use std::{env, fmt, process};

fn main() {
    let files: Vec<_> = env::args_os().skip(1).take(2).collect();

    if files.len() != 2 {
        exit_err("Both an input file and output file are required", 1);
    }

    copy(&files[0], &files[1]).unwrap_or_else(|e| exit_err(&e, e.raw_os_error().unwrap_or(-1)));
}

fn copy<P: AsRef<Path>>(infile: P, outfile: P) -> io::Result<()> {
    let mut vec = Vec::new();

    Ok(try!(File::open(infile)
         .and_then(|mut i| i.read_to_end(&mut vec))
         .and_then(|_| File::create(outfile))
         .and_then(|mut o| o.write_all(&vec))))
}

fn exit_err<T: fmt::Display>(msg: T, code: i32) -> ! {
    writeln!(&mut io::stderr(), "ERROR: {}", msg).expect("Could not write to stdout");
    process::exit(code);
}
