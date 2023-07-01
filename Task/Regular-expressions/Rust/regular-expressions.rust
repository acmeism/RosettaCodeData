use regex::Regex;

fn main() {
    let s = "I am a string";

    if Regex::new("string$").unwrap().is_match(s) {
        println!("Ends with string.");
    }

    println!("{}", Regex::new(" a ").unwrap().replace(s, " another "));
}
