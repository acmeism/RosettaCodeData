use std::fs::File;
use std::io::Write;

fn main() -> std::io::Result<()> {
    let data = "Sample text.";
    let mut file = File::create("filename.txt")?;
    write!(file, "{}", data)?;
    Ok(())
}
