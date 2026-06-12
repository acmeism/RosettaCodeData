use regex::Regex;
use eval::{eval, to_value};
use aho_corasick::AhoCorasick;

const ELEMENTS: &[&str; 5] = &["H", "C", "O", "Na", "S",];
const WEIGHTS: &[&str; 5] = &["1.008", "12.011", "15.999", "22.98976928", "32.06",];

fn main() {
    let test_strings = ["H", "H2", "H2O", "Na2SO4", "C6H12", "COOH(C(CH3)2)3CH3"];
    let test_values = [1.008, 2.016, 18.015, 142.03553856000002, 84.162, 186.29500000000002];
    let ac = AhoCorasick::new(ELEMENTS).unwrap();
    let regex1 = Regex::new(r"(?<num>\d+)").unwrap();
    let regex2 = Regex::new(r"(?<group>[A-Z][a-z]{0,2}|\()").unwrap();

    for (i, s) in test_strings.iter().enumerate() {
        let s1 = regex1.replace_all(*s, "*$num");
        let s2 = regex2.replace_all(&s1, "+$group");
        let s3 = ac.replace_all(&s2, WEIGHTS).trim_start_matches("+").replace("(+", "(");
        let mass: Result<eval::Value, eval::Error> = eval(&s3);
        assert_eq!(mass, Ok(to_value(test_values[i])));
        println!("The molar mass of {} checks correctly as {}.", s, test_values[i]);
    }
}
