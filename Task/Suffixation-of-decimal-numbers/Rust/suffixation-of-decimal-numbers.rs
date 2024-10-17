use astro_float::{BigFloat, Consts, RoundingMode};
use itertools::Itertools;
use std::cmp::min;
use std::str::FromStr;

const SUFFIXES: [&str; 14] = [
    "", "K", "M", "G", "T", "P", "E", "Z", "Y", "X", "W", "V", "U", "googol",
];

// Do the divisions in BigFloat, then convert the quotients to f64 for formatting
fn suffize(input: &str, digits: usize, base: usize) -> String {
    let mut num = input.to_string();
    let numchars = num.chars().collect_vec();
    let exponent_distance = if base == 2 { 10 } else { 3 };
    let magnitude;
    let suffix_index;
    let mut num_str;
    num = num.replace(",", "");
    let num_sign = if "+-".contains(numchars[0]) {
        numchars[0].to_string()
    } else {
        "".to_string()
    };
    let mut big_consts = Consts::new().expect("Constants cache initialized");
    let mut fnum = BigFloat::from_str(num.as_str()).unwrap().abs();
    let goog = BigFloat::from_str("1e100").unwrap();
    if base == 10 && fnum >= goog {
        suffix_index = 13;
        fnum = fnum.div(&goog, 30, RoundingMode::ToEven);
    } else if fnum > BigFloat::from(1) {
        let temp = format!(
            "{}",
            fnum.log(
                &BigFloat::from(base as i32),
                30,
                RoundingMode::ToEven,
                &mut big_consts,
            )
            .int()
        );
        magnitude = f64::from_str(&temp).unwrap().round() as usize;
        suffix_index = min(magnitude / exponent_distance, 12);
        fnum = fnum.div(
            &BigFloat::from(base as i32).powi(
                exponent_distance * suffix_index,
                30,
                RoundingMode::ToEven,
            ),
            30,
            RoundingMode::ToEven,
        );
    } else {
        suffix_index = 0;
    }
    let fnum64 = f64::from_str(format!("{}", fnum).as_str()).unwrap();
    if digits != 0 {
        num_str = format!("{:.*}", digits, fnum64);
    } else {
        num_str = format!("{:}", fnum64.round());
        let mut s = num_str.strip_suffix("0").unwrap_or(num_str.as_str());
        s = s.strip_suffix(".").unwrap_or(num_str.as_str());
        num_str = s.to_string();
    }
    return num_sign
        + num_str.as_str()
        + SUFFIXES[suffix_index]
        + (if base == 2 { "i" } else { "" });
}

fn main() {
    let tests = [
        ("87,654,321", 3, 10),
        ("-998,877,665,544,332,211,000", 3, 10),
        ("+112,233", 0, 10),
        ("16,777,216", 1, 10),
        ("456,789,100,000,000", 2, 10),
        ("456,789,100,000,000", 2, 10),
        ("456,789,100,000,000", 5, 2),
        ("456,789,100,000.000e+00", 0, 10),
        ("+16777216", 0, 2),
        ("1.2e101", 0, 10),
    ];
    for t in tests {
        println!("{:>30} {:>2}  {:>2}  :  {}", t.0, t.1, t.2, suffize(t.0, t.1, t.2))
    }
}
