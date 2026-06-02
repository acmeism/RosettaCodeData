import "std/string.zc"
import "ctype.h"

fn get_code(c: char) -> char {
    match c {
        'B', 'F', 'P', 'V' => { return '1'; },
        'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z' => { return '2'; },
        'D', 'T' => { return '3'},
        'L' => { return '4'; },
        'M', 'N' =>  { return '5'; },
        'R' => { return '6'; },
        'H', 'W' => { return '-'; },
        _ => { return ' '; }
    }
}

fn soundex(s: string) -> String {
    let len = strlen(s);
    let sb = String::new("");
    if len == 0 { return sb; }
    sb.push_rune(toupper(s[0]));
    let prev = get_code(toupper(s[0]));
    for i in 1..len {
        let curr = get_code(toupper(s[i]));
        if curr != ' ' && curr != '-' && curr != prev { sb.push_rune(curr); }
        if curr != '-' { prev = curr; }
    }
    let sb2 = sb.pad_right(4, '0');
    return sb2.substring(0, 4);
}

fn main() {
    let pairs: (string, string)[16] =  [
        ("Ashcraft",  "A261"),
        ("Ashcroft",  "A261"),
        ("Gauss",     "G200"),
        ("Ghosh",     "G200"),
        ("Hilbert",   "H416"),
        ("Heilbronn", "H416"),
        ("Lee",       "L000"),
        ("Lloyd",     "L300"),
        ("Moses",     "M220"),
        ("Pfister",   "P236"),
        ("Robert",    "R163"),
        ("Rupert",    "R163"),
        ("Rubin",     "R150"),
        ("Tymczak",   "T522"),
        ("Soundex",   "S532"),
        ("Example",   "E251")
    ];

    for i in 0..pairs.len {
        let (p1, p2) = pairs[i];
        let s = soundex(p1);
        let ps = String::from(p2);
        println "{p1:-9s} -> {p2} -> {s == &ps}";
    }
}
