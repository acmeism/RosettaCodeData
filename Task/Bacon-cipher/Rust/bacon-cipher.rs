use std::collections::HashMap;

struct Bacon {
    b_alphabet: Vec<String>,
}

impl Bacon {
    fn new() -> Self {
        let mut b_alphabet = Vec::new();
        let mut x = 0;

        for _ in 0..9 {
            b_alphabet.push(format!("{:05b}", x));
            x += 1;
        }
        b_alphabet.push(b_alphabet.last().unwrap().clone());

        for _ in 10..20 {
            b_alphabet.push(format!("{:05b}", x));
            x += 1;
        }
        b_alphabet.push(b_alphabet.last().unwrap().clone());

        for _ in 21..24 {
            b_alphabet.push(format!("{:05b}", x));
            x += 1;
        }

        Bacon { b_alphabet }
    }

    fn encode(&self, txt: &str) -> String {
        let mut r = String::new();

        for c in txt.chars() {
            let z = c.to_ascii_uppercase();
            if z < 'A' || z > 'Z' {
                continue;
            }
            let index = (z as u8 & 31) - 1;
            r.push_str(&self.b_alphabet[index as usize]);
        }

        r
    }

    fn decode(&self, txt: &str) -> String {
        let mut len = txt.len();
        while len % 5 != 0 {
            len -= 1;
        }

        let txt = if len != txt.len() {
            &txt[0..len]
        } else {
            txt
        };

        let mut r = String::new();
        let alphabet_map: HashMap<&String, usize> = self.b_alphabet
            .iter()
            .enumerate()
            .map(|(i, s)| (s, i))
            .collect();

        for i in (0..len).step_by(5) {
            let substr = &txt[i..i+5];
            if let Some(&index) = alphabet_map.get(&substr.to_string()) {
                r.push((b'A' + index as u8) as char);
            }
        }

        r
    }
}

struct CipherI {
    b: Bacon,
}

impl CipherI {
    fn new() -> Self {
        CipherI { b: Bacon::new() }
    }

    fn encode(&self, txt: &str) -> String {
        let txt = self.b.encode(txt);
        let mut e = String::new();
        let d = "one morning, when gregor samsa woke from troubled dreams, he found himself transformed \
                in his bed into a horrible vermin. he lay on his armour-like back, and if he lifted his head a little he \
                could see his brown belly, slightly domed and divided by arches into stiff sections.";

        let mut r = 0;
        for c in txt.chars() {
            let mut t = d.chars().nth(r).unwrap();
            while t < 'a' || t > 'z' {
                e.push(t);
                r += 1;
                t = d.chars().nth(r).unwrap();
            }
            r += 1;

            e.push(if c == '1' {
                t.to_ascii_uppercase()
            } else {
                t
            });
        }

        e
    }

    fn decode(&self, txt: &str) -> String {
        let mut h = String::new();

        for c in txt.chars() {
            if (c < 'a' && (c < 'A' || c > 'Z')) || c > 'z' {
                continue;
            }

            h.push(if c.is_lowercase() { '0' } else { '1' });
        }

        self.b.decode(&h)
    }
}

struct CipherII {
    b: Bacon,
}

impl CipherII {
    fn new() -> Self {
        CipherII { b: Bacon::new() }
    }

    fn encode(&self, txt: &str) -> String {
        let txt = self.b.encode(txt);
        let mut e = String::new();

        for c in txt.chars() {
            e.push(if c == '0' {
                '\u{00f9}' // 0xf9
            } else {
                '\u{00fa}' // 0xfa
            });
        }

        e
    }

    fn decode(&self, txt: &str) -> String {
        let mut h = String::new();

        for c in txt.chars() {
            h.push(if c == '\u{00f9}' { '0' } else { '1' });
        }

        self.b.decode(&h)
    }
}

fn main() {
    let c1 = CipherI::new();
    let c2 = CipherII::new();
    let s = "lets have some fun with bacon cipher";

    let h1 = c1.encode(s);
    let h2 = c2.encode(s);

    println!("{}\n\n{}\n\n", h1, c1.decode(&h1));
    println!("{}\n\n{}\n\n", h2, c2.decode(&h2));
}
