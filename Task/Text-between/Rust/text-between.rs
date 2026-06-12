// Output should always borrow from input string
fn text_between<'a>(input: &'a str, start: &str, end: &str) -> &'a str {
    assert!(
        !start.is_empty() && !end.is_empty(),
        "delimiters must be set and not empty"
    );

    let start_idx = if start == "start" {
        0
    } else {
        input
            .find(start)
            .map(|idx| idx + start.len())
            .unwrap_or(input.len())
    };

    let remaining = &input[start_idx..];

    let end_idx = if end == "end" {
        remaining.len()
    } else {
        remaining.find(end).unwrap_or(remaining.len())
    };

    &remaining[..end_idx]
}

fn main() {
    let tests = [
        ("Hello Rosetta Code world", "Hello ", " world"),
        ("Hello Rosetta Code world", "start", " world"),
        ("Hello Rosetta Code world", "Hello ", "end"),
        (
            "</div><div style=\"chinese\">你好嗎</div>",
            "<div style=\"chinese\">",
            "</div>",
        ),
        (
            "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">",
            "<text>",
            "<table>",
        ),
        (
            "<table style=\"myTable\"><tr><td>hello world</td></tr></table>",
            "<table>",
            "</table>",
        ),
        (
            "The quick brown fox jumps over the lazy other fox",
            "quick ",
            " fox",
        ),
        ("One fish two fish red fish blue fish", "fish ", " red"),
        ("FooBarBazFooBuxQuux", "Foo", "Foo"),
    ];

    for (input, start, end) in tests {
        let output = text_between(input, start, end);

        println!(" Input: \"{input}\"");
        println!(" Start: \"{start}\"");
        println!("   End: \"{end}\"");
        println!("Output: \"{output}\"\n");
    }
}
