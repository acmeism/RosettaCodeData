use itertools::Itertools;
use regex::Regex;
use std::cmp::max;

fn pad_zeros_needed(string: &str) -> usize {
    let len = string.len();
    return if len > 1 && string.chars().collect_vec()[0] == '0' {
        len
    } else {
        0
    };
}

fn ranged(string: &str) -> Vec<String> {
    let re = Regex::new(r"\{|\}|\.\.").unwrap();
    let mut rang = re.split(string).filter(|s| !s.is_empty()).collect_vec();
    if rang.len() < 2 {
        return vec![string.to_string()];
    }
    let mut delta = if rang.len() > 2 {
        rang[2].parse::<i32>().unwrap_or(1)
    } else {
        1
    };
    if delta < 0 {
        (rang[0], rang[1], delta) = (rang[1], rang[0], -delta);
    }
    let rangchars = rang.iter().map(|s| s.chars().collect_vec()).collect_vec();
    if "0123456789-".contains(rangchars[0][0]) {
        let x: i32 = rang[0].parse::<i32>().unwrap_or(-10_000_000);
        let y: i32 = rang[1].parse::<i32>().unwrap_or(-10_000_000);
        if x < -1000000 || y < -1000000 {
            return vec![string.to_string()];
        }
        let pad = max(pad_zeros_needed(rang[0]), pad_zeros_needed(rang[1]));
        if x < y {
            return (x..=y)
                .step_by(delta as usize)
                .map(|i| format!("{:0>pad$}", i))
                .collect_vec();
        } else {
            let mut r = (y..=x)
                .step_by(delta as usize)
                .map(|i| format!("{:0>pad$}", i))
                .collect_vec();
            r.reverse();
            return r;
        }
    } else {
        let x = rangchars[0][rangchars[0].len() - 1];
        let y = rangchars[1][0];
        let mut z = rangchars[0].clone();
        z.remove(z.len() - 1);
        if x < y {
            return (x..=y)
                .step_by(delta as usize)
                .map(|i| {
                    let mut zc = z.clone();
                    zc.push(i);
                    zc.into_iter().collect::<String>()
                })
                .collect_vec();
        } else {
            let mut r = (y..=x)
                .step_by(delta as usize)
                .map(|i| {
                    let mut zc = z.clone();
                    zc.push(i);
                    zc.into_iter().collect::<String>()
                })
                .collect_vec();
            r.reverse();
            return r;
        }
    }
}

fn splatrange(s: &str) -> Vec<String> {
    let re = Regex::new(r"([^\{]*)(\{[^}]+\.\.[^\}]+\})(.*)").unwrap();
    let mut c = match re.captures(s) {
        Some(v) => v.iter().map(|s| s.unwrap().as_str()).collect_vec(),
        None => vec![""],
    };
    c.remove(0);
    if c.len() < 3 {
        return vec![s.to_string()];
    }
    let mut results: Vec<String> = vec![];
    for b in ranged(&c[2]) {
        for x in ranged(&c[1]) {
            results.push(c[0].to_string() + x.as_str() + b.as_str());
        }
    }
    return results;
}

fn main() {
    for test in [
        "simpleNumberRising{1..3}.txt",
        "simpleAlphaDescending-{Z..X}.txt",
        "steppedDownAndPadded-{10..00..5}.txt",
        "minusSignFlipsSequence {030..20..-5}.txt",
        "combined-{Q..P}{2..1}.txt",
        "emoji{🌵..🌶}{🌽..🌾}etc",
        "li{teral",
        "rangeless{}empty",
        "rangeless{random}string",
        "mixedNumberAlpha{5..k}",
        "steppedAlphaRising{P..Z..2}.txt",
        "stops after endpoint-{02..10..3}.txt",
    ] {
        println!(
            "{}->\n{}",
            test,
            splatrange(test)
                .iter()
                .map(|s| format!("    {}\n", s))
                .join("")
        );
    }
}
