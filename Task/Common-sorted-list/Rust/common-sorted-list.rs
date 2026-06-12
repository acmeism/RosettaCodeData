use std::collections::HashSet;

fn unique_sorted_union_reduce(lists: Vec<Vec<i32>>) -> Vec<i32> {
    // Turn each vector into a HashSet to remove duplicates within each list.
    let sets: Vec<HashSet<i32>> = lists
        .into_iter()
        .map(|lst| lst.into_iter().collect::<HashSet<_>>())
        .collect();

    // IMPORTANT FIX: use UNION, not INTERSECTION.
    // `reduce` takes the first set and unions it with the next, and so on.
    let union: HashSet<i32> = sets
        .into_iter()
        .reduce(|a, b| &a | &b)   // <-- Changed from `&a & &b` to `&a | &b`
        .unwrap();                // safe because we know there is at least one set

    // Sort the result
    let mut result: Vec<i32> = union.into_iter().collect();
    result.sort();
    result
}

fn main() {
    let nums1 = vec![5, 1, 3, 8, 9, 4, 8, 7];
    let nums2 = vec![3, 5, 9, 8, 4];
    let nums3 = vec![1, 3, 7, 9];

    let result = unique_sorted_union_reduce(vec![nums1, nums2, nums3]);
    println!("{:?}", result); // -> [1, 3, 4, 5, 7, 8, 9]
}
