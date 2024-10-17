use itertools::Itertools;
use std::cmp::min;
use std::str::FromStr;

// (name, minimum abbreviation length, base, power of base)
const SUFFIXES: [(&str, usize, usize, u32); 28] = [
    ("greatgross", 7, 12, 3),
    ("gross", 2, 12, 2),
    ("dozens", 3, 12, 1),
    ("pairs", 4, 2, 1),
    ("scores", 3, 20, 1),
    ("googols", 6, 10, 100),
    ("ki", 2, 2, 10),
    ("mi", 2, 2, 20),
    ("gi", 2, 2, 30),
    ("ti", 2, 2, 40),
    ("pi", 2, 2, 50),
    ("ei", 2, 2, 60),
    ("zi", 2, 2, 70),
    ("yi", 2, 2, 80),
    ("xi", 2, 2, 90),
    ("wi", 2, 2, 100),
    ("vi", 2, 2, 110),
    ("ui", 2, 2, 120),
    ("k", 1, 10, 3),
    ("m", 1, 10, 6),
    ("g", 1, 10, 9),
    ("t", 1, 10, 12),
    ("p", 1, 10, 15),
    ("e", 1, 10, 18),
    ("z", 1, 10, 21),
    ("y", 1, 10, 24),
    ("x", 1, 10, 27),
    ("w", 1, 10, 30),
];

fn expand(input: &str) -> String {
    let num = input.replace(",", "").trim().to_lowercase().to_string();
    let len = num.len();
    let numchars = num.chars().collect_vec();
    if numchars[len - 1].is_numeric() {
        return f64::from_str(num.as_str()).unwrap().to_string();
    }
    // find end of initial numeric portion
    let mut pos = num
        .find(|c: char| !c.is_numeric() && !".+-".contains(c))
        .unwrap_or(len);

    // if factorial, calculate
    if pos < len && &num[pos..=pos] == "!" {
        let step = len - pos;
        let i = i64::from_str(&num[..pos]).unwrap();
        return (1..=i)
            .rev()
            .step_by(step)
            .fold(1, |p, f| f * p)
            .to_string();
    }
    // if we have an exponential notation number, include that portion
    if pos < num.len() - 2
        && (numchars[pos] == 'e' || numchars[pos] == 'E')
        && (numchars[pos + 1].is_numeric() || "+-".contains(numchars[pos + 1]))
    {
        let mut rnumchars = numchars.clone();
        rnumchars.reverse();
        pos = num.len()
            - rnumchars
                .iter()
                .enumerate()
                .find(|(_i, c)| c.is_numeric())
                .unwrap()
                .0;
    }
    let mut fnum = f64::from_str(&num[..pos]).unwrap();
    let mut extra_digits = 0_usize;
    let mut input_suffix = &num[pos..];
    while !input_suffix.is_empty() {
        for (suffix, min_abbrev, base, power) in SUFFIXES {
            match input_suffix.find(&suffix[..min_abbrev]) {
                Some(start) => {
                    if start == 0 {
                        if base == 10 && power > 30 {
                            extra_digits = power as usize;
                        } else {
                            fnum *= (base as i128).pow(power) as f64;
                        }
                        let min_len = min(input_suffix.len(), suffix.len());
                        let ichars = input_suffix.chars().collect_vec();
                        let schars = suffix.chars().collect_vec();
                        for i in 0..=min_len {
                            if i == min_len || ichars[i] != schars[i] {
                                input_suffix = &input_suffix[i..];
                                break;
                            }
                        }
                        break;
                    }
                }
                None => {}
            }
        }
    }
    if fnum > 1.0 && (fnum - fnum.round()).abs() < f64::EPSILON {
        let zeros = "0".repeat(extra_digits);
        return (fnum.round() as i128).to_string() + zeros.as_str();
    }
    for _ in 0..extra_digits {
        // may prevent overflow
        fnum *= 10 as f64;
    }
    return fnum.to_string();
}

fn main() {
    let test_cases = (r#"
    2greatGRo   24Gros  288Doz  1,728pairs  172.8SCOre
    1,567      +1.567k    0.1567e-2m
    25.123kK    25.123m   2.5123e-00002G
    25.123kiKI  25.123Mi  2.5123e-00002Gi  +.25123E-7Ei
    -.25123e-34Vikki      2e-77gooGols
    9!   9!!   9!!!   9!!!!   9!!!!!   9!!!!!!   9!!!!!!!   9!!!!!!!!   9!!!!!!!!!
    "#)
    .split("\n")
    .collect_vec();
    for line in test_cases.iter().filter(|x| !x.trim().is_empty()) {
        let results = line
            .trim()
            .split_whitespace()
            .map(|s| expand(s))
            .join("   ");
        println!("Input: {}\nOutput:    {}\n", line, results);
    }
}
