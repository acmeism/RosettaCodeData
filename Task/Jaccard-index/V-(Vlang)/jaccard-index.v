fn main() {
    tests := [
        []int{},
        [1, 2, 3, 4, 5],
        [1, 3, 5, 7, 9],
        [2, 4, 6, 8, 10],
        [2, 3, 5, 7],
        [8],
    ]
    println("     Set A              Set B         J(A, B)")
    println("---------------------------------------------")
    for a in tests {
        for b in tests {
            j := jaccard_index(a, b)
            println("${a.str():-19}${b.str():-19}${j:.5f}")
        }
    }
}
// calculate index between two integer arrays
fn jaccard_index(a []int, b []int) f64 {
    set_a := to_set(a)
    set_b := to_set(b)
    mut intersection_count := 0
    mut union_map := map[int]bool{}
    // count intersection and build union
    for key in set_a.keys() {
        union_map[key] = true
        if key in set_b { intersection_count++ }
    }
    for key in set_b.keys() {
        union_map[key] = true
    }
    union_count := union_map.len
    if union_count == 0 { return 1.0 }
    if intersection_count == 0 { return 0.0 }
    return f64(intersection_count) / f64(union_count)
}
// convert array to set represented by map[int]bool
fn to_set(arr []int) map[int]bool {
    mut m := map[int]bool{}
    for val in arr {
        m[val] = true
    }
    return m
}
