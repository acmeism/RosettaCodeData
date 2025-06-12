use regex::Regex;
use std::cmp::Ordering;

// Only covers ISO-8859-1 accented characters plus, for consistency, Ÿ
const UC_ACCENTS: [&str; 8] = ["ÀÁÂÃÄÅ", "Ç", "ÈÉÊË", "ÌÍÎÏ", "Ñ", "ÒÓÔÕÖØ", "ÙÚÛÜ", "ÝŸ"];
const LC_ACCENTS: [&str; 8] = ["àáâãäå", "ç", "èéêë", "ìíîï", "ñ", "òóôõöø", "ùúûü", "ýÿ"];
const UC_UNACCENTS: [&str; 8] = ["A", "C", "E", "I", "N", "O", "U", "Y"];
const LC_UNACCENTS: [&str; 8] = ["a", "c", "e", "i", "n", "o", "u", "y"];

// Only the more common ligatures
const UC_LIGATURES: [&str; 3] = ["Æ", "Ĳ", "Œ"];
const LC_LIGATURES: [&str; 3] = ["æ", "ĳ", "œ"];
const UC_SEPARATES: [&str; 3] = ["AE", "IJ", "OE"];
const LC_SEPARATES: [&str; 3] = ["ae", "ij", "oe"];

// Miscellaneous replacements
const MISC_LETTERS: [&str; 3] = ["ß", "ſ", "ʒ"];
const MISC_REPLACEMENTS: [&str; 3] = ["ss", "s", "s"];

// Remove leading spaces
fn left_trim(text: &str) -> String {
    text.trim_start().to_string()
}

// Replace multiple spaces with a single space
fn replace_spaces(text: &str) -> String {
    let regex_expr = Regex::new(r" {2,}").unwrap();
    regex_expr.replace_all(text, " ").to_string()
}

// Replace whitespace with a single space
fn replace_whitespace(text: &str) -> String {
    let regex_expr = Regex::new(r"\s+").unwrap();
    regex_expr.replace_all(text, " ").to_string()
}

// Display strings including whitespace as if the latter were literal characters
fn to_display_string(text: &str) -> String {
    let whitespace_1 = ["\t", "\n", "\u{000b}", "\u{000c}", "\r"];
    let whitespace_2 = ["\\t", "\\n", "\\u000b", "\\u000c", "\\r"];
    let mut result = text.to_string();

    for i in 0..whitespace_1.len() {
        result = result.replace(whitespace_1[i], whitespace_2[i]);
    }
    result
}

// Transform the string into lower case
fn to_lower_case(text: &str) -> String {
    text.to_lowercase()
}

// Pad each numeric character with leading zeros to a total length of 20
fn zero_padding(text: &str) -> String {
    let digits = Regex::new(r"-?\d+").unwrap();
    let mut result = text.to_string();
    let mut extra_index = 0;

    for cap in digits.captures_iter(text) {
        let match_str = &cap[0];
        let start_pos = text.find(match_str).unwrap() + extra_index;
        let padding = "0".repeat(20 - match_str.len());

        result = format!("{}{}{}",
                        &result[..start_pos],
                        padding,
                        &result[start_pos..]);

        extra_index += 20 - match_str.len();
    }

    result
}

fn remove_title(text: &str) -> String {
    let regex = Regex::new(r"^(The|An|A)\s+").unwrap();
    regex.replace(text, "").to_string()
}

// Replace accented letters with their unaccented equivalent
fn replace_accents(text: &str) -> String {
    let mut result = String::new();
    let chars: Vec<char> = text.chars().collect();

    for i in 0..chars.len() {
        if (chars[i] as u32) < 128 {
            result.push(chars[i]);
            continue;
        }

        let length = result.len();
        let letter = chars[i].to_string();

        for j in 0..UC_ACCENTS.len() {
            if UC_ACCENTS[j].contains(&letter) {
                result.push_str(UC_UNACCENTS[j]);
                break;
            }
        }

        if length == result.len() {
            for j in 0..LC_ACCENTS.len() {
                if LC_ACCENTS[j].contains(&letter) {
                    result.push_str(LC_UNACCENTS[j]);
                    break;
                }
            }
        }
    }

    result
}

// Replace ligatures with separated letters
fn replace_ligatures(text: &str) -> String {
    let mut result = text.to_string();

    for i in 0..UC_LIGATURES.len() {
        result = result.replace(UC_LIGATURES[i], UC_SEPARATES[i]);
    }

    for i in 0..LC_LIGATURES.len() {
        result = result.replace(LC_LIGATURES[i], LC_SEPARATES[i]);
    }

    result
}

