fn jort_sort<T>(slice: &[T]) -> bool
where
    T: Ord + PartialEq + Clone,
{
    let mut sorted = slice.to_vec();
    sorted.sort_unstable();

    slice == sorted
}
