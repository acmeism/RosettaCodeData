use std::io::{self, Write};

struct Playfair {
    txt: String,
    m: [[char; 5]; 5],
}

impl Playfair {
    fn new() -> Self {
        Playfair {
            txt: String::new(),
            m: [[' '; 5]; 5],
        }
    }

    fn do_it(&mut self, k: &str, t: &str, ij: bool, e: bool) {
        self.create_grid(k, ij);
        self.get_text_ready(t, ij, e);

        if e {
            self.process(1);
        } else {
            self.process(-1);
        }

        self.display();
    }

    fn process(&mut self, dir: i32) {
        let mut ntxt = String::new();
        let mut chars = self.txt.chars().collect::<Vec<char>>();
        let mut i = 0;

        while i < chars.len() {
            if i + 1 >= chars.len() {
                break;
            }

            let mut a = 0;
            let mut b = 0;
            let mut c = 0;
            let mut d = 0;

            if self.get_char_pos(chars[i], &mut a, &mut b) &&
               self.get_char_pos(chars[i+1], &mut c, &mut d) {
                if a == c {
                    ntxt.push(self.get_char(a, b + dir));
                    ntxt.push(self.get_char(c, d + dir));
                } else if b == d {
                    ntxt.push(self.get_char(a + dir, b));
                    ntxt.push(self.get_char(c + dir, d));
                } else {
                    ntxt.push(self.get_char(c, b));
                    ntxt.push(self.get_char(a, d));
                }
            }

            i += 2;
        }

        self.txt = ntxt;
    }

    fn display(&self) {
        println!("\n\n OUTPUT:\n=========");
        let chars = self.txt.chars().collect::<Vec<char>>();
        let mut cnt = 0;
        let mut i = 0;

        while i < chars.len() {
            if i + 1 < chars.len() {
                print!("{}{} ", chars[i], chars[i+1]);
                i += 2;
                cnt += 1;

                if cnt >= 26 {
                    println!();
                    cnt = 0;
                }
            } else {
                print!("{}", chars[i]);
                i += 1;
            }
        }

        println!("\n");
    }

    fn get_char(&self, a: i32, b: i32) -> char {
        let row = ((b + 5) % 5) as usize;
        let col = ((a + 5) % 5) as usize;
        self.m[row][col]
    }

    fn get_char_pos(&self, l: char, a: &mut i32, b: &mut i32) -> bool {
        for y in 0..5 {
            for x in 0..5 {
                if self.m[y][x] == l {
                    *a = x as i32;
                    *b = y as i32;
                    return true;
                }
            }
        }
        false
    }

    fn get_text_ready(&mut self, t: &str, ij: bool, e: bool) {
        self.txt.clear();

        for c in t.chars() {
            let c_upper = c.to_ascii_uppercase();

            if c_upper < 'A' || c_upper > 'Z' {
                continue;
            }

            if c_upper == 'J' && ij {
                self.txt.push('I');
            } else if c_upper == 'Q' && !ij {
                continue;
            } else {
                self.txt.push(c_upper);
            }
        }

        if e {
            let mut ntxt = String::new();
            let chars = self.txt.chars().collect::<Vec<char>>();
            let len = chars.len();

            let mut x = 0;
            while x < len {
                ntxt.push(chars[x]);

                if x + 1 < len {
                    if chars[x] == chars[x + 1] {
                        ntxt.push('X');
                    }
                    ntxt.push(chars[x + 1]);
                }

                x += 2;
            }

            self.txt = ntxt;
        }

        if self.txt.len() % 2 == 1 {
            self.txt.push('X');
        }
    }

    fn create_grid(&mut self, k: &str, ij: bool) {
        let mut key = k.to_string();
        if key.is_empty() {
            key = "KEYWORD".to_string();
        }

        key.push_str("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
        let mut nk = String::new();

        for c in key.chars() {
            let c_upper = c.to_ascii_uppercase();

            if c_upper < 'A' || c_upper > 'Z' {
                continue;
            }

            if (c_upper == 'J' && ij) || (c_upper == 'Q' && !ij) {
                continue;
            }

            if !nk.contains(c_upper) {
                nk.push(c_upper);
            }
        }

        let mut idx = 0;
        for y in 0..5 {
            for x in 0..5 {
                if idx < nk.len() {
                    self.m[y][x] = nk.chars().nth(idx).unwrap();
                    idx += 1;
                }
            }
        }
    }
}

fn main() -> io::Result<()> {
    let mut input = String::new();

    print!("(E)ncode or (D)ecode? ");
    io::stdout().flush()?;
    io::stdin().read_line(&mut input)?;
    let e = input.trim().to_lowercase().starts_with('e');

    input.clear();
    print!("Enter a en/decryption key: ");
    io::stdout().flush()?;
    io::stdin().read_line(&mut input)?;
    let key = input.trim().to_string();

    input.clear();
    print!("I <-> J (Y/N): ");
    io::stdout().flush()?;
    io::stdin().read_line(&mut input)?;
    let ij = input.trim().to_lowercase().starts_with('y');

    input.clear();
    print!("Enter the text: ");
    io::stdout().flush()?;
    io::stdin().read_line(&mut input)?;
    let txt = input.trim().to_string();

    let mut pf = Playfair::new();
    pf.do_it(&key, &txt, ij, e);

    println!("Press Enter to continue...");
    input.clear();
    io::stdin().read_line(&mut input)?;

    Ok(())
}
