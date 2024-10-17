const INPUT1: &str = "http%3A%2F%2Ffoo%20bar%2F";
const INPUT2: &str = "google.com/search?q=%60Abdu%27l-Bah%C3%A1";

fn append_frag(text: &mut String, frag: &mut String) {
    if !frag.is_empty() {
        let encoded = frag.chars()
            .collect::<Vec<char>>()
            .chunks(2)
            .map(|ch| {
                u8::from_str_radix(&ch.iter().collect::<String>(), 16).unwrap()
            }).collect::<Vec<u8>>();
        text.push_str(&std::str::from_utf8(&encoded).unwrap());
        frag.clear();
    }
}

fn decode(text: &str) -> String {
    let mut output = String::new();
    let mut encoded_ch = String::new();
    let mut iter = text.chars();
    while let Some(ch) = iter.next() {
        if ch == '%' {
            encoded_ch.push_str(&format!("{}{}", iter.next().unwrap(), iter.next().unwrap()));
        } else {
            append_frag(&mut output, &mut encoded_ch);
            output.push(ch);
        }
    }
    append_frag(&mut output, &mut encoded_ch);
    output
}

fn main() {
    println!("{}", decode(INPUT1));
    println!("{}", decode(INPUT2));
}
