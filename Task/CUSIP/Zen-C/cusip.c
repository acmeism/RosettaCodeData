fn is_cusip(s: string) -> bool {
    if strlen(s) != 9 { return false; }
    let sum = 0;
    for i in 0..8 {
        let c = s[i];
        let v: int;
        match c {
            48..=57 => { v = c - 48; },  // '0' to '9'
            65..=90 => { v = c - 55; },  // 'A' to 'Z'
            '*'     => { v = 36; },
            '@'     => { v = 37; },
            '#'     => { v = 38; },
            _       => { return false; }
        }
        if i % 2 == 1 { v = v * 2; } // check if odd as using 0-based indexing
        sum += (v / 10) +  v % 10;
    }
    return s[8] - 48 == (10 - (sum % 10)) % 10;
}

fn main() {
    let candidates = [
        "037833100",
        "17275R102",
        "38259P508",
        "594918104",
        "68389X106",
        "68389X105"
    ];
    for candidate in candidates {
        let b = is_cusip(candidate) ? "correct" : "incorrect";
        println "{candidate} -> {b}";
    }
}
