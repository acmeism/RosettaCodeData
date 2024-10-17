use std::io::Write;
use std::fs::File;

fn main() -> std::io::Result<()> {
    File::open("/dev/tape")?.write_all(b"Hello from Rosetta Code!")
}
