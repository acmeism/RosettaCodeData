//!
//! morse_code/src/main.rs
//!
//! Michael G. Cummings
//! 2019-08-26
//!
//! Since Rust doesn't have build-in audio support text output is used.
//!

use std::process;
use structopt::StructOpt;
use morse_code::{Config, Opt, run};

/// Core of the command-line binary.
///
/// By default expects input from stdin and outputs resulting morse code to stdout, but can also
/// read and/or write to files.
/// Use `morse_code --help` for more information about options.
fn main() {
    let opts = Opt::from_args();
    let mut config = Config::new(opts).unwrap_or_else(|err| {
        eprintln!("Problem parsing arguments: {}", err);
        process::exit(1);
    });
    if let Err(err) = run(&mut config) {
        eprintln!("Application error: {}", err);
        process::exit(2);
    }
}
