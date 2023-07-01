fn splitter(string: &str) -> String {
    let chars: Vec<_> = string.chars().collect();
    let mut result = Vec::new();
    let mut last_mismatch = 0;
    for i in 0..chars.len() {
        if chars.len() == 1 {
            return chars[0..1].iter().collect();
        }
        if i > 0 && chars[i-1] != chars[i] {
            let temp_result: String = chars[last_mismatch..i].iter().collect();
            result.push(temp_result);
            last_mismatch = i;
        }
        if i == chars.len() - 1 {
            let temp_result: String = chars[last_mismatch..chars.len()].iter().collect();
            result.push(temp_result);
        }
    }
    result.join(", ")
}

fn main() {
    let test_string = "g";
    println!("input string: {}", test_string);
    println!("output string: {}", splitter(test_string));

    let test_string = "";
    println!("input string: {}", test_string);
    println!("output string: {}", splitter(test_string));

    let test_string = "gHHH5YY++///\\";
    println!("input string: {}", test_string);
    println!("output string: {}", splitter(test_string));
}
