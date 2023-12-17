fn selection_sort<T: std::cmp::PartialOrd>(arr: &mut [T]) {
    for i in 0 .. arr.len() {
        let unsorted = &mut arr[i..];
        let mut unsorted_min: usize = 0;
        for (j, entry) in unsorted.iter().enumerate() {
            if *entry < unsorted[unsorted_min] {
                unsorted_min = j;
            }
        }
        unsorted.swap(0, unsorted_min);
    }
}
