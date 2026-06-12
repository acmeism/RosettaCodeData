fn main() {
    let mut v = (2u32..=5)
        .flat_map(|a| (2u32..=5).map(move |b| a.pow(b)))
        .collect::<Vec<_>>();
    v.sort();
    v.dedup();
    println!("{v:?}");
}
