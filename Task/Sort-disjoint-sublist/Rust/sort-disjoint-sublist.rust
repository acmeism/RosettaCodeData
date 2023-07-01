use std::collections::BTreeSet;

fn disjoint_sort(array: &mut [impl Ord], indices: &[usize]) {
    let mut sorted = indices.to_owned();
    sorted.sort_unstable_by_key(|k| &array[*k]);
    indices
        .iter()
        .zip(sorted.iter())
        .map(|(&a, &b)| if a > b { (b, a) } else { (a, b) })
        .collect::<BTreeSet<_>>()
        .iter()
        .for_each(|(a, b)| array.swap(*a, *b))
}

fn main() {
    let mut array = [7, 6, 5, 4, 3, 2, 1, 0];
    let indices = [6, 1, 7];
    disjoint_sort(&mut array, &indices);
    println!("{:?}", array);
}
