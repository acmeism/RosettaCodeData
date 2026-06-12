use is_printable::IsPrintable;
use std::env;
use std::fs::File;
use std::io::{Read, Seek, SeekFrom::Start};
use std::process::ExitCode;

const BYTES_HEX: usize = 16;
const BYTES_BIN: usize = 6;

fn print_hex(data: &[u8], count: usize) {
    for i in 0..count {
        if i % 8 == 0 {
            print!(" ");
        }
        print!(" {:02x}", data[i]);
    }
    for i in count..BYTES_HEX {
        if i % 8 == 0 {
            print!(" ");
        }
        print!("   ");
    }
}

fn print_binary(data: &[u8], count: usize) {
    print!(" ");
    for i in 0..count {
        let c = data[i];
        print!(" ");
        for j in (1..8).rev() {
            let m = 1 << j;
            print!("{}", if c & m != 0 { "1" } else { "0" });
        }
    }
    for _i in count..BYTES_BIN {
        print!("        ");
    }
}

fn print_chars(data: &[u8], count: usize) {
    for i in 0..count {
        print!(
            "{}",
            if data[i] < 129 && (data[i] as char).to_string().is_printable() {
                data[i] as char
            } else {
                '.'
            }
        );
    }
}

fn usage(program: &str) {
    eprintln!("usage: {} [-b] [-s skip] [-n length] filename", program);
}

fn usage_err(err: &str, arg: &str, program: &str) -> ExitCode {
    if err != "" && arg != "" {
        eprintln!("{} {}.", err, arg);
        usage(program);
    }
    return ExitCode::FAILURE;
}

fn main() -> ExitCode {
    let mut offset = 0_usize;
    let mut max_length = std::u32::MAX as usize;
    let mut binary = false;
    let mut source: String = ": No file name provided".to_owned();
    let args: Vec<String> = env::args().collect();
    for (i, arg) in args.clone().into_iter().enumerate() {
        if i == 0 {
            continue;
        }
        if i == args.len() - 1 || arg[0..=0] != *"-" {
            source = arg.to_owned();
            break;
        }
        match arg.as_bytes()[1] as char {
            's' => {
                if i == args.len() - 1 {
                    return usage_err("", "", &args[0]);
                }
                offset = match usize::from_str_radix(&arg[2..], 10) {
                    Ok(k) => k,
                    _ => return usage_err("Invalid skip ", &arg, &args[0]),
                };
            }
            'n' => {
                if i == args.len() - 1 {
                    return usage_err("", "", &args[0]);
                }
                max_length = match usize::from_str_radix(&arg[2..], 10) {
                    Ok(k) => k,
                    _ => return usage_err("Invalid length ", &arg, &args[0]),
                };
            }
            'b' => {
                binary = true;
            }
            _ => return usage_err("", "", &args[0]),
        }
    }
    let mut buf = [0_u8; BYTES_HEX];
    let data = if binary {
        &mut buf[0..BYTES_BIN]
    } else {
        &mut buf[..]
    };
    let mut file = match File::open(&source) {
        Ok(f) => f,
        _ => return usage_err("Cannot open to read", &source, &args[0]),
    };
    if offset > 0 {
        if offset > file.metadata().unwrap().len() as usize {
            offset = file.metadata().unwrap().len() as usize;
        }
        let _ = file.seek(Start(offset as u64));
    }

    let mut length = 0_usize;
    while length < max_length {
        let mut count = match file.read(data) {
            Ok(num_read) => num_read,
            _ => 0,
        };
        if count > max_length - length {
            count = max_length - length;
        }
        if count == 0 {
            println!();
            break;
        }
        if binary {
            print_binary(data, count);
        } else {
            print_hex(data, count);
        }
        print!("  |");
        print_chars(data, count);
        println!("|");
        offset += count;
        length += count;
    }
    return ExitCode::SUCCESS;
}
