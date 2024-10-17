fn menu_select<'a>(items: &'a [&'a str]) -> &'a str {
    if items.len() == 0 {
        return "";
    }

    let stdin = std::io::stdin();
    let mut buffer = String::new();

    loop {
        for (i, item) in items.iter().enumerate() {
            println!("{}) {}", i + 1, item);
        }
        print!("Pick a number from 1 to {}: ", items.len());

        // Read the user input:
        stdin.read_line(&mut buffer).unwrap();
        println!();

        if let Ok(selected_index) = buffer.trim().parse::<usize>() {
            if 0 < selected_index {
                if let Some(selected_item) = items.get(selected_index - 1) {
                    return selected_item;
                }
            }
        }

        // The buffer will contain the old input, so we need to clear it before we can reuse it.
        buffer.clear();
    }
}

fn main() {
    // Empty list:
    let selection = menu_select(&[]);
    println!("No choice: {:?}", selection);

    // List with items:
    let items = [
        "fee fie",
        "huff and puff",
        "mirror mirror",
        "tick tock",
    ];

    let selection = menu_select(&items);
    println!("You chose: {}", selection);
}
