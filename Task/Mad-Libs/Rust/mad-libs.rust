extern crate regex;

use regex::Regex;
use std::collections::HashMap;
use std::io;

fn main() {
    let mut input_line = String::new();
    let mut template = String::new();

    println!("Please enter a multi-line story template with <parts> to replace, terminated by a blank line.\n");
    loop {
        io::stdin()
            .read_line(&mut input_line)
            .expect("The read line failed.");
        if input_line.trim().is_empty() {
            break;
        }
        template.push_str(&input_line);
        input_line.clear();
    }

    let re = Regex::new(r"<[^>]+>").unwrap();
    let mut parts: HashMap<_, _> = re
        .captures_iter(&template)
        .map(|x| (x.get(0).unwrap().as_str().to_string(), "".to_string()))
        .collect();
    if parts.is_empty() {
        println!("No <parts> to replace.\n");
    } else {
        for (k, v) in parts.iter_mut() {
            println!("Please provide a replacement for {}: ", k);
            io::stdin()
                .read_line(&mut input_line)
                .expect("The read line failed.");
            *v = input_line.trim().to_string();
            println!();
            template = template.replace(k, v);
            input_line.clear();
        }
    }
    println!("Resulting story:\n\n{}", template);
}
