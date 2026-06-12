fn gs_char_encode(i: u8) -> String {
    let mut resultchars = Vec::<u8>::new();
    match i {
        0..=31 => { resultchars.extend(['|' as u8, 64 + i]) }
        0x22 => { resultchars.extend(['|' as u8, '"' as u8]) }
        0x7c => { resultchars.extend(['|' as u8, '|' as u8]) }
        127 => { resultchars.extend(['|' as u8, '?' as u8]) }
        128..=255 => { // |! then recurse after subtracting 128
            resultchars.extend(['|' as u8, '!' as u8]);
            resultchars.extend(gs_char_encode(i - 128).as_bytes());
        }
        _ => { resultchars.push(i) }
    }
    return String::from_utf8_lossy(&resultchars).to_string();
}

fn gs_trans_encode(s: &str) -> String {
    return s.as_bytes().iter().map(|byt| gs_char_encode(*byt)).collect::<Vec<_>>().join("");
}

fn gs_trans_decode(s: &str) -> String {
    let mut result = Vec::<u8>::new();
    let mut gotbar = false;
    let mut gotbang = false;
    let mut bangadd = 0;
    for c in s.chars() {
        let i = c as u8;
        if gotbang {
            if c == '|' {
                bangadd = 128;
                gotbar = true;
            } else {
                result.push(i + 128);
            }
            gotbang = false;
        } else if gotbar {
            match c {
                '?' => { result.push(127 + bangadd) }
                '!' => { gotbang = true }
                '|' | '"' | '<' => { result.push(i + bangadd) }
                '[' | '{' => { result.push(27 + bangadd) }
                '\\' => { result.push(28 + bangadd) }
                ']' | '}' => { result.push(29 + bangadd) }
                '^' | '~' => { result.push(30 + bangadd) }
                '_' | '`' => { result.push(31 + bangadd) }
                _ => { // mask bit 32 to make lowercase into uppercase
                    let j = bangadd + (if c.is_lowercase() {i - 32} else {i});
                    result.push(if j >= 64 {j - 64} else {i});
                }
            }
            gotbar = false;
            bangadd = 0;
        } else if c == '|' {
            gotbar = true;
        } else {
            result.push(i);
        }
    }
    return String::from_utf8_lossy(&result).to_string();
}

fn main() {
    for t in ["ALERT|G", "wert↑", "@♂aN°$ª7Î", "ÙC▼æÔt6¤☻Ì", "\"@)Ð♠qhýÌÿ",
                 "+☻#o9$u♠©A", "♣àlæi6Ú.é", "ÏÔ♀È♥@ë", "Rç÷\\%◄MZûhZ", "ç>¾AôVâ♫↓P"] {
        let e = gs_trans_encode(t);
        let d = gs_trans_decode(&e);
        println!("Test string {} encoded is {}, decoded is: {}", t, e, d.escape_debug());
        assert!(t == d);
    }
    for t in [&"abc|1de|5f", &"|LHello|G|J|M", &"|m|j|@|e|!t|m|!|?"] {
        let d = gs_trans_decode(t);
        println!("Test string {} decoded is {}", t, d.escape_debug());
    }
}
