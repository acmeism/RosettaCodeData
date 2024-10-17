use std::cmp::{Ord, Eq};

fn jort_sort<T: Ord + Eq + Clone>(array: Vec<T>) -> bool {
    // sort the array
    let mut sorted_array = array.to_vec();
    sorted_array.sort();

    // compare to see if it was originally sorted
    for i in 0..array.len() {
        if array[i] != sorted_array[i] {
            return false;
        }
    }

    return true;
}
