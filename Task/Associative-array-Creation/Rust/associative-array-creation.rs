use std::collections::HashMap;
fn main() {
    let mut olympic_medals = HashMap::new();
    olympic_medals.insert("United States", (1072, 859, 749));
    olympic_medals.insert("Soviet Union", (473, 376, 355));
    olympic_medals.insert("Great Britain", (246, 276, 284));
    olympic_medals.insert("Germany", (252, 260, 270));
    println!("{:?}", olympic_medals);
}
