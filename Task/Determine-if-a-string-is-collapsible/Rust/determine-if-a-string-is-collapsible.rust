fn collapse_string(val: &str) -> String {
    let mut output = String::new();
    let mut chars = val.chars().peekable();

    while let Some(c) = chars.next() {
        while let Some(&b) = chars.peek() {
            if b == c {
                chars.next();
            } else {
                break;
            }
        }

        output.push(c);
    }

    output
}

fn main() {
    let tests = [
        "122333444455555666666777777788888888999999999",
        "",
        "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ",
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                    --- Harry S Truman  ",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship",
    ];

    for s in &tests {
        println!("Old: {:>3} <<<{}>>>", s.len(), s);
        let collapsed = collapse_string(s);
        println!("New: {:>3} <<<{}>>>", collapsed.len(), collapsed);

        println!();
    }
}
