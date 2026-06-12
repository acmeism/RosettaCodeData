fn first_missing_positive(a []int) int {
    mut b := []int{}
    for e in a {
        if e > 0 {b << e}
    }
    b.sort<int>()
    le := b.len
    if le == 0 || b[0] > 1 {return 1}
    for i in 1..le {
        if b[i]-b[i-1] > 1 {return b[i-1] + 1}
    }
    return b[le-1] + 1
}

fn main() {
    println("The first missing positive integers for the following arrays are:\n")
    aa := [[1, 2, 0], [3, 4, -1, 1], [7, 8, 9, 11, 12], [1, 2, 3, 4, 5],
        [-6, -5, -2, -1], [5, -5], [-2], [1]]
    for a in aa {
        println("$a -> ${first_missing_positive(a)}")
    }
}
