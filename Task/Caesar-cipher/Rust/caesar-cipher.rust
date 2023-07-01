use std::io::{self, Write};
use std::fmt::Display;
use std::{env, process};

fn main() {
    let shift: u8 = env::args().nth(1)
        .unwrap_or_else(|| exit_err("No shift provided", 2))
        .parse()
        .unwrap_or_else(|e| exit_err(e, 3));

    let plain = get_input()
        .unwrap_or_else(|e| exit_err(&e, e.raw_os_error().unwrap_or(-1)));

    let cipher = plain.chars()
        .map(|c| {
            let case = if c.is_uppercase() {'A'} else {'a'} as u8;
            if c.is_alphabetic() { (((c as u8 - case + shift) % 26) + case) as char } else { c }
        }).collect::<String>();

    println!("Cipher text: {}", cipher.trim());
}


fn get_input() -> io::Result<String> {
    print!("Plain text:  ");
    try!(io::stdout().flush());

    let mut buf = String::new();
    try!(io::stdin().read_line(&mut buf));
    Ok(buf)
}

fn exit_err<T: Display>(msg: T, code: i32) -> ! {
    let _ = writeln!(&mut io::stderr(), "ERROR: {}", msg);
    process::exit(code);
}
