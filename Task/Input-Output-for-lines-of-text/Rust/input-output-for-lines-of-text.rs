use std::{error::Error, io};

fn do_stuff(line: &str) {
    print!("{line}");
}

fn main() -> Result<(), Box<dyn Error>> {
    let reader = io::stdin();

    // Reusing this heap-allocated buffer prevents allocating new memory
    // for every single line read.
    let mut buf = String::new();

    // The `?` operator propagates errors up the call stack.
    reader.read_line(&mut buf)?;

    // Trim whitespace before attempting to parse the number.
    let line_count: usize = buf.trim().parse()?;

    for _ in 0..line_count {
        // Clear to recycle the buffer.
        buf.clear();
        reader.read_line(&mut buf)?;

        do_stuff(&buf);
    }

    Ok(())
}
