fn squeezable_string<'a>(s: &'a str, squeezable: char) -> impl Iterator<Item = char> + 'a {
    let mut previous = None;

    s.chars().filter(move |c| match previous {
        Some(p) if p == squeezable && p == *c => false,
        _ => {
            previous = Some(*c);
            true
        }
    })
}

fn main() {
    fn show(input: &str, c: char) {
        println!("Squeeze: '{}'", c);
        println!("Input ({} chars): \t{}", input.chars().count(), input);
        let output: String = squeezable_string(input, c).collect();
        println!("Output ({} chars): \t{}", output.chars().count(), output);
        println!();
    }

    let harry = r#"I never give 'em hell, I just tell the truth, and they think it's hell.
    ---  Harry S Truman"#;

    #[rustfmt::skip]
    let inputs = [
        ("", ' '),
        (r#""If I were two-faced, would I be wearing this one?" --- Abraham Lincoln "#, '-'),
        ("..1111111111111111111111111111111111111111111111111111111111111117777888", '7'),
        (harry, ' '),
        (harry, '-'),
        (harry, 'r'),
        ("The better the 4-wheel drive, the further you'll be from help when ya get stuck!", 'e'),
        ("headmistressship", 's'),
    ];

    inputs.iter().for_each(|(input, c)| show(input, *c));
}
