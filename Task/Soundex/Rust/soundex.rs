use std::ops::Deref;
use regex::Regex;
use once_cell::sync::Lazy;

pub trait Soundex {
    fn soundex(&self) -> String;
}

fn soundex_match(c: char) -> char {
    return match c.to_ascii_lowercase() {
        'b' | 'f' | 'p' | 'v' => Some('1'),
        'c' | 'g' | 'j' | 'k' | 'q' | 's' | 'x' | 'z' => Some('2'),
        'd' | 't' => Some('3'),
        'l' => Some('4'),
        'm' | 'n' => Some('5'),
        'r' => Some('6'),
        _ => Some('0'),
    }.unwrap();
}

static RE: Lazy<Regex> = Lazy::new(|| {Regex::new("[^a-zA-Z]").unwrap()});

impl<T: Deref<Target = str>> Soundex for T {
    fn soundex(&self) -> String {
        let s = RE.replace(self, "").chars().collect::<Vec<char>>();
        if s.len() == 0 {
            return String::new();
        }
        let mut a = vec![s[0].to_ascii_uppercase(); 1].to_vec();
        let mut last_sdex = soundex_match(a[0]);
        let mut hadvowel = false;
        for ch in &s[1..s.len()] {
            let lc_ch = ch.to_ascii_lowercase();
            let sdex = soundex_match(lc_ch);
            if sdex != '0' {
                if sdex != last_sdex || hadvowel {
                    a.push(sdex);
                    last_sdex = sdex;
                    hadvowel = false;
                }
            }
            else if "aeiouy".contains(lc_ch) {
                hadvowel = true;
            }
        }
        if a.len() < 4 {
            for _ in 0..(4 - a.len()) {
                a.push('0');
            }
        }
        return a[0..4].into_iter().collect();
    }
}

fn main() {
    assert_eq!("Ascroft".soundex(), "A261".to_string());
    assert_eq!("Euler".soundex(), "E460".to_string());
    assert_eq!("Gausss".soundex(), "G200".to_string());
    assert_eq!("Hilbert".soundex(), "H416".to_string());
    assert_eq!("Knuth".soundex(), "K530".to_string());
    assert_eq!("Lloyd".soundex(), "L300".to_string());
    assert_eq!("Lukasiewicz".soundex(), "L222".to_string());
    assert_eq!("Ellery".soundex(), "E460".to_string());
    assert_eq!("Ghosh".soundex(), "G200".to_string());
    assert_eq!("Heilbronn".soundex(), "H416".to_string());
    assert_eq!("Kant".soundex(), "K530".to_string());
    assert_eq!("Ladd".soundex(), "L300".to_string());
    assert_eq!("Lissajous".soundex(), "L222".to_string());
    assert_eq!("Wheaton".soundex(), "W350".to_string());
    assert_eq!("Ashcraft".soundex(), "A261".to_string());
    assert_eq!("Burroughs".soundex(), "B620".to_string());
    assert_eq!("Burrows".soundex(), "B620".to_string());
    assert_eq!("O'Hara".soundex(), "O600".to_string());
}
