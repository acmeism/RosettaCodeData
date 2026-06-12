use regex::Regex;

fn conjugate(w: &str, conj: &Vec<&str>, re: &Regex) -> Vec<String> {
    let r = re.replace(w, "");
    return conj
        .iter()
        .map(|s| String::new() + &r + s)
        .collect::<Vec<String>>();
}

fn main() {
    let gregex = Regex::new(r"[aā]re$").unwrap();
    let conjugators = ["ō", "ās", "at", "āmus", "ātis", "ant"].to_vec();
    let verbvector = ["amāre", "dare"].to_vec();
    for verb in verbvector {
        println!("\nPresent active indicative conjugation of {}:", verb);
        for result in conjugate(verb, &conjugators, &gregex) {
            println!("{}", result);
        }
    }
}
