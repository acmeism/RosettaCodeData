fn filter_array_in_place<T>(a: T*, len: int*) {
    let ix = 0;
    for i in 0..*len {
        if !(a[i] % 2) { a[ix++] = a[i]; }
    }
    *len = ix;
}

fn main() {
    let a = [1, 2, 3, 4, 5, 6];
    let old_len = a.len;
    let new_len = old_len;
    filter_array_in_place<int>(a, &new_len);

    // As 'realloc' may create a new array, we set the remaining
    // elements to 0 instead.
    for i in new_len..old_len { a[i] = 0; }
    for i in 0..new_len {
        print "{a[i]}, ";
    }
    println "\b\b ";
}
