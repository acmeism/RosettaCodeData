use std::collections::BTreeSet;

fn powerset<T: Ord + Clone>(mut set: BTreeSet<T>) -> BTreeSet<BTreeSet<T>> {
    if set.is_empty() {
        let mut powerset = BTreeSet::new();
        powerset.insert(set);
        return powerset;
    }
    // Access the first value. This could be replaced with `set.pop_first().unwrap()`
    // But this is an unstable feature
    let entry = set.iter().nth(0).unwrap().clone();
    set.remove(&entry);
    let mut powerset = powerset(set);
    for mut set in powerset.clone().into_iter() {
        set.insert(entry.clone());
        powerset.insert(set);
    }
    powerset
}

fn main() {
    let set = (1..5).collect();
    let set = powerset(set);
    println!("{:?}", set);

    let set = ["a", "b", "c", "d"].iter().collect();
    let set = powerset(set);
    println!("{:?}", set);
}
