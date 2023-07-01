fn main() {
    keys := ["a", "b", "c"]
    vals := [1, 2, 3]
    mut hash := map[string]int{}
    for i, key in keys {
        hash[key] = vals[i]
    }
    println(hash)
}
