fn van_eck_sequence() -> impl std::iter::Iterator<Item = i32> {
    let mut index = 0;
    let mut last_term = 0;
    let mut last_pos = std::collections::HashMap::new();
    std::iter::from_fn(move || {
        let result = last_term;
        let mut next_term = 0;
        if let Some(v) = last_pos.get_mut(&last_term) {
            next_term = index - *v;
            *v = index;
        } else {
            last_pos.insert(last_term, index);
        }
        last_term = next_term;
        index += 1;
        Some(result)
    })
}

fn main() {
    let mut v = van_eck_sequence().take(1000);
    println!("First 10 terms of the Van Eck sequence:");
    for n in v.by_ref().take(10) {
        print!("{} ", n);
    }
    println!("\nTerms 991 to 1000 of the Van Eck sequence:");
    for n in v.skip(980) {
        print!("{} ", n);
    }
    println!();
}
