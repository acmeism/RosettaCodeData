import math

fn main() {
    list := [1.0, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8, 6, 2, 9, 11, 10, 3]
    mut max_diff := -1.0
    mut max_pairs := [][2]f64{}
    for i in 1..list.len {
        diff := math.abs(list[i-1] - list[i])
        if diff > max_diff {
            max_diff = diff
            max_pairs = [[list[i-1], list[i]]!]
        } else if diff == max_diff {
            max_pairs << [list[i-1], list[i]]!
        }
    }
    println("The maximum difference between adjacent pairs of the list is: $max_diff")
    println("The pairs with this difference are: $max_pairs")
}
