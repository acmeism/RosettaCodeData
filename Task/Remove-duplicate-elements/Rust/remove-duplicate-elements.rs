use std::collections::HashSet;
use std::hash::Hash;

fn remove_duplicate_elements_hashing<T: Hash + Eq>(elements: &mut Vec<T>) {
    let set: HashSet<_> = elements.drain(..).collect();
    elements.extend(set.into_iter());
}

fn remove_duplicate_elements_sorting<T: Ord>(elements: &mut Vec<T>) {
    elements.sort_unstable(); // order does not matter
    elements.dedup();
}

fn main() {
    let mut sample_elements = vec![0, 0, 1, 1, 2, 3, 2];
    println!("Before removal of duplicates : {:?}", sample_elements);
    remove_duplicate_elements_sorting(&mut sample_elements);
    println!("After removal of duplicates : {:?}", sample_elements);

    let mut sample_elements2 = vec!["ab", "cde", "ab", "xyz", "d", "d", "ab"];
    println!("Before removal of duplicates : {:?}", sample_elements2);
    remove_duplicate_elements_hashing(&mut sample_elements2);
    println!("After removal of duplicates : {:?}", sample_elements2);
}
