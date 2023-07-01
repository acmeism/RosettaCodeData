fn leonardo(n int, l0 int, l1 int, add int) []int {
    mut leo := []int{len: n}
    leo[0] = l0
    leo[1] = l1
    for i := 2; i < n; i++ {
        leo[i] = leo[i - 1] + leo[i - 2] + add
    }
    return leo
}

fn main() {
    println("The first 25 Leonardo numbers with L[0] = 1, L[1] = 1 and add number = 1 are:")
    println(leonardo(25, 1, 1, 1))
    println("\nThe first 25 Leonardo numbers with L[0] = 0, L[1] = 1 and add number = 0 are:")
    println(leonardo(25, 0, 1, 0))
}
