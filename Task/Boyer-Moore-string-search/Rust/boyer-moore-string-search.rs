fn display(numbers: &Vec<i32>) {
    print!("[");
    for (i, num) in numbers.iter().enumerate() {
        if i > 0 {
            print!(", ");
        }
        print!("{}", num);
    }
    println!("]");
}

fn string_search_single(haystack: &str, needle: &str) -> i32 {
    // Rust's standard library doesn't have Boyer-Moore searcher directly,
    // but we can use the built-in find method which is efficient
    match haystack.find(needle) {
        Some(index) => index as i32,
        None => -1,
    }
}

fn string_search(haystack: &str, needle: &str) -> Vec<i32> {
    let mut result: Vec<i32> = Vec::new();
    let mut start: usize = 0;

    while start < haystack.len() {
        let haystack_reduced = &haystack[start..];
        let index = string_search_single(haystack_reduced, needle);

        if index >= 0 {
            result.push((start as i32) + index);
            start += index as usize + needle.len();
        } else {
            break;
        }
    }

    result
}

fn main() {
    let texts = vec![
        "GCTAGCTCTACGAGTCTA",
        "GGCTATAATGCGTA",
        "there would have been a time for such a word",
        "needle need noodle needle",
        "DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages",
        "Nearby farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk."
    ];

    let patterns = vec!["TCTA", "TAATAAA", "word", "needle", "and", "alfalfa"];

    for i in 0..texts.len() {
        println!("text{} = {}", i + 1, texts[i]);
    }
    println!();

    for i in 0..texts.len() {
        let indexes = string_search(texts[i], patterns[i]);
        print!("Found \"{}\" in 'text{}' at indexes ", patterns[i], i + 1);
        display(&indexes);
    }
}
