fn main() {
    println(mode([2, 7, 1, 8, 2]))
    println(mode([2, 7, 1, 8, 2, 8]))
}

fn mode(a []int) []int {
    mut m := map[int]int{}
    for v in a {
        m[v]++
    }
    mut mode := []int{}
    mut n := 0
    for k, v in m {
        match true {
            v > n {
                n = v
                mode = [k]
            }
            v<n{}
            else {
                mode << k
            }
        }
    }
    return mode
}
