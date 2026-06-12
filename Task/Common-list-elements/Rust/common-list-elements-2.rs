use std::collections::HashSet;
use std::hash::Hash;

fn intersection_all<T>(list: &Vec<Vec<T>>) -> Vec<T>
where
    T: Copy + Eq + Hash + Ord,
{
    let sets: Vec<HashSet<_>> = list.iter().map(|v| v.iter().copied().collect()).collect();

    let mut inter: Vec<T> = sets
        .into_iter()
        .reduce(|s, t| s.intersection(&t).copied().collect())
        .unwrap_or_default()
        .into_iter()
        .collect();

    inter.sort();
    inter
}

fn main() {
    let a = vec![0, 1, 2, 3, 4, 5];
    let b = vec![4, 2, 0, 3, 4];
    let c = vec![0, 1, 2, 3, 4, 8, 9, 5];

    println!("{:?}", intersection_all(&vec![a, b, c]));

    let a_string = vec!["the", "cat", "in", "the", "hat"];
    let b_string = vec!["the", "wind", "in", "the", "grass"];
    let c_string = vec!["the", "ship", "takes", "any", "port", "in", "a", "storm"];

    println!(
        "{:?}",
        intersection_all(&vec![a_string, b_string, c_string])
    );
}
