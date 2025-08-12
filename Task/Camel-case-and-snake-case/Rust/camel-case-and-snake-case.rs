const HYPHEN: char = '-';
const SPACE: char = ' ';
const UNDERSCORE: char = '_';
const WHITESPACE: &str = " \n\r\t\u{0C}\u{0B}";

fn left_trim(text: &str) -> &str {
    text.trim_start_matches(WHITESPACE.chars().collect::<Vec<_>>().as_slice())
}

fn right_trim(text: &str) -> &str {
    text.trim_end_matches(WHITESPACE.chars().collect::<Vec<_>>().as_slice())
}

fn trim(text: &str) -> &str {
    text.trim_matches(WHITESPACE.chars().collect::<Vec<_>>().as_slice())
}

fn prepare_for_conversion(text: &mut String) {
    *text = trim(text).to_string();
    *text = text.replace(SPACE, &UNDERSCORE.to_string());
    *text = text.replace(HYPHEN, &UNDERSCORE.to_string());
}

fn to_snake_case(camel: &str) -> String {
    let mut text = camel.to_string();
    prepare_for_conversion(&mut text);

    let mut snake = String::new();
    let mut first = true;

    for ch in text.chars() {
        if first {
            snake.push(ch);
            first = false;
        } else if ch.is_ascii_uppercase() {
            if snake.chars().last() == Some(UNDERSCORE) {
                snake.push(ch.to_ascii_lowercase());
            } else {
                snake.push(UNDERSCORE);
                snake.push(ch.to_ascii_lowercase());
            }
        } else {
            snake.push(ch);
        }
    }

    snake
}

fn to_camel_case(snake: &str) -> String {
    let mut text = snake.to_string();
    prepare_for_conversion(&mut text);

    let mut camel = String::new();
    let mut underscore = false;

    for ch in text.chars() {
        if ch == UNDERSCORE {
            underscore = true;
        } else if underscore {
            camel.push(ch.to_ascii_uppercase());
            underscore = false;
        } else {
            camel.push(ch);
        }
    }

    camel
}

fn main() {
    let variable_names = vec![
        "snakeCase",
        "snake_case",
        "variable_10_case",
        "variable10Case",
        "ergo rE tHis",
        "hurry-up-joe!",
        "c://my-docs/happy_Flag-Day/12.doc",
        "  spaces  "
    ];

    println!("{:>48}", "=== To snake_case ===");
    for text in &variable_names {
        println!("{:>34} --> {}", text, to_snake_case(text));
    }

    println!();
    println!("{:>48}", "=== To camelCase ===");
    for text in &variable_names {
        println!("{:>34} --> {}", text, to_camel_case(text));
    }
}