// Replace miscellaneous letters with their equivalent replacements
fn replace_characters(text: &str) -> String {
    let mut result = text.to_string();

    for i in 0..MISC_LETTERS.len() {
        result = result.replace(MISC_LETTERS[i], MISC_REPLACEMENTS[i]);
    }

    result
}

fn main() {
    println!("The 9 string lists, sorted 'naturally':");

    let mut s1 = vec![
        "ignore leading spaces: 2-2".to_string(),
        " ignore leading spaces: 2-1".to_string(),
        "  ignore leading spaces: 2+0".to_string(),
        "   ignore leading spaces: 2+1".to_string()
    ];

    println!();
    s1.sort_by(|lhs, rhs| left_trim(lhs).cmp(&left_trim(rhs)));
    for s in &s1 {
        println!("{}", s);
    }

    let mut s2 = vec![
        "ignore m.a.s spaces: 2-2".to_string(),
        "ignore m.a.s  spaces: 2-1".to_string(),
        "ignore m.a.s   spaces: 2+0".to_string(),
        "ignore m.a.s    spaces: 2+1".to_string()
    ];

    println!();
    s2.sort_by(|lhs, rhs| replace_spaces(lhs).cmp(&replace_spaces(rhs)));
    for s in &s2 {
        println!("{}", s);
    }

    let mut s3 = vec![
        "Equiv. spaces: 3-3".to_string(),
        "Equiv.\rspaces: 3-2".to_string(),
        "Equiv.\u{000c}spaces: 3-1".to_string(),
        "Equiv.\u{000b}spaces: 3+0".to_string(),
        "Equiv.\nspaces: 3+1".to_string(),
        "Equiv.\tspaces: 3+2".to_string()
    ];

    println!();
    s3.sort_by(|lhs, rhs| replace_whitespace(lhs).cmp(&replace_whitespace(rhs)));
    for s in &s3 {
        println!("{}", to_display_string(s));
    }

    let mut s4 = vec![
        "cASE INDEPENENT: 3-2".to_string(),
        "caSE INDEPENENT: 3-1".to_string(),
        "casE INDEPENENT: 3+0".to_string(),
        "case INDEPENENT: 3+1".to_string()
    ];

    println!();
    s4.sort_by(|lhs, rhs| to_lower_case(lhs).cmp(&to_lower_case(rhs)));
    for s in &s4 {
        println!("{}", s);
    }

    let mut s5 = vec![
        "foo100bar99baz0.txt".to_string(),
        "foo100bar10baz0.txt".to_string(),
        "foo1000bar99baz10.txt".to_string(),
        "foo1000bar99baz9.txt".to_string()
    ];

    println!();
    s5.sort_by(|lhs, rhs| zero_padding(lhs).cmp(&zero_padding(rhs)));
    for s in &s5 {
        println!("{}", s);
    }

    let mut s6 = vec![
        "The Wind in the Willows".to_string(),
        "The 40th step more".to_string(),
        "The 39 steps".to_string(),
        "Wanda".to_string()
    ];

    println!();
    s6.sort_by(|lhs, rhs| remove_title(lhs).cmp(&remove_title(rhs)));
    for s in &s6 {
        println!("{}", s);
    }

    let mut s7 = vec![
        "Equiv. ý accents: 2-2".to_string(),
        "Equiv. Ý accents: 2-1".to_string(),
        "Equiv. y accents: 2+0".to_string(),
        "Equiv. Y accents: 2+1".to_string()
    ];

    println!();
    s7.sort_by(|lhs, rhs| replace_accents(lhs).cmp(&replace_accents(rhs)));
    for s in &s7 {
        println!("{}", s);
    }

    let mut s8 = vec![
        "Ĳ ligatured ij".to_string(),
        "no ligature".to_string()
    ];

    println!();
    s8.sort_by(|lhs, rhs| replace_ligatures(lhs).cmp(&replace_ligatures(rhs)));
    for s in &s8 {
        println!("{}", s);
    }

    let mut s9 = vec![
        "Start with an ʒ: 2-2".to_string(),
        "Start with an ſ: 2-1".to_string(),
        "Start with an ß: 2+0".to_string(),
        "Start with an s: 2+1".to_string()
    ];

    println!();
    s9.sort_by(|lhs, rhs| replace_characters(lhs).cmp(&replace_characters(rhs)));
    for s in &s9 {
        println!("{}", s);
    }
}
