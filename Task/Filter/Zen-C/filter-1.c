fn filter_array<T>(a: T*, b: T*, len: int*) {
    let ix = 0;
    for i in 0..*len {
        if !(a[i] % 2) { b[ix++] = a[i]; }
    }
    *len = ix;
}

fn main() {
    let a = [1, 2, 3, 4, 5, 6];
    let b: int* = malloc(a.len * sizeof(int));
    let new_len = a.len;
    filter_array<int>(a, b, &new_len);
    if new_len > 0 {
        // Reduce array size to fit filtered data.
        // Note that 'realloc' will free 'b' automatically.
        autofree let c: int* = realloc(b, new_len * sizeof(int));
        for i in 0..new_len {
            print "{c[i]}, ";
        }
        println "\b\b ";
    } else {
        println "No elements were filtered out.";
        free(b);
    }
}
