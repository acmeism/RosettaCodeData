use std::fs::File;
use std::io::prelude::*;
use std::io::{BufReader, BufWriter};

fn reverse_file(
    input_filename: &str,
    output_filename: &str,
    record_len: usize,
) -> std::io::Result<()> {
    let mut input = BufReader::new(File::open(input_filename)?);
    let mut output = BufWriter::new(File::create(output_filename)?);
    let mut buffer = vec![0; record_len];
    while input.read(&mut buffer)? == record_len {
        buffer.reverse();
        output.write_all(&buffer)?;
    }
    output.flush()?;
    Ok(())
}

fn main() {
    match reverse_file("infile.dat", "outfile.dat", 80) {
        Ok(()) => {}
        Err(error) => eprintln!("I/O error: {}", error),
    }
}
