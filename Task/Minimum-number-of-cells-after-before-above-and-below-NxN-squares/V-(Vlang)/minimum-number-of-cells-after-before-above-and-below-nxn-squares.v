fn print_min_cells(n int) {
    println("Minimum number of cells after, before, above and below $n x $n square:")
    for r in 0..n {
        mut cells := []int{len: n}
        for c in 0..n {
            nums := [n - r - 1, r, c, n - c - 1]
            mut min := n
            for num in nums {
                if num < min {
                    min = num
                }
            }
            cells[c] = min
        }
        println(cells)
    }
}

fn main() {
    for n in [23, 10, 9, 2, 1] {
        print_min_cells(n)
        println('')
    }
}
