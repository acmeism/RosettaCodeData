fn binary_search<T:PartialOrd>(v: &[T], searchvalue: T) -> Option<T> {
    let mut lower = 0 as usize;
    let mut upper = v.len() - 1;

    while upper >= lower {
        let mid = (upper + lower) / 2;
        if v[mid] == searchvalue {
            return Some(searchvalue);
        } else if searchvalue < v[mid] {
            upper = mid - 1;
        } else {
            lower = mid + 1;
        }
    }

    None
}
