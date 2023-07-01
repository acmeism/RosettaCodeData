use std::io::{stdout, Write};
use std::time::Duration;

fn main() {
    let mut output = stdout();

    print!("\x1b[?1049h\x1b[H");
    println!("Alternate screen buffer");

    for i in (1..=5).rev() {
        print!("\rgoing back in {}...", i);
        output.flush().unwrap();
        std::thread::sleep(Duration::from_secs(1));
    }

    print!("\x1b[?1049l");
}
