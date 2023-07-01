fn strip_comment<'a>(input: &'a str, markers: &[char]) -> &'a str {
    input
        .find(markers)
        .map(|idx| &input[..idx])
        .unwrap_or(input)
        .trim()
}

fn main() {
    println!("{:?}", strip_comment("apples, pears # and bananas", &['#', ';']));
    println!("{:?}", strip_comment("apples, pears ; and bananas", &['#', ';']));
    println!("{:?}", strip_comment("apples, pears and bananas ", &['#', ';']));
}
