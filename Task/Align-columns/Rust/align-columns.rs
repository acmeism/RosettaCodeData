use std::iter::{repeat, Extend};

enum AlignmentType {
    Left,
    Center,
    Right,
}

fn get_column_widths(text: &str) -> Vec<usize> {
    let mut widths = Vec::new();
    for line in text
        .lines()
        .map(|s| s.trim_matches(' ').trim_end_matches('$'))
    {
        let lens = line.split('$').map(|s| s.chars().count());
        for (idx, len) in lens.enumerate() {
            if idx < widths.len() {
                widths[idx] = std::cmp::max(widths[idx], len);
            } else {
                widths.push(len);
            }
        }
    }
    widths
}

fn align_columns(text: &str, alignment: AlignmentType) -> String {
    let widths = get_column_widths(text);
    let mut result = String::new();
    for line in text
        .lines()
        .map(|s| s.trim_matches(' ').trim_end_matches('$'))
    {
        for (s, w) in line.split('$').zip(widths.iter()) {
            let blank_count = w - s.chars().count();
            let (pre, post) = match alignment {
                AlignmentType::Left => (0, blank_count),
                AlignmentType::Center => (blank_count / 2, (blank_count + 1) / 2),
                AlignmentType::Right => (blank_count, 0),
            };
            result.extend(repeat(' ').take(pre));
            result.push_str(s);
            result.extend(repeat(' ').take(post));
            result.push(' ');
        }
        result.push_str("\n");
    }
    result
}

fn main() {
    let text = r#"Given$a$text$file$of$many$lines,$where$fields$within$a$line$
are$delineated$by$a$single$'dollar'$character,$write$a$program
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$
column$are$separated$by$at$least$one$space.
Further,$allow$for$each$word$in$a$column$to$be$either$left$
justified,$right$justified,$or$center$justified$within$its$column."#;

    println!("{}", align_columns(text, AlignmentType::Left));
    println!("{}", repeat('-').take(110).collect::<String>());
    println!("{}", align_columns(text, AlignmentType::Center));
    println!("{}", repeat('-').take(110).collect::<String>());
    println!("{}", align_columns(text, AlignmentType::Right));
}
