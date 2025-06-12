use itertools::Itertools;

fn split_text(s: &str) -> String {
    let mut r = Vec::new();
    for (_, group) in &s.chars().chunk_by(|e| *e) {
        r.push(group.collect::<String>())
    }

    r.join(", ")
}

fn main() {
    println!("output string: {}", split_text("gHHH5YY++///\\"));
}
