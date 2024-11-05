use std::io::Read;
use std::str::FromStr;
fn interpret_vec(allwords: &[i32]) -> String {
    let mut words = allwords.to_vec();
    let mut buf = String::new();
    let mut ip = 0;
    loop {
        let (a, b, c) = (words[ip], words[ip + 1], words[ip + 2]);
        ip += 3;
        if a < 0 {
            print!("Enter a character: ");
            let mut input_char = [0_u8; 1];
            match std::io::stdin().read_exact(&mut input_char) {
                Ok(_) => {}
                Err(_) => return "error in input".to_owned(),
            }
            words[b as usize] = (input_char[0] as u8) as i32;
        } else if b < 0 {
            buf.push(words[a as usize] as u8 as char);
        } else {
            words[b as usize] = words[b as usize] - words[a as usize];
            if words[b as usize] <= 0 {
                if c < 0 {
                    break;
                }
                ip = c as usize;
            }
        }
    }
    return buf;
}

fn interpret(src: &str) -> String {
    let mut codes: Vec<i32> = Vec::new();
    for s in src.split_whitespace() {
        match i32::from_str(s) {
            Ok(n) => codes.push(n),
            _ => continue,
        }
    }
    interpret_vec(codes.as_slice())
}

fn main() {
    println!("{}", interpret("15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1 72 101 108 108 111 44 32 119 111 114 108 100 33 10 0"));
}
