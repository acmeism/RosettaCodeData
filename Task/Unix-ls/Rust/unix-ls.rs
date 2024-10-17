use std::{env, fmt, fs, process};
use std::io::{self, Write};
use std::path::Path;

fn main() {
    let cur = env::current_dir().unwrap_or_else(|e| exit_err(e, 1));
    let arg = env::args().nth(1);
    print_files(arg.as_ref().map_or(cur.as_path(), |p| Path::new(p)))
        .unwrap_or_else(|e| exit_err(e, 2));
}

#[inline]
fn print_files(path: &Path) -> io::Result<()> {
    for x in try!(fs::read_dir(path)) {
        println!("{}", try!(x).file_name().to_string_lossy());
    }
    Ok(())
}

#[inline]
fn exit_err<T>(msg: T, code: i32) -> ! where T: fmt::Display {
    writeln!(&mut io::stderr(), "{}", msg).expect("Could not write to stderr");
    process::exit(code)
}
