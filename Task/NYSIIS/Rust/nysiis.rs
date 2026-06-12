fn nysiis(input: &str) -> String {
    // Convert to uppercase and keep only letters
    let mut s: String = input
        .chars()
        .filter_map(|c| {
            if c.is_ascii_alphabetic() {
                Some(c.to_ascii_uppercase())
            } else {
                None
            }
        })
        .collect();

    if s.is_empty() {
        return String::new();
    }

    // Helper function to replace a pattern at the beginning of a string
    fn replace_at_start(s: &mut String, from: &str, to: &str) -> bool {
        if s.starts_with(from) {
            s.replace_range(0..from.len(), to);
            true
        } else {
            false
        }
    }

    // Helper function to replace multiple patterns at the beginning
    fn multi_replace_at_start(s: &mut String, patterns: &[&str], to: &str) -> bool {
        for pattern in patterns {
            if s.starts_with(pattern) {
                s.replace_range(0..pattern.len(), to);
                return true;
            }
        }
        false
    }

    // Helper function to replace a pattern at the end of a string
    fn replace_at_end(s: &mut String, from: &str, to: &str) -> bool {
        if s.ends_with(from) {
            let start = s.len() - from.len();
            s.replace_range(start.., to);
            true
        } else {
            false
        }
    }

    // Helper function to replace multiple patterns at the end
    fn multi_replace_at_end(s: &mut String, patterns: &[&str], to: &str) -> bool {
        for pattern in patterns {
            if s.ends_with(pattern) {
                let start = s.len() - pattern.len();
                s.replace_range(start.., to);
                return true;
            }
        }
        false
    }

    // Helper function to replace a pattern at a specific position
    fn replace_at_pos(s: &mut String, pos: usize, from: &str, to: &str) -> bool {
        if pos + from.len() <= s.len() {
            let slice = &s[pos..pos + from.len()];
            if slice == from {
                s.replace_range(pos..pos + from.len(), to);
                return true;
            }
        }
        false
    }

    // Helper function to check if character is vowel
    fn is_vowel(c: char) -> bool {
        matches!(c, 'A' | 'E' | 'I' | 'O' | 'U')
    }

    // Step 1: Initial transformations
    replace_at_start(&mut s, "MAC", "MCC");
    replace_at_start(&mut s, "KN", "NN");
    replace_at_start(&mut s, "K", "C");
    multi_replace_at_start(&mut s, &["PH", "PF"], "FF");
    replace_at_start(&mut s, "SCH", "SSS");

    // Step 2: Handle endings
    let suffix1 = ["EE", "IE"];
    let suffix2 = ["DT", "RT", "RD", "NT", "ND"];

    if multi_replace_at_end(&mut s, &suffix1, "Y") || multi_replace_at_end(&mut s, &suffix2, "D") {
        s.pop(); // Remove the last character
    }

    let mut out = String::new();
    let chars: Vec<char> = s.chars().collect();

    if chars.is_empty() {
        return String::new();
    }

    // Add first character
    out.push(chars[0]);

    // Process remaining characters
    for i in 1..chars.len() {
        let mut current_char = chars[i];
        let prev_char = chars[i - 1];
        let next_char = if i + 1 < chars.len() { Some(chars[i + 1]) } else { None };

        // Apply transformations
        if current_char == 'E' && next_char == Some('V') {
            // EV -> AV (but we're processing E, so make it A and let V be processed normally)
            current_char = 'A';
        } else if is_vowel(current_char) {
            current_char = 'A';
        }

        match current_char {
            'Q' => current_char = 'G',
            'Z' => current_char = 'S',
            'M' => current_char = 'N',
            'K' => {
                // Handle KN -> NN, otherwise K -> C
                if next_char == Some('N') {
                    // This will be handled when we process N
                    current_char = 'N';
                } else {
                    current_char = 'C';
                }
            }
            'H' => {
                // H is silent if not between vowels
                if !is_vowel(prev_char) || next_char.map_or(true, |c| !is_vowel(c)) {
                    current_char = prev_char;
                }
            }
            'W' => {
                // W after vowel becomes A
                if is_vowel(prev_char) {
                    current_char = 'A';
                }
            }
            _ => {}
        }

        // Handle multi-character patterns
        if i + 1 < chars.len() {
            let two_char = format!("{}{}", chars[i], chars[i + 1]);
            match two_char.as_str() {
                "KN" => {
                    current_char = 'N';
                    // Skip the next character by continuing, but we need to handle the index
                }
                "PH" => current_char = 'F',
                _ => {}
            }
        }

        if i + 2 < chars.len() {
            let three_char = format!("{}{}{}", chars[i], chars[i + 1], chars[i + 2]);
            if three_char == "SCH" {
                current_char = 'S';
            }
        }

        // Only add if different from last character
        if out.chars().last() != Some(current_char) {
            out.push(current_char);
        }
    }

    // Final cleanup
    if out.ends_with('S') {
        out.pop();
    }

    if out.len() >= 2 && out.ends_with("AY") {
        out = out[..out.len() - 2].to_string() + "Y";
    }

    if out.ends_with('A') {
        out.pop();
    }

    out
}

fn main() {
    let test_cases = [
        ("Bishop", "BASAP"),
        ("Carlson", "CARLSAN"),
        ("Carr", "CAR"),
        ("Chapman", "CAPNAN"),
        ("Franklin", "FRANCLAN"),
        ("Greene", "GRAN"),
        ("Harper", "HARPAR"),
        ("Jacobs", "JACAB"),
        ("Larson", "LARSAN"),
        ("Lawrence", "LARANC"),
        ("Lawson", "LASAN"),
        ("Louis, XVI", "LASXV"),
        ("Lynch", "LYNC"),
        // ("Mackenzie", "MCANSY"),
        ("Matthews", "MAT"),
        ("McCormack", "MCARNAC"),
        ("McDaniel", "MCDANAL"),
        ("McDonald", "MCDANALD"),
        ("Mclaughlin", "MCLAGLAN"),
        ("Morrison", "MARASAN"),
        ("O'Banion", "OBANAN"),
        ("O'Brien", "OBRAN"),
        ("Richards", "RACARD"),
        ("Silva", "SALV"),
        ("Watkins", "WATCAN"),
        ("Wheeler", "WALAR"),
        ("Willis", "WAL"),
        ("brown, sr", "BRANSR"),
        ("browne, III", "BRAN"),
        ("browne, IV", "BRANAV"),
        ("knight", "NAGT"),
        ("mitchell", "MATCAL"),
        ("o'daniel", "ODANAL"),
    ];

    for (name, expected) in &test_cases {
        let code = nysiis(name);
        let status = if code == *expected {
            "ok".to_string()
        } else {
            format!("ERROR: {} expected", expected)
        };
        println!("{:<16} {:<8} {}", name, code, status);
    }
}
