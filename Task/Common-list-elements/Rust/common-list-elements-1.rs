use std::iter::FromIterator;
use std::collections::HashSet;
use std::hash::Hash;

fn intersections<T>(sets: &[HashSet<T>]) -> HashSet<T>
where
    T: Clone + Eq + Hash,
{
    sets.iter()
        .enumerate()
        .min_by_key(|&(_, s)| s.len())
        .map(|(smallest_set_index, _)| {
            let (other_sets_left, [smallest_set, other_sets_right @ ..]) =
                sets.split_at(smallest_set_index)
            else {
                unreachable!()
            };
            let other_sets = || other_sets_left.iter().chain(other_sets_right);
            smallest_set
                .iter()
                .filter(|item| other_sets().all(|o| o.contains(item)))
                .cloned()
                .collect()
        })
        .unwrap_or_default()
}

fn intersection_all<T>(a: &Vec<Vec<T>>) -> Vec<T> where T: Copy + Eq + Hash + Ord {
    let hashsets = &a
        .iter()
        .map(|a| HashSet::from_iter(a.iter().cloned()))
        .collect::<Vec<HashSet<T>>>()[..];
    let mut ret: Vec<T> = intersections(hashsets).iter().map(|x| *x).collect();
    ret.sort();
    return ret;
}

fn main() {
    let a = [0, 1, 2, 3, 4, 5].to_vec();
    let b = [4, 2, 0, 3, 4].to_vec();
    let c = [0, 1, 2, 3, 4, 8, 9, 5].to_vec();
    println!("{:?}", intersection_all(&[a, b, c].to_vec()));
    let astring = ["the", "cat", "in", "the", "hat",].to_vec();
    let bstring = ["the", "wind", "in", "the", "grass",].to_vec();
    let cstring = ["the", "ship", "takes", "any", "port", "in", "a", "storm"].to_vec();
    println!("{:?}", intersection_all(&[astring, bstring, cstring].to_vec()));
}
