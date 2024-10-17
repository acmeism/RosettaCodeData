use std::collections::HashSet;

fn main() {
    let a: HashSet<_> = ["John", "Bob", "Mary", "Serena"]
        .iter()
        .collect();
    let b = ["Jim", "Mary", "John", "Bob"]
        .iter()
        .collect();

    let diff = a.symmetric_difference(&b);
    println!("{:?}", diff);
}
