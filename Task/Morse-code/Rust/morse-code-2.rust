//!
//! morse_code/src/lib.rs
//!
//! Michael G. Cummings
//! 2019-08-26
//!

#[macro_use]
extern crate structopt;

use std::{fs, io};
use std::collections::HashMap;
use std::error::Error;
use std::path::PathBuf;

/// Main library function that does the actual work.
///
/// Each character has one space between them and there are two spaces between words.
/// Unknown characters in the input are replaced with a '#' in the output.
///
pub fn run(config: &mut Config) -> Result<(), Box<dyn Error>> {
    let mut contents = String::new();
    config.read.read_to_string(&mut contents)?;
    let morse_map = init_code_map();
    let mut result = String::new();
    for char in contents.trim().to_uppercase().chars() {
        match morse_map.get(&char) {
            Some(hash) => {
                result = result + *hash;
            }
            None => { result = result + "#" }
        }
        result = result + " ";
    }
    config.write.write(result.as_ref())?;
    Ok(())
}

/// Configuration structure for the input and output streams.
#[derive(Debug)]
pub struct Config {
    read: Box<dyn io::Read>,
    write: Box<dyn io::Write>,
}

impl Config {
    pub fn new(opts: Opt) -> Result<Config, &'static str> {
        let input: Box<dyn io::Read> = match opts.input {
            Some(p) => Box::new(fs::File::open(p).unwrap()),
            None => Box::new(io::stdin()),
        };
        let output: Box<dyn io::Write> = match opts.output {
            Some(p) => Box::new(fs::File::create(p).unwrap()),
            None => Box::new(io::stdout()),
        };
        Ok(Config { read: input, write: output })
    }
}

/// Structure used to hold command line opts(parameters) of binary.
///
/// Using StructOpt crate to parse command-line parameters/options.
///
#[derive(Debug, StructOpt)]
#[structopt(rename_all = "kebab-case", raw(setting = "structopt::clap::AppSettings::ColoredHelp"))]
pub struct Opt {
    /// Input file, stdin if not present
    #[structopt(short, long, parse(from_os_str))]
    input: Option<PathBuf>,
    /// Output file, stdout if not present
    #[structopt(short, long, parse(from_os_str))]
    output: Option<PathBuf>,
}

/// Initialize hash map of characters to morse code as string.
pub fn init_code_map() -> HashMap<char, &'static str> {
    let mut morse_map: HashMap<char, &str> = HashMap::with_capacity(37);
    morse_map.insert(' ', " ");
    morse_map.insert('A', "._");
    morse_map.insert('B', "_...");
    morse_map.insert('C', "_._.");
    morse_map.insert('D', "_..");
    morse_map.insert('E', ".");
    morse_map.insert('F', ".._.");
    morse_map.insert('G', "__.");
    morse_map.insert('H', "....");
    morse_map.insert('I', "..");
    morse_map.insert('J', ".___");
    morse_map.insert('K', "_._");
    morse_map.insert('L', "._..");
    morse_map.insert('M', "__");
    morse_map.insert('N', "_.");
    morse_map.insert('O', "___");
    morse_map.insert('P', ".__.");
    morse_map.insert('Q', "__._");
    morse_map.insert('R', "._.");
    morse_map.insert('S', "...");
    morse_map.insert('T', "_");
    morse_map.insert('U', ".._");
    morse_map.insert('V', "..._");
    morse_map.insert('W', ".__");
    morse_map.insert('X', "_.._");
    morse_map.insert('Y', "_.__");
    morse_map.insert('Z', "__..");
    morse_map.insert('1', ".____");
    morse_map.insert('2', "..___");
    morse_map.insert('3', "...__");
    morse_map.insert('4', "...._");
    morse_map.insert('5', ".....");
    morse_map.insert('6', "_....");
    morse_map.insert('7', "__...");
    morse_map.insert('8', "___..");
    morse_map.insert('9', "____.");
    morse_map.insert('0', "_____");
    morse_map
}
