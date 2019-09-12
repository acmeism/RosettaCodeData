fn main() {
    let mut words = ["Here", "are", "some", "sample", "strings", "to", "be", "sorted"];
    words.sort_by(|l, r| Ord::cmp(&r.len(), &l.len()).then(Ord::cmp(l, r)));
    println!("{:?}", words);
}
